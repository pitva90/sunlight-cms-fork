<?php

namespace Sunlight\Composer;

use Sunlight\Util\Filesystem;

class ComposerBridge
{
    static function clearCache(): void
    {
        Filesystem::emptyDirectory(__DIR__ . '/../../cache', function (\SplFileInfo $item) {
            return $item->isDir() || $item->getFilename() !== '.gitkeep';
        });
    }

    static function updateDirectoryAccess(): void
    {
        $root = __DIR__ . '/../../../';

        foreach (['vendor', 'bin', '.git'] as $dir) {
            if (is_dir($root . $dir)) {
                Filesystem::denyAccessToDirectory($root . $dir);
            }
        }
    }


    static function moveBootstrapAssets(): void {
        $root = __DIR__ . '/../../../';
        $source = $root.'vendor/twbs/bootstrap/dist';
        $destination = $root.'admin/public/bootstrap';

        if (!is_dir($destination)) {
            mkdir($destination, 0777, true);
        }

        $files = [
            'css/bootstrap.min.css',
            'js/bootstrap.bundle.min.js'
        ];

        foreach ($files as $file) {
            $sourceFile = $source . '/' . $file;
            $destinationFile = $destination . '/' . basename($file);

            if (file_exists($sourceFile)) {
                copy($sourceFile, $destinationFile);
            }
        }
    }
}

