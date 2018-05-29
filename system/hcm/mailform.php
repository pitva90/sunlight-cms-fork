<?php

use Sunlight\Core;

defined('_root') or exit;

return function ($adresa = "", $predmet = null)
{
    // priprava
    $result = "";
    $_SESSION['hcm_' . Core::$hcmUid . '_mail_receiver'] = implode(",", \Sunlight\Util\Arr::removeValue(explode(";", trim($adresa)), ""));
    if (isset($predmet)) {
        $rsubject = " value='" . _e($predmet) . "'";
    } else {
        $rsubject = "";
    }
    $rcaptcha = \Sunlight\Captcha::init();

    // zprava
    $msg = '';
    if (isset($_GET['hcm_mr_' . Core::$hcmUid])) {
        switch (\Sunlight\Util\Request::get('hcm_mr_' . Core::$hcmUid)) {
            case 1:
                $msg = \Sunlight\Message::render(_msg_ok, _lang('hcm.mailform.msg.done'));
                break;
            case 2:
                $msg = \Sunlight\Message::render(_msg_warn, _lang('hcm.mailform.msg.failure'));
                break;
            case 3:
                $msg = \Sunlight\Message::render(_msg_err, _lang('global.emailerror'));
                break;
            case 4:
                $msg = \Sunlight\Message::render(_msg_err, _lang('xsrf.msg'));
                break;
        }
    }

    // predvyplneni odesilatele
    if (_logged_in) {
        $sender = _user_email;
    } else {
        $sender = "&#64;";
    }

    $result .= $msg
        . \Sunlight\Util\Form::render(
            array(
                'id' =>  'hcm_mform_' . Core::$hcmUid,
                'name' => 'mform' . Core::$hcmUid,
                'action' => \Sunlight\Router::link('system/script/hcm/mform.php?_return=' . rawurlencode($GLOBALS['_index']['url'])),
                'submit_text' => _lang('hcm.mailform.send'),
            ),
            array(
                array('label' => _lang('hcm.mailform.sender'), 'content' => "<input type='text' class='inputsmall' name='sender' value='" . $sender . "'><input type='hidden' name='fid' value='" . Core::$hcmUid . "'>"),
                array('label' => _lang('posts.subject'), 'content' => "<input type='text' class='inputsmall' name='subject'" . $rsubject . ">"),
                $rcaptcha,
                array('label' => _lang('hcm.mailform.text'), 'content' => "<textarea class='areasmall' name='text' rows='9' cols='33'></textarea>", 'top' => true),
            )
        );

    return $result;
};
