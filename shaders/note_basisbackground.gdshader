/*
	動的電子背景シェーダー by あるる（きのもと 結衣） @arlez80
	Procedural Electric Background Shader by Yui Kinomoto @arlez80

	MIT License
*/
shader_type canvas_item;
uniform vec2 cmpos = vec2(0,0);
uniform float multplr = 1;
uniform vec4 background_color : source_color = vec4( 0.0, 0.0, 0.0, 1.0 );
uniform vec4 line_color : source_color = vec4( 0.0, 1.0, 1.0, 1.0 );
uniform float line_freq = 9.56;
uniform float height = 0.6;
uniform float speed = 0.8;
uniform vec2 scale = vec2( 2.0, 16.0 );

void fragment( )
{
	vec2 uv = (UV * scale+vec2(cmpos.x*(scale.x*0.0005),cmpos.y*(scale.y*0.0005)))/(multplr*0.25+0.9);// /(1.05-multplr*0.25) 
	float shift = cos( floor( uv.y ) );
	uv.x += shift;
	//uv.y += ;
	float freq = clamp( cos( uv.x * line_freq ) * 3.0, 0.0, 1.0 ) * height;
	float line = 1.0 - clamp( abs( freq - mod( uv.y, 1.0 ) ) * 11.0, 0.0, 1.0 );

	COLOR = mix( background_color, line_color, line * mod( uv.x - TIME*6.0 * speed * abs( shift ), 1.0 ) /*  * mod( TIME + shift, 1.0 ) */ );
}