shader_type spatial;
uniform float percent =1.0;
uniform sampler2D inputTex;

float atan2(float y, float x) {
    if (x > 0.0) {
        return atan(y / x);
    } else if (x < 0.0) {
        if (y >= 0.0) {
            return atan(y / x) + PI;
        } else {
            return atan(y / x) - PI;
        }

    }
}
void vertex() {
	COLOR.rgb = texture(inputTex, UV).rgb;

}
void fragment() {
	ALPHA = texture(inputTex, UV).a;
    vec2 center = vec2(0.5, 0.5);
    vec2 offset = UV - center;
    float angle = atan2(offset.y, offset.x);
    // Convert angle to degrees
    angle = (angle + PI) / (2.0 * PI );
	if(angle > percent)
	{
		discard;
	}
	}
