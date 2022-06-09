shader_type canvas_item;
uniform float transparent;
void fragment(){
    vec4 c = texture(TEXTURE,UV);
	if (c.a < 0.1)
		discard;
    COLOR = vec4(c.rgb, transparent);
}