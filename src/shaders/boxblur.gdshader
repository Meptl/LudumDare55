shader_type canvas_item;

uniform int strength: hint_range(0, 16) = 0;

void fragment() {
	vec4 color = vec4(0, 0, 0, 0);
	float strengthFloat = float(strength);

	vec2 pixel = UV / TEXTURE_PIXEL_SIZE;

	int x_min = max(int(pixel.x - strengthFloat), 0);
	int x_max = min(int(pixel.x + strengthFloat), int(1.0 / TEXTURE_PIXEL_SIZE.x));
	int y_min = max(int(pixel.y - strengthFloat), 0);
	int y_max = min(int(pixel.y + strengthFloat), int(1.0 / TEXTURE_PIXEL_SIZE.y));

	int count = 0;
	for (int x = x_min; x <= x_max; x++) {
		for (int y = y_min; y <= y_max; y++) {
			color += texture(TEXTURE, vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE);
			count++;
		}
	}

	COLOR = color / float(count);
}
