shader_type spatial;

uniform float distortion_size = 0.4;
uniform sampler2D glass : source_color;
uniform vec4 color: source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 d = texture(glass, UV).xy - vec2(0.5);
    ALBEDO.rgb = texture(SCREEN_TEXTURE, SCREEN_UV + d * distortion_size).rgb * color.rgb;
    ALPHA = color.a;
}