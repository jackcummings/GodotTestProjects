shader_type canvas_item;

const int MAX_TORCHES = 20;

uniform vec2  torch_positions[MAX_TORCHES];
uniform float torch_radii[MAX_TORCHES];
uniform vec4  torch_colors[MAX_TORCHES];
uniform int   torch_count = 0;

uniform float ambient : hint_range(0.0, 1.0) = 0.0;
uniform float falloff : hint_range(0.5, 8.0) = 2.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float light_intensity(vec2 frag_pos, vec2 light_pos, float radius) {
    float dist       = distance(frag_pos, light_pos);
    float normalized = clamp(dist / radius, 0.0, 1.0);
    return pow(1.0 - normalized, falloff);
}

void fragment() {
    vec2  frag_pos         = FRAGCOORD.xy;
    float total_brightness = ambient;
    vec3  total_tint       = vec3(0.0);

    for (int i = 0; i < MAX_TORCHES; i++) {		
        if (i >= torch_count) break;
        float t          = light_intensity(frag_pos, torch_positions[i], torch_radii[i]);
        total_brightness = max(total_brightness, mix(ambient, 1.0, t));
        total_tint      += torch_colors[i].rgb * t * 0.9;
    }

    float tint_len = length(total_tint);
    vec3  tint     = tint_len > 0.0 ? total_tint / max(tint_len, 1.0) : vec3(1.0);
	
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR.rgb *= tint * total_brightness;
	//COLOR.a = clamp(total_brightness, 0.5, 1);
}