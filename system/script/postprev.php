<?php

use Sunlight\Core;
use Sunlight\Post;
use Sunlight\Util\Request;

chdir(__DIR__ . '/../../'); // nasimulovat skript v rootu

require './system/bootstrap.php';
Core::init('./');

echo Post::render(_e(Request::post('content')));
