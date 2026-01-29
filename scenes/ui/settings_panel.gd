extends PanelContainer


@onready var _lang_option_button: OptionButton = %LangOptionButton
@onready var _body_color_picker_button: ColorPickerButton = %BodyColorPickerButton
@onready var _pattern_color_picker_button: ColorPickerButton = %PatternColorPickerButton
@onready var _pattern_x_slider: HSlider = %PatternXSlider
@onready var _pattern_y_slider: HSlider = %PatternYSlider
@onready var _version_label: Label = %VersionLabel


func _ready() -> void:
	_version_label.text = Utils.get_game_version()
	_setup_lang_option_button_options()
	_setup_values()


func _setup_lang_option_button_options() -> void:
	for idx: int in Utils.SUPPORTED_LANGUAGES.size():
		var option: Dictionary = Utils.SUPPORTED_LANGUAGES[idx]
		_lang_option_button.add_item(option.name, idx)
		_lang_option_button.set_item_metadata(idx, option.code)
		_lang_option_button.set_item_auto_translate_mode(idx,
				Node.AUTO_TRANSLATE_MODE_DISABLED)


func _setup_values() -> void:
	var selected_lang_idx: int = Utils.SUPPORTED_LANGUAGES.find_custom(
			func(lang: Dictionary): return lang.code == Settings.get_language())
	_lang_option_button.selected = maxi(0, selected_lang_idx)
	_body_color_picker_button.color = Settings.get_body_color()
	_pattern_color_picker_button.color = Settings.get_pattern_color()
	_pattern_x_slider.value = Settings.get_pattern_offset().x
	_pattern_y_slider.value = Settings.get_pattern_offset().y


func _customize_color_picker(picker_button: ColorPickerButton) -> void:
	var picker: ColorPicker = picker_button.get_picker()
	if picker:
		picker.picker_shape = ColorPicker.SHAPE_VHS_CIRCLE
		picker.sampler_visible = false
		picker.color_modes_visible = false
		picker.sliders_visible = false
		picker.presets_visible = false


func _on_lang_option_button_item_selected(index: int) -> void:
	Settings.set_language(_lang_option_button.get_item_metadata(index))


func _on_body_color_picker_button_picker_created() -> void:
	_customize_color_picker(_body_color_picker_button)


func _on_pattern_color_picker_button_picker_created() -> void:
	_customize_color_picker(_pattern_color_picker_button)


func _on_body_color_picker_button_color_changed(color: Color) -> void:
	Settings.set_body_color(color)


func _on_pattern_color_picker_button_color_changed(color: Color) -> void:
	Settings.set_pattern_color(color)


func _on_pattern_x_slider_value_changed(new_offset_x: float) -> void:
	Settings.set_pattern_offset(new_offset_x, Settings.get_pattern_offset().y)


func _on_pattern_y_slider_value_changed(new_offset_y: float) -> void:
	Settings.set_pattern_offset(Settings.get_pattern_offset().x, new_offset_y)


func _on_visibility_changed() -> void:
	if is_node_ready() and not visible:
		Settings.save()
