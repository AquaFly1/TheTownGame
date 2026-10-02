shader_type canvas_item;

uniform sampler2D color_texture: filter_nearest;
uniform sampler2D depth_texture: filter_nearest;
uniform sampler2D light_texture: filter_nearest;
uniform sampler2D fg_texture: hint_screen_texture, filter_nearest;
uniform vec2 shadow;
uniform float fg_light_impact: hint_range(0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (texture(fg_texture,UV).a == 0.){
		COLOR = texture(color_texture,UV);
		float depth = 1.-texture(depth_texture,UV).r;
		if (texture(fg_texture,UV+(-shadow*SCREEN_PIXEL_SIZE*depth)).a == 0.){
			vec4 light = texture(light_texture,UV);
			COLOR = COLOR/(1.-light);
		}
		}
	else
	{
		vec4 col = texture(fg_texture,UV);
		vec4 light = texture(light_texture,UV)*col.a;
		COLOR = mix(col,col/(1.-light),fg_light_impact);
	
	}
	//float depth = texture(depth_texture,UV).r;
	//COLOR = texture(fg_texture,UV+(shadow*depth*SCREEN_PIXEL_SIZE));
	//COLOR.a = 1.;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
