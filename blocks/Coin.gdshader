shader_type canvas_item;
uniform float transparent;
void fragment(){
    vec4 c = texture(TEXTURE,UV);
    COLOR = c * transparent;
}