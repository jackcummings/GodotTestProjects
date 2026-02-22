shader_type canvas_item;

// 'player_screen_pos' Global uniform variable — set once via RenderingServer/Project Settings, 
// avaiable to be declared so it is visible in any shaders.  The 
global uniform vec2 player_screen_pos;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4  light_color : source_color = vec4(1.0, 0.85, 0.4, 1.0);
uniform float light_radius : hint_range(10.0, 500.0) = 150.0;
uniform float ambient      : hint_range(0.0,  1.0)   = 0.05;
uniform float falloff      : hint_range(0.5,  8.0)   = 2.0;

void fragment() {
    float dist       = distance(FRAGCOORD.xy, player_screen_pos);
    float normalized = clamp(dist / light_radius, 0.0, 1.0);
    float intensity  = pow(1.0 - normalized, falloff);
    float brightness = mix(ambient, 1.0, intensity);
    vec3  tint       = mix(vec3(1.0), light_color.rgb, intensity * 0.6);
	
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR.rgb *= tint * brightness;
	//COLOR.a = clamp(distance(FRAGCOORD.xy, player_screen_pos)/light_radius, 0.5, 1.0);
	COLOR.a = clamp(brightness, 0.0, 0.8);
}