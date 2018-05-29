<?php

use Sunlight\Core;
use Sunlight\Database\Database as DB;
use Sunlight\Extend;
use Sunlight\Util\Password;
use Sunlight\Util\StringGenerator;
use Sunlight\Util\Url;

defined('_root') or exit;

if (!_registration) {
    $_index['found'] = false;
    return;
}

if (_logged_in) {
    $_index['is_guest_only'] = true;
    return;
}

// priprava
$message = '';
$user_data = array();
$user_data_valid = false;
$show_form = true;
$rules = Core::loadSetting('rules');
$confirmed = (_registration_confirm ? false : true);

// akce
if (isset($_GET['confirm'])) {
    /* ----- potvrzeni ----- */

    $show_form = false;

    if (!_registration_confirm) {
        $_index['found'] = false;
        return;
    }

    $code = \Sunlight\Util\Request::get('confirm');
    if (preg_match('{[a-z0-9]{48}$}AD', $code)) {
        // kontrola omezeni
        if (\Sunlight\IpLog::check(_iplog_failed_account_activation)) {
            // smazani expirovanych
            DB::delete(_user_activation_table, 'expire<' . time(), null);

            // nalezeni zaznamu
            $activation = DB::queryRow('SELECT * FROM ' . _user_activation_table . ' WHERE code=' . DB::val($code));
            if ($activation !== false) {
                // zaznam nalezen
                $user_data = unserialize($activation['data']);

                // kontrola dostupnosti uziv. jmena a emailu
                if (
                    DB::count(_users_table, 'username=' . DB::val($user_data['username']) . ' OR publicname=' . DB::val($user_data['username'])) == 0
                    && DB::count(_users_table, 'email=' . DB::val($user_data['email'])) == 0
                ) {
                    // vse ok
                    $user_data_valid = true;
                    $confirmed = true;

                    DB::delete(_user_activation_table, 'id=' . DB::val($activation['id']));
                } else {
                    $message .= \Sunlight\Message::render(_msg_warn, _lang('mod.reg.confirm.emailornametaken'));
                }
            } else {
                \Sunlight\IpLog::update(_iplog_failed_account_activation);
                $message = \Sunlight\Message::render(_msg_warn, _lang('mod.reg.confirm.notfound'));
            }
        } else {
            $message = \Sunlight\Message::render(_msg_warn, _lang('mod.reg.confirm.limit', array('*limit*' => _accactexpire)));
        }
    } else {
        $message = \Sunlight\Message::render(_msg_err, _lang('mod.reg.confirm.badcode'));
    }

} else {
    /* ----- zpracovani formulare ----- */

    // zpracovani odeslani
    if (!empty($_POST)) {

        $errors = array();

        // kontrola iplogu
        if (!\Sunlight\IpLog::check(_iplog_anti_spam)) {
            $errors[] = _lang('misc.requestlimit', array("*postsendexpire*" => _postsendexpire));
        }

        // nacteni a kontrola promennych
        $user_data['username'] = \Sunlight\Util\Request::post('username');
        if (mb_strlen($user_data['username']) > 24) {
            $user_data['username'] = mb_substr($user_data['username'], 0, 24);
        }
        $user_data['username'] = \Sunlight\Util\StringManipulator::slugify($user_data['username'], false);
        if ($user_data['username'] == "") {
            $errors[] = _lang('user.msg.badusername');
        } elseif (DB::count(_users_table, 'username=' . DB::val($user_data['username']) . ' OR publicname=' . DB::val($user_data['username'])) !== 0) {
            $errors[] = _lang('user.msg.userexists');
        }

        $password = \Sunlight\Util\Request::post('password');
        $password2 = \Sunlight\Util\Request::post('password2');
        if ($password != $password2) {
            $errors[] = _lang('mod.reg.nosame');
        }
        if ($password != "") {
            $user_data['password'] = Password::create($password)->build();
        } else {
            $errors[] = _lang('mod.reg.passwordneeded');
        }

        $user_data['email'] = trim(\Sunlight\Util\Request::post('email'));
        if (!\Sunlight\Email::validate($user_data['email'])) {
            $errors[] = _lang('user.msg.bademail');
        }
        if (DB::count(_users_table, 'email=' . DB::val($user_data['email'])) !== 0) {
            $errors[] = _lang('user.msg.emailexists');
        }

        if (!\Sunlight\Captcha::check()) {
            $errors[] = _lang('captcha.failure');
        }

        $user_data['massemail'] = \Sunlight\Util\Form::loadCheckbox('massemail');

        if (_registration_grouplist && isset($_POST['group_id'])) {
            $user_data['group_id'] = (int) \Sunlight\Util\Request::post('group_id');
            $groupdata = DB::query("SELECT id FROM " . _groups_table . " WHERE id=" . $user_data['group_id'] . " AND blocked=0 AND reglist=1");
            if (DB::size($groupdata) == 0) {
                $errors[] = _lang('global.badinput');
            }
        } else {
            $user_data['group_id'] = _defaultgroup;
        }

        if ($rules !== '' && !\Sunlight\Util\Form::loadCheckbox('agreement')) {
            $errors[] = _lang('mod.reg.rules.disagreed');
        }

        $user_data['ip'] = _user_ip;

        Extend::call('mod.reg.submit', array(
            'user_data' => &$user_data,
            'errors' => &$errors,
        ));

        // validace
        if (empty($errors)) {
            \Sunlight\IpLog::update(_iplog_anti_spam);
            $user_data_valid = true;
        } else {
            $message = \Sunlight\Message::render(_msg_warn, \Sunlight\Message::renderList($errors, 'errors'));
        }

    }
}

// atributy
$_index['title'] = _lang('mod.reg');

// vystup
$output .= $message;

if (!$user_data_valid && $show_form) {
    /* ----- formular ----- */

    // priprava vyberu skupiny
    $groupselect = array();
    if (_registration_grouplist) {
        $groupselect_items = DB::query("SELECT id,title FROM " . _groups_table . " WHERE blocked=0 AND reglist=1 ORDER BY title");
        if (DB::size($groupselect_items) != 0) {
            $groupselect_content = "";
            while ($groupselect_item = DB::row($groupselect_items)) {
                $groupselect_content .= "<option value='" . $groupselect_item['id'] . "'" . (($groupselect_item['id'] == _defaultgroup) ? " selected" : '') . ">" . $groupselect_item['title'] . "</option>\n";
            }
            $groupselect = array('label' => _lang('global.group'), 'content' => "<select name='group_id'>" . $groupselect_content . "</select>");
        }
    }

    // priprava podminek
    if ($rules !== '') {
        $rules = array('content' => "<h2>" . _lang('mod.reg.rules') . "</h2>" . $rules . "<p><label><input type='checkbox' name='agreement' value='1'" . \Sunlight\Util\Form::activateCheckbox(isset($_POST['agreement'])) . "> " . _lang('mod.reg.rules.agreement') . "</label></p>", 'top' => true);
    } else {
        $rules = array();
    }

    // captcha
    $captcha = \Sunlight\Captcha::init();

    // formular
    $output .= "<p class='bborder'>" . _lang('mod.reg.p') . (_registration_confirm ? ' ' . _lang('mod.reg.confirm.extratext') : '') . "</p>\n";

    $output .= \Sunlight\Util\Form::render(
        array(
            'name' => 'regform',
            'action' => \Sunlight\Router::module('reg'),
            'submit_text' => _lang('mod.reg.submit' . (_registration_confirm ? '2' : '')),
            'submit_span' => $rules !== '',
            'submit_name' => 'regform',
            'autocomplete' => 'off',
        ),
        array(
            array('label' => _lang('login.username'), 'content' => "<input type='text' class='inputsmall' maxlength='24'" . \Sunlight\Util\Form::restorePostValueAndName('username') . ">"),
            array('label' => _lang('login.password'), 'content' => "<input type='password' name='password' class='inputsmall'>"),
            array('label' => _lang('login.password') . " (" . _lang('global.check') . ")", 'content' => "<input type='password' name='password2' class='inputsmall'>"),
            array('label' => _lang('global.email'), 'content' => "<input type='email' class='inputsmall' " . \Sunlight\Util\Form::restorePostValueAndName('email', '@') . ">"),
            array('label' => _lang('mod.settings.massemail'), 'content' => "<label><input type='checkbox' value='1'" . \Sunlight\Util\Form::restoreCheckedAndName('regform', 'massemail') . "> " . _lang('mod.settings.massemail.label') . '</label>'),
            $groupselect,
            $captcha,
            $rules,
        )
    );
} elseif ($user_data_valid) {
    /* ----- zpracovani dat ----- */

    if ($confirmed) {

        // potvrzeno
        $user_id = DB::insert(_users_table, $user_data + array('registertime' => time()), true);

        // udalost
        Extend::call('user.new', array('id' => $user_id, 'username' => $user_data['username'], 'email' => $user_data['email']));

        // hlaska
        $_SESSION['login_form_username'] = $user_data['username'];

        $output .= \Sunlight\Message::render(_msg_ok, str_replace(
            '*login_link*',
            \Sunlight\Router::module('login'),
            _lang('mod.reg.done')
        ));

    } else {

        // nepotvrzeno
        $code = StringGenerator::generateHash(35);
        $insert_id = DB::insert(_user_activation_table, array(
            'code' => $code,
            'expire' => time() + 3600,
            'data' => serialize($user_data),
        ), true);

        // potvrzovaci zprava
        $domain = Url::base()->getFullHost();
        $mail = \Sunlight\Email::send(
            $user_data['email'],
            _lang('mod.reg.confirm.subject', array('*domain*' => $domain)),
            str_replace(
                array(
                    '*username*',
                    '*domain*',
                    '*confirm_link*',
                    '*ip*',
                    '*date*'
                ),
                array(
                    $user_data['username'],
                    $domain,
                    \Sunlight\Router::module('reg', 'confirm=' . $code, false, true),
                    _user_ip,
                    \Sunlight\Generic::renderTime(time()),
                ),
                _lang('mod.reg.confirm.text')
            )
        );

        // hlaska
        if ($mail) {
            $output .= \Sunlight\Message::render(_msg_ok, _lang('mod.reg.confirm.sent', array('*email*' => $user_data['email'])));
        } else {
            $output .= \Sunlight\Message::render(_msg_err, _lang('global.emailerror'));
            DB::delete(_user_activation_table, 'id=' . DB::val($insert_id));
        }

    }
}
