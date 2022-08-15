<?php

namespace Sunlight\Util;

/**
 * Password utility
 */
class Password
{
    /** Default algorithm */
    const PREFERRED_ALGO = 'sha256';
    /** Old MD5 algorithm */
    const MD5_LEGACY_ALGO = 'md5_legacy';
    /** Number of PBKDF2 iterations */
    const PBKDF2_ITERATIONS = 50000;
    /** Length of generated salts */
    const GENERATED_SALT_LENGTH = 64;

    /** @var string */
    private $algo;
    /** @var int */
    private $iterations;
    /** @var string */
    private $salt;
    /** @var string */
    private $hash;

    function __construct(string $algo, int $iterations, string $salt, string $hash)
    {
        $this->algo = $algo;
        $this->iterations = $iterations;
        $this->salt = $salt;
        $this->hash = $hash;
    }

    /**
     * Parse a stored password
     *
     * @throws \InvalidArgumentException if the value is not valid
     */
    static function load(string $storedPassword): self
    {
        $segments = explode(':', $storedPassword, 4);

        if (
            count($segments) !== 4
            || !ctype_digit($segments[1])
            || $segments[2] === ''
            || $segments[3] === ''
        ) {
            throw new \InvalidArgumentException('Invalid password format');
        }

        return new self($segments[0], (int) $segments[1], $segments[2], $segments[3]);
    }

    /**
     * Create new instance from the given plain password
     */
    static function create(string $plainPassword): self
    {
        $algo = self::PREFERRED_ALGO;
        $iterations = self::PBKDF2_ITERATIONS;
        $salt = StringGenerator::generateString(self::GENERATED_SALT_LENGTH);
        $hash = self::hash($algo, $iterations, $salt, $plainPassword);

        return new self($algo, $iterations, $salt, $hash);
    }

    /**
     * Create a hash
     *
     * @throws \InvalidArgumentException on invalid arguments
     */
    private static function hash(string $algo, int $iterations, string $salt, string $plainPassword): string
    {
        if (!is_string($plainPassword)) {
            throw new \InvalidArgumentException('Password must be a string');
        }
        if ($plainPassword === '') {
            throw new \InvalidArgumentException('Password must not be empty');
        }

        if ($algo === self::MD5_LEGACY_ALGO) {
            // backward compatibility
            if ($iterations !== 0) {
                throw new \InvalidArgumentException(sprintf('Iterations is expected to be 0 if algo = "%s"', $algo));
            }

            $hash = md5($salt . $plainPassword . $salt);
        } else {
            $hash = hash_pbkdf2($algo, $plainPassword, $salt, $iterations);
        }

        return $hash;
    }

    /**
     * Convert to a string
     *
     * This methods calls build() internally
     */
    function __toString(): string
    {
        return $this->build();
    }

    /**
     * Build the password string
     */
    function build(): string
    {
        return sprintf(
            '%s:%d:%s:%s',
            $this->algo,
            $this->iterations,
            $this->salt,
            $this->hash
        );
    }

    /**
     * Match the given plain password against this instance
     */
    function match(string $plainPassword): bool
    {
        if ($plainPassword === '') {
            return false;
        }

        $hash = self::hash($this->algo, $this->iterations, $this->salt, $plainPassword);

        return
            is_string($this->hash)
            && $this->hash !== ''
            && is_string($hash)
            && $hash !== ''
            && $hash === $this->hash;
    }

    /**
     * See if the password should be updated
     */
    function shouldUpdate(): bool
    {
        return
            $this->algo !== self::PREFERRED_ALGO
            || $this->iterations < self::PBKDF2_ITERATIONS;
    }

    /**
     * Update the password
     *
     * This method updates the algo (if needed), salt and the hash.
     */
    function update(string $plainPassword): void
    {
        $this->algo = self::PREFERRED_ALGO;
        $this->iterations = max(self::PBKDF2_ITERATIONS, $this->iterations);
        $this->salt = StringGenerator::generateString(self::GENERATED_SALT_LENGTH);
        $this->hash = self::hash($this->algo, $this->iterations, $this->salt, $plainPassword);
    }
}
