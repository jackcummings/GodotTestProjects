shader_type canvas_item;
const int MAX_TORCHES = 50;

uniform vec2  torch_positions[MAX_TORCHES];
uniform float torch_radii[MAX_TORCHES];
uniform int   torch_count = 0;

uniform vec4  light_color : source_color = vec4(0.944, 0.958, 0.997, 1.0);
uniform float ambient     : hint_range(0.0, 1.0) = 0.0;
uniform float falloff     : hint_range(0.5, 8.0) = 2.0;
uniform float color_mix   : hint_range(0.0, 1.0) = 0.25; // 0 = white center, 1 = full color

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float light_intensity(vec2 frag_pos, vec2 light_pos, float radius) {
    float dist       = distance(frag_pos, light_pos);
    float normalized = clamp(dist / radius, 0.0, 1.0);
    return pow(max(0.0, 1.0 - normalized), falloff);
}

void fragment() {
    vec2  frag_pos         = FRAGCOORD.xy;
    float total_brightness = ambient;
    vec3  total_tint       = vec3(0.0);
    float total_weight     = 0.0;

    for (int i = 0; i < MAX_TORCHES; i++) {
        if (i >= torch_count) break;

        float t = light_intensity(frag_pos, torch_positions[i], torch_radii[i]);
        float brightness = mix(ambient, 1.0, t);

        total_brightness = max(total_brightness, brightness);

        // Accumulate weighted color — stronger weight near center
        total_tint   += light_color.rgb * t;
        total_weight += t;
    }

    vec3 tint;
    if (total_weight > 0.0) {
        vec3 avg_color = total_tint / total_weight;
        // Blend: bright center fades toward white, edges show full color
        float center_blend = clamp(total_weight, 0.0, 1.0);
        tint = mix(avg_color, vec3(1.0), (1.0 - color_mix) * center_blend);
    } else {
        tint = vec3(1.0);
    }

    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR.rgb *= tint * total_brightness;
}