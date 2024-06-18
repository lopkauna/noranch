shader_type canvas_item;

uniform vec2 srensize = vec2(0,0);
uniform vec2 cmpos = vec2(0,0);
uniform float multplr = 1;
uniform float gridsize = 16.0;
uniform float transperancy = 0.4;
uniform sampler2D screen_texture : hint_screen_texture,filter_linear_mipmap;

void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	if (int(FRAGCOORD.x+cmpos.x*multplr-srensize.x*0.5)%int(gridsize*multplr) == 0 
	|| int(FRAGCOORD.y+cmpos.y*multplr-srensize.y*0.5)%int(gridsize*multplr) == 0) {
		if (multplr <= 1.0){
			vec3 ncol = texture(screen_texture,SCREEN_UV,0.0).rgb;
			ncol = vec3(1.0)-ncol;
			COLOR.rgb = ncol.rgb * 0.5;
			COLOR.a = transperancy * multplr;
			//COLOR = vec4(1.0,1.0,1.0,transperancy*multplr);
		}
		else{
			vec3 ncol = texture(screen_texture,SCREEN_UV,0.0).rgb;
			ncol = vec3(1.0)-ncol;
			COLOR.rgb = ncol.rgb * 0.5;
			COLOR.a = transperancy;
			//COLOR = vec4(1.0,1.0,1.0,transperancy);
		}
	}
	else{
		COLOR = vec4(1.0,1.0,1.0,0.0);
	}
		
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
