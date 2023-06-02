CREATE TABLE `sunlight_article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `perex` mediumtext NOT NULL,
  `picture_uid` varchar(32) DEFAULT NULL,
  `content` longtext NOT NULL,
  `author` int(11) NOT NULL,
  `home1` int(11) NOT NULL,
  `home2` int(11) NOT NULL DEFAULT -1,
  `home3` int(11) NOT NULL DEFAULT -1,
  `time` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `public` tinyint(1) NOT NULL DEFAULT 1,
  `comments` tinyint(1) NOT NULL DEFAULT 1,
  `commentslocked` tinyint(1) NOT NULL DEFAULT 0,
  `confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `showinfo` tinyint(1) NOT NULL DEFAULT 1,
  `readnum` int(11) NOT NULL DEFAULT 0,
  `rateon` tinyint(1) NOT NULL DEFAULT 1,
  `ratenum` int(11) NOT NULL DEFAULT 0,
  `ratesum` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `author` (`author`),
  KEY `home1` (`home1`),
  KEY `home2` (`home2`),
  KEY `home3` (`home3`),
  KEY `time` (`time`),
  KEY `visible` (`visible`),
  KEY `public` (`public`),
  KEY `confirmed` (`confirmed`),
  KEY `ratenum` (`ratenum`),
  KEY `ratesum` (`ratesum`),
  KEY `slug` (`slug`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_box` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ord` int(11) NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` mediumtext NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `public` tinyint(1) NOT NULL DEFAULT 1,
  `level` int(11) NOT NULL DEFAULT 0,
  `template` varchar(255) NOT NULL,
  `layout` varchar(255) NOT NULL,
  `slot` varchar(64) NOT NULL,
  `page_ids` mediumtext DEFAULT NULL,
  `page_children` tinyint(1) NOT NULL DEFAULT 0,
  `class` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ord` (`ord`),
  KEY `visible` (`visible`),
  KEY `public` (`public`),
  KEY `slot` (`slot`),
  KEY `level` (`level`),
  KEY `template` (`template`(191)),
  KEY `layout` (`layout`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sunlight_box` (`id`, `ord`, `title`, `content`, `visible`, `public`, `level`, `template`, `layout`, `slot`, `page_ids`, `page_children`, `class`) VALUES
(1,	1,	'Menu',	'[hcm]menu_tree[/hcm]',	1,	1,	0,	'default',	'default',	'right',	NULL,	0,	NULL),
(2,	2,	'Vyhledávání',	'[hcm]search[/hcm]',	1,	1,	0,	'default',	'default',	'right',	NULL,	0,	NULL),
(3,	3,	'',	'<br><p class=\"center\"><a href=\'https://sunlight-cms.cz/\' title=\'SunLight CMS - open source redakční systém zdarma\'><img src=\'https://sunlight-cms.cz/icon.png\' alt=\'SunLight CMS - open source redakční systém zdarma\' style=\'width:88px;height:31px;border:0;\'></a></p>',	1,	1,	0,	'default',	'default',	'right',	NULL,	0,	NULL);

CREATE TABLE `sunlight_gallery_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `home` int(11) NOT NULL,
  `ord` int(11) NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL DEFAULT '',
  `prev` varchar(255) NOT NULL DEFAULT '',
  `full` varchar(255) NOT NULL DEFAULT '',
  `in_storage` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `home` (`home`),
  KEY `full` (`full`(8)),
  KEY `in_storage` (`in_storage`),
  KEY `ord` (`ord`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_iplog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(45) NOT NULL,
  `type` int(11) NOT NULL,
  `time` bigint(20) NOT NULL,
  `var` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `ip` (`ip`),
  KEY `type` (`type`),
  KEY `time` (`time`),
  KEY `var` (`var`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_log` (
  `id` varchar(36) NOT NULL,
  `level` tinyint(4) NOT NULL,
  `category` varchar(64) NOT NULL,
  `time` bigint(20) NOT NULL,
  `message` text NOT NULL,
  `method` varchar(32) DEFAULT NULL,
  `url` varchar(2048) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `context` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `level` (`level`),
  KEY `category` (`category`),
  KEY `time` (`time`),
  KEY `message` (`message`(255)),
  KEY `method` (`method`),
  KEY `url` (`url`(255)),
  KEY `ip` (`ip`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `heading` varchar(255) NOT NULL DEFAULT '',
  `slug` mediumtext NOT NULL,
  `slug_abs` tinyint(1) NOT NULL DEFAULT 0,
  `description` varchar(255) NOT NULL DEFAULT '',
  `type` tinyint(4) NOT NULL,
  `type_idt` varchar(16) DEFAULT NULL,
  `node_parent` int(11) DEFAULT NULL,
  `node_level` int(11) NOT NULL DEFAULT 0,
  `node_depth` int(11) NOT NULL DEFAULT 0,
  `perex` mediumtext NOT NULL,
  `ord` int(11) NOT NULL DEFAULT 0,
  `content` longtext NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `public` tinyint(1) NOT NULL DEFAULT 1,
  `level` int(11) NOT NULL DEFAULT 0,
  `level_inherit` tinyint(1) NOT NULL DEFAULT 0,
  `show_heading` tinyint(1) NOT NULL DEFAULT 1,
  `events` varchar(255) DEFAULT NULL,
  `link_new_window` tinyint(1) NOT NULL DEFAULT 0,
  `link_url` varchar(255) DEFAULT NULL,
  `layout` varchar(255) DEFAULT NULL,
  `layout_inherit` tinyint(1) NOT NULL DEFAULT 0,
  `var1` int(11) DEFAULT NULL,
  `var2` int(11) DEFAULT NULL,
  `var3` int(11) DEFAULT NULL,
  `var4` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `level` (`level`),
  KEY `type` (`type`),
  KEY `ord` (`ord`),
  KEY `visible` (`visible`),
  KEY `public` (`public`),
  KEY `show_heading` (`show_heading`),
  KEY `var1` (`var1`),
  KEY `var2` (`var2`),
  KEY `var3` (`var3`),
  KEY `var4` (`var4`),
  KEY `slug_seo_abs` (`slug_abs`),
  KEY `slug_seo` (`slug`(16)),
  KEY `node_parent` (`node_parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sunlight_page` (`id`, `title`, `heading`, `slug`, `slug_abs`, `description`, `type`, `type_idt`, `node_parent`, `node_level`, `node_depth`, `perex`, `ord`, `content`, `visible`, `public`, `level`, `level_inherit`, `show_heading`, `events`, `link_new_window`, `link_url`, `layout`, `layout_inherit`, `var1`, `var2`, `var3`, `var4`) VALUES
(1,	'',	'',	'index',	0,	'',	1,	NULL,	NULL,	0,	0,	'',	1,	'',	1,	1,	0,	1,	1,	NULL,	0,	NULL,	NULL,	0,	0,	0,	0,	0);

CREATE TABLE `sunlight_pm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` int(11) NOT NULL,
  `sender_readtime` bigint(20) NOT NULL DEFAULT 0,
  `sender_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `receiver` int(11) NOT NULL,
  `receiver_readtime` bigint(20) NOT NULL DEFAULT 0,
  `receiver_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `update_time` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `sender` (`sender`),
  KEY `receiver` (`receiver`),
  KEY `update_time` (`update_time`),
  KEY `sender_deleted` (`sender_deleted`),
  KEY `receiver_deleted` (`receiver_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_poll` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) NOT NULL,
  `question` varchar(96) NOT NULL,
  `answers` mediumtext NOT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `votes` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL,
  `home` int(11) NOT NULL,
  `xhome` int(11) NOT NULL DEFAULT -1,
  `subject` varchar(48) NOT NULL DEFAULT '',
  `text` mediumtext NOT NULL,
  `author` int(11) NOT NULL DEFAULT -1,
  `guest` varchar(24) NOT NULL DEFAULT '',
  `time` bigint(20) NOT NULL,
  `ip` varchar(45) NOT NULL DEFAULT '',
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `bumptime` bigint(20) NOT NULL DEFAULT 0,
  `sticky` tinyint(1) NOT NULL DEFAULT 0,
  `flag` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `bumptime` (`bumptime`),
  KEY `type` (`type`),
  KEY `home` (`home`),
  KEY `xhome` (`xhome`),
  KEY `author` (`author`),
  KEY `time` (`time`),
  KEY `sticky` (`sticky`),
  KEY `flag` (`flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_redirect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old` varchar(255) NOT NULL,
  `new` varchar(255) NOT NULL,
  `permanent` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `old` (`old`(191)),
  KEY `active` (`active`),
  KEY `permanent` (`permanent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_setting` (
  `var` varchar(24) NOT NULL,
  `val` mediumtext NOT NULL,
  `preload` tinyint(1) NOT NULL DEFAULT 0,
  `web` tinyint(1) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  PRIMARY KEY (`var`),
  KEY `preload` (`preload`),
  KEY `web` (`web`),
  KEY `admin` (`admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sunlight_setting` (`var`, `val`, `preload`, `web`, `admin`) VALUES
('accactexpire',	'1200',	1,	1,	1),
('admin_index_custom',	'',	0,	0,	1),
('admin_index_custom_pos',	'1',	0,	0,	1),
('adminlinkprivate',	'0',	1,	1,	1),
('adminpagelist_mode',	'0',	1,	0,	1),
('adminscheme',	'0',	1,	0,	1),
('adminscheme_dark',	'0',	1,	0,	1),
('antispamtimeout',	'60',	1,	1,	1),
('article_pic_h',	'600',	1,	1,	1),
('article_pic_thumb_h',	'200',	1,	1,	1),
('article_pic_thumb_w',	'200',	1,	1,	1),
('article_pic_w',	'600',	1,	1,	1),
('articlesperpage',	'15',	1,	1,	1),
('artrateexpire',	'604800',	1,	1,	1),
('artreadexpire',	'18000',	1,	1,	1),
('atreplace',	'',	1,	1,	1),
('author',	'',	1,	1,	1),
('bbcode',	'1',	1,	1,	1),
('cacheid',	'0',	1,	1,	1),
('captcha',	'1',	1,	1,	1),
('comments',	'1',	1,	1,	1),
('commentsperpage',	'10',	1,	1,	1),
('cron_auth',	'',	0,	1,	1),
('cron_auto',	'1',	1,	1,	1),
('cron_times',	'',	1,	1,	1),
('dbversion',	'8.0.0',	1,	1,	1),
('default_template',	'default',	1,	1,	1),
('defaultgroup',	'3',	1,	1,	1),
('description',	'',	1,	1,	1),
('extratopicslimit',	'12',	1,	1,	1),
('favicon',	'0',	1,	1,	1),
('galdefault_per_page',	'9',	1,	1,	1),
('galdefault_per_row',	'3',	1,	1,	1),
('galdefault_thumb_h',	'110',	1,	1,	1),
('galdefault_thumb_w',	'147',	1,	1,	1),
('galuploadresize_h',	'565',	1,	1,	1),
('galuploadresize_w',	'750',	1,	1,	1),
('index_page_id',	'1',	1,	1,	1),
('install_check',	'',	1,	1,	1),
('language',	'cs',	1,	1,	1),
('language_allowcustom',	'0',	1,	1,	1),
('log_level',	'5',	1,	1,	1),
('log_retention',	'30',	1,	1,	1),
('lostpass',	'1',	1,	1,	1),
('lostpassexpire',	'1800',	1,	1,	1),
('mailerusefrom',	'0',	1,	1,	1),
('maintenance_interval',	'259200',	1,	1,	1),
('maxloginattempts',	'20',	1,	1,	1),
('maxloginexpire',	'900',	1,	1,	1),
('messages',	'1',	1,	1,	1),
('messagesperpage',	'10',	1,	1,	1),
('notpublicsite',	'0',	1,	1,	1),
('pagingmode',	'3',	1,	1,	1),
('pollvoteexpire',	'604800',	1,	1,	1),
('postadmintime',	'172800',	1,	1,	1),
('pretty_urls',	'0',	1,	1,	1),
('profileemail',	'0',	1,	1,	1),
('ratemode',	'2',	1,	1,	1),
('registration',	'1',	1,	1,	1),
('registration_confirm',	'0',	1,	1,	1),
('registration_grouplist',	'0',	1,	1,	1),
('rules',	'',	0,	1,	1),
('sboxmemory',	'20',	1,	1,	1),
('search',	'1',	1,	1,	1),
('show_avatars',	'1',	1,	1,	1),
('showpages',	'4',	1,	1,	1),
('sysmail',	'',	1,	1,	1),
('thumb_cleanup_threshold',	'604800',	1,	1,	1),
('thumb_touch_threshold',	'43200',	1,	1,	1),
('time_format',	'j.n.Y G:i',	1,	1,	1),
('title',	'',	1,	1,	1),
('titleseparator',	'-',	1,	1,	1),
('titletype',	'2',	1,	1,	1),
('topic_hot_ratio',	'20',	1,	1,	1),
('topicsperpage',	'30',	1,	1,	1),
('ulist',	'0',	1,	1,	1),
('uploadavatar',	'1',	1,	1,	1),
('version_check',	'1',	1,	1,	1);

CREATE TABLE `sunlight_shoutbox` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `public` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `levelshift` tinyint(1) NOT NULL DEFAULT 0,
  `username` varchar(24) NOT NULL,
  `publicname` varchar(24) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `logincounter` int(11) NOT NULL DEFAULT 0,
  `registertime` bigint(20) NOT NULL DEFAULT 0,
  `activitytime` bigint(20) NOT NULL DEFAULT 0,
  `blocked` tinyint(1) NOT NULL DEFAULT 0,
  `massemail` tinyint(1) NOT NULL DEFAULT 0,
  `wysiwyg` tinyint(1) NOT NULL DEFAULT 0,
  `public` tinyint(1) NOT NULL DEFAULT 1,
  `language` varchar(12) NOT NULL DEFAULT '',
  `ip` varchar(45) NOT NULL DEFAULT '',
  `email` varchar(191) NOT NULL,
  `avatar` varchar(32) DEFAULT NULL,
  `note` mediumtext NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `publicname` (`publicname`),
  KEY `group` (`group_id`),
  KEY `logincounter` (`logincounter`),
  KEY `registertime` (`registertime`),
  KEY `activitytime` (`activitytime`),
  KEY `blocked` (`blocked`),
  KEY `massemail` (`massemail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sunlight_user` (`id`, `group_id`, `levelshift`, `username`, `publicname`, `password`, `logincounter`, `registertime`, `activitytime`, `blocked`, `massemail`, `wysiwyg`, `public`, `language`, `ip`, `email`, `avatar`, `note`) VALUES
(1,	1,	1,	'',	NULL,	'',	0,	0,	0,	0,	1,	0,	1,	'',	'',	'',	NULL,	'');

CREATE TABLE `sunlight_user_activation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(48) NOT NULL,
  `expire` bigint(20) NOT NULL,
  `data` mediumblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sunlight_user_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `descr` varchar(255) NOT NULL DEFAULT '',
  `level` int(11) NOT NULL DEFAULT 0,
  `icon` varchar(16) NOT NULL DEFAULT '',
  `color` varchar(16) NOT NULL DEFAULT '',
  `blocked` tinyint(1) NOT NULL DEFAULT 0,
  `reglist` tinyint(1) NOT NULL DEFAULT 0,
  `administration` tinyint(1) NOT NULL DEFAULT 0,
  `adminsettings` tinyint(1) NOT NULL DEFAULT 0,
  `adminplugins` tinyint(1) NOT NULL DEFAULT 0,
  `adminusers` tinyint(1) NOT NULL DEFAULT 0,
  `admingroups` tinyint(1) NOT NULL DEFAULT 0,
  `admincontent` tinyint(1) NOT NULL DEFAULT 0,
  `adminother` tinyint(1) NOT NULL DEFAULT 0,
  `adminpages` tinyint(1) NOT NULL DEFAULT 0,
  `adminsection` tinyint(1) NOT NULL DEFAULT 0,
  `admincategory` tinyint(1) NOT NULL DEFAULT 0,
  `adminbook` tinyint(1) NOT NULL DEFAULT 0,
  `adminseparator` tinyint(1) NOT NULL DEFAULT 0,
  `admingallery` tinyint(1) NOT NULL DEFAULT 0,
  `adminlink` tinyint(1) NOT NULL DEFAULT 0,
  `admingroup` tinyint(1) NOT NULL DEFAULT 0,
  `adminforum` tinyint(1) NOT NULL DEFAULT 0,
  `adminpluginpage` tinyint(1) NOT NULL DEFAULT 0,
  `adminart` tinyint(1) NOT NULL DEFAULT 0,
  `adminallart` tinyint(1) NOT NULL DEFAULT 0,
  `adminchangeartauthor` tinyint(1) NOT NULL DEFAULT 0,
  `adminconfirm` tinyint(1) NOT NULL DEFAULT 0,
  `adminautoconfirm` tinyint(1) NOT NULL DEFAULT 0,
  `adminpoll` tinyint(1) NOT NULL DEFAULT 0,
  `adminpollall` tinyint(1) NOT NULL DEFAULT 0,
  `adminsbox` tinyint(1) NOT NULL DEFAULT 0,
  `adminbox` tinyint(1) NOT NULL DEFAULT 0,
  `fileaccess` tinyint(1) NOT NULL DEFAULT 0,
  `fileglobalaccess` tinyint(1) NOT NULL DEFAULT 0,
  `fileadminaccess` tinyint(1) NOT NULL DEFAULT 0,
  `adminhcm` varchar(255) NOT NULL DEFAULT '',
  `adminhcmphp` tinyint(1) NOT NULL DEFAULT 0,
  `adminbackup` tinyint(1) NOT NULL DEFAULT 0,
  `adminmassemail` tinyint(1) NOT NULL DEFAULT 0,
  `adminposts` tinyint(1) NOT NULL DEFAULT 0,
  `changeusername` tinyint(1) NOT NULL DEFAULT 0,
  `postcomments` tinyint(1) NOT NULL DEFAULT 0,
  `unlimitedpostaccess` tinyint(1) NOT NULL DEFAULT 0,
  `locktopics` tinyint(1) NOT NULL DEFAULT 0,
  `stickytopics` tinyint(1) NOT NULL DEFAULT 0,
  `movetopics` tinyint(1) NOT NULL DEFAULT 0,
  `artrate` tinyint(1) NOT NULL DEFAULT 0,
  `pollvote` tinyint(1) NOT NULL DEFAULT 0,
  `selfremove` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `level` (`level`),
  KEY `blocked` (`blocked`),
  KEY `reglist` (`reglist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sunlight_user_group` (`id`, `title`, `descr`, `level`, `icon`, `color`, `blocked`, `reglist`, `administration`, `adminsettings`, `adminplugins`, `adminusers`, `admingroups`, `admincontent`, `adminother`, `adminpages`, `adminsection`, `admincategory`, `adminbook`, `adminseparator`, `admingallery`, `adminlink`, `admingroup`, `adminforum`, `adminpluginpage`, `adminart`, `adminallart`, `adminchangeartauthor`, `adminconfirm`, `adminautoconfirm`, `adminpoll`, `adminpollall`, `adminsbox`, `adminbox`, `fileaccess`, `fileglobalaccess`, `fileadminaccess`, `adminhcm`, `adminhcmphp`, `adminbackup`, `adminmassemail`, `adminposts`, `changeusername`, `postcomments`, `unlimitedpostaccess`, `locktopics`, `stickytopics`, `movetopics`, `artrate`, `pollvote`, `selfremove`) VALUES
(1,	'SUPER_ADMIN',	'',	10000,	'redstar.png',	'',	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	'*',	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1),
(2,	'GUESTS',	'',	0,	'',	'',	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	'',	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	1,	0),
(3,	'REGISTERED',	'',	1,	'',	'',	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	1,	0,	'',	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	1,	1),
(4,	'ADMINISTRATORS',	'',	1000,	'orangestar.png',	'',	0,	0,	1,	1,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	'*',	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0),
(5,	'MODERATORS',	'',	600,	'greenstar.png',	'',	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	1,	0,	'',	0,	0,	0,	1,	0,	1,	1,	1,	1,	1,	1,	1,	0),
(6,	'EDITOR',	'',	500,	'bluestar.png',	'',	0,	0,	1,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	0,	0,	0,	1,	0,	0,	'poll, gallery, linkart, linkroot',	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	1,	0);
