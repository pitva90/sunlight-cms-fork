<?php

namespace Sunlight\Plugin;

use Sunlight\Database\Database as DB;
use Sunlight\Localization\LocalizationDictionary;
use Sunlight\Localization\LocalizationDirectory;

class TemplatePlugin extends Plugin
{
    const DEFAULT_LAYOUT = 'default';

    protected static $typeDefinition = array(
        'type' => 'template',
        'dir' => 'plugins/templates',
        'class' => __CLASS__,
        'default_base_namespace' => 'SunlightTemplate',
        'options' => array(
            'css' => array('type' => 'array', 'default' => array('template_style' => 'style.css'), 'normalizer' => array('Sunlight\Plugin\PluginOptionNormalizer', 'normalizeWebPathArray')),
            'js' => array('type' => 'array', 'default' => array(), 'normalizer' => array('Sunlight\Plugin\PluginOptionNormalizer', 'normalizeWebPathArray')),
            'responsive' => array('type' => 'boolean', 'default' => false),
            'dark' => array('type' => 'boolean', 'default' => false),
            'smiley.count' => array('type' => 'integer', 'default' => 10),
            'smiley.format' => array('type' => 'string', 'default' => 'gif'),
            'bbcode.buttons' => array('type' => 'boolean', 'default' => true),
            'box.parent' => array('type' => 'string', 'default' => ''),
            'box.item' => array('type' => 'string', 'default' => 'div'),
            'box.title' => array('type' => 'string', 'default' => 'h3'),
            'box.title.inside' => array('type' => 'boolean', 'default' => false),
            'layouts' => array('type' => 'array', 'required' => true, 'normalizer' => array('Sunlight\Plugin\PluginOptionNormalizer', 'normalizeTemplateLayouts')),
            'lang_dir' => array('type' => 'string', 'default' => 'labels', 'normalizer' => array('Sunlight\Plugin\PluginOptionNormalizer', 'normalizePath')),
        ),
    );

    /** @var LocalizationDictionary */
    protected $lang;

    function __construct(array $data, PluginManager $manager)
    {
        parent::__construct($data, $manager);

        $this->lang = new LocalizationDirectory($this->options['lang_dir']);
    }

    function canBeDisabled()
    {
        return !$this->isDefault() && parent::canBeDisabled();
    }

    function canBeRemoved()
    {
        return !$this->isDefault() && parent::canBeRemoved();
    }

    /**
     * See if this is the default template
     *
     * @return bool
     */
    function isDefault()
    {
        return $this->id === _default_template;
    }

    /**
     * Notify the template plugin that it is going to be used to render a front end page
     *
     * @param string $layout
     */
    function begin($layout)
    {
    }

    /**
     * Get the localization dictionary
     *
     * @return LocalizationDictionary
     */
    function getLang()
    {
        return $this->lang;
    }
    
    /**
     * Get template file path for the given layout
     *
     * @param string $layout
     * @return string
     */
    function getTemplate($layout = self::DEFAULT_LAYOUT)
    {
        if (!isset($this->options['layouts'][$layout])) {
            $layout = static::DEFAULT_LAYOUT;
        }

        return $this->options['layouts'][$layout]['template'];
    }

    /**
     * See if the given layout exists
     *
     * @param string $layout layout name
     * @return bool
     */
    function hasLayout($layout)
    {
        return isset($this->options['layouts'][$layout]);
    }

    /**
     * Get list of template layout identifiers
     *
     * @return string[]
     */
    function getLayouts()
    {
        return array_keys($this->options['layouts']);
    }

    /**
     * Get label for the given layout
     *
     * @param string $layout layout name
     * @return string
     */
    function getLayoutLabel($layout)
    {
        return $this->lang->get("{$layout}.label");
    }

    /**
     * See if the given slot exists
     *
     * @param string $layout
     * @param string $slot
     * @return bool
     */
    function hasSlot($layout, $slot)
    {
        return in_array($slot, $this->getSlots($layout), true);
    }

    /**
     * Get list of slot identifiers for the given layout
     *
     * string $layout layout name
     * @return string[]
     */
    function getSlots($layout)
    {
        if (isset($this->options['layouts'][$layout])) {
            return $this->options['layouts'][$layout]['slots'];

        }

        return array();
    }

    /**
     * Get label for the given layout and slot
     *
     * @param string $layout
     * @param string $slot
     * @return string
     */
    function getSlotLabel($layout, $slot)
    {
        return $this->lang->get("{$layout}.slot.{$slot}");
    }

    /**
     * Get boxes for the given layout
     *
     * @param string $layout
     * @return array
     */
    function getBoxes($layout = self::DEFAULT_LAYOUT)
    {
        if (!isset($this->options['layouts'][$layout])) {
            $layout = static::DEFAULT_LAYOUT;
        }

        $boxes = array();
        $query = DB::query('SELECT id,title,content,slot,page_ids,page_children,class FROM ' . _box_table . ' WHERE template=' . DB::val($this->id) . ' AND layout=' . DB::val($layout) . ' AND visible=1' . (!_logged_in ? ' AND public=1' : '') . ' AND level <= ' . _priv_level . ' ORDER BY ord');

        while ($box = DB::row($query)) {
            $boxes[$box['slot']][$box['id']] = $box;
        }

        DB::free($query);

        return $boxes;
    }

    /**
     * @return string
     */
    protected function getLocalizationPrefix()
    {
        return "{$this->type}_{$this->id}";
    }
}
