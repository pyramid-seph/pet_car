shader_type canvas_item;

uniform sampler2D spots_texture : repeat_enable;
uniform float spots_texture_offset_x : hint_range(0.0, 1.0);
uniform float spots_texture_offset_y : hint_range(0.0, 1.0);
uniform vec3 body_color : source_color;
uniform vec3 spots_color : source_color;

void fragment() {
	vec2 spots_texture_offset = vec2(spots_texture_offset_x, spots_texture_offset_y);
	vec3 spots_texture_pixel = texture(spots_texture, UV + spots_texture_offset).rgb;
	vec3 default_texture_pixel = texture(TEXTURE, UV).rgb;
	
	vec3 colored_body = (1.0 - spots_texture_pixel) * body_color;
	vec3 colored_spots = default_texture_pixel * spots_texture_pixel * spots_color;
	COLOR.rgb = default_texture_pixel * (colored_body + colored_spots);
}
