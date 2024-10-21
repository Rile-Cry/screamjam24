shader_type spatial;

uniform sampler2D noise;
uniform sampler2D noise2;
uniform vec3 mold_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = mold_color;
	ALPHA = texture(noise, UV).x;
	NORMAL_MAP = texture(noise2, UV).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
