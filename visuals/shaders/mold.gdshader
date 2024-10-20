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
	float average = (texture(noise, UV / 2.).x + texture(noise2, UV / 2.).y) / 2.;
	ALPHA = average / 3.;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
