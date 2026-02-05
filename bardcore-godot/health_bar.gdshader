shader_type spatial;
render_mode unshaded;

uniform float health_ratio : hint_range(0.0, 1.0) = 1.0;
uniform vec3 color_alive : source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 color_empty : source_color = vec3(0.0, 0.0, 0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // UV.x läuft von 0 (links) bis 1 (rechts)
    float mask = step(UV.x, health_ratio);
    vec3 final_color = mix(color_empty, color_alive, mask);
    ALBEDO = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
