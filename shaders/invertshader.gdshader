shader_type canvas_item;



uniform sampler2D scrtxtr : hint_screen_texture,filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 ncol = texture(scrtxtr,SCREEN_UV,0.0).rgb;
	ncol = vec3(1.0)-ncol;
	COLOR.rgb = ncol.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
