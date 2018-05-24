<?php

namespace Sunlight\Composer;

use Sunlight\Util\Filesystem;
use Sunlight\Util\Json;

/**
 * Composer repository
 *
 * Provides access to a composer.json file and its installed packages.
 */
class Repository
{
    /** @var string */
    private $composerJsonPath;
    /** @var string|null */
    private $directory;
    /** @var \stdClass|null */
    private $package;
    /** @var string|null */
    private $vendorPath;
    /** @var \stdClass[]|null name-indexed */
    private $installedPackages;
    /** @var array|null */
    private $classMap;

    /**
     * @param string $composerJsonPath
     */
    public function __construct($composerJsonPath)
    {
        $this->composerJsonPath = $composerJsonPath;
    }

    /**
     * @return string
     */
    public function getComposerJsonPath()
    {
        return $this->composerJsonPath;
    }

    /**
     * Get data from composer.json
     *
     * @return \stdClass
     */
    public function getDefinition()
    {
        if ($this->package === null) {
            $this->package = Json::decode(file_get_contents($this->composerJsonPath), false);
        }

        return $this->package;
    }

    /**
     * Get directory where composer.json is located
     *
     * @return string
     */
    public function getDirectory()
    {
        if ($this->directory === null) {
            $this->directory = dirname($this->composerJsonPath);
        }

        return $this->directory;
    }

    /**
     * @return string
     */
    public function getVendorPath()
    {
        if ($this->vendorPath === null) {
            $package = $this->getDefinition();

            if (isset($package->config->{'vendor-dir'})) {
                $vendorDir = $package->config->{'vendor-dir'};

                if (Filesystem::isAbsolutePath($vendorDir)) {
                    throw new \UnexpectedValueException('Absolute vendor dir is not supported');
                }
            } else {
                $vendorDir = 'vendor';
            }

            $this->vendorPath = Filesystem::normalizeWithBasePath($this->getDirectory(), $vendorDir);
        }

        return $this->vendorPath;
    }

    /**
     * @return string
     */
    public function getPackagePath(\stdClass $package)
    {
        return $this->getVendorPath() . '/' . $package->name;
    }

    /**
     * @return string
     */
    public function getPackageComposerJsonPath(\stdClass $package)
    {
        return $this->getPackagePath($package) . '/composer.json';
    }

    /**
     * @return string
     */
    public function getInstalledJsonPath()
    {
        return $this->getVendorPath() . '/composer/installed.json';
    }

    /**
     * @return \stdClass[] name-indexed
     */
    public function getInstalledPackages()
    {
        if ($this->installedPackages === null) {
            $this->installedPackages = array();

            if (is_file($installedJson = $this->getInstalledJsonPath())) {
                foreach (Json::decode(file_get_contents($installedJson), false) as $package) {
                    $this->installedPackages[$package->name] = $package;
                }
            }
        }

        return $this->installedPackages;
    }

    /**
     * @return array
     */
    public function getClassMap()
    {
        if ($this->classMap === null) {
            $classMapPath = $this->getVendorPath() . '/composer/autoload_classmap.php';

            if (is_file($classMapPath)) {
                $this->classMap = require $classMapPath;
            } else {
                $this->classMap = array();
            }
        }

        return $this->classMap;
    }
}
