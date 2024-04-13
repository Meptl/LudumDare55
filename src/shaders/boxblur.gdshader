shader_type canvas_item;

uniform float strength: hint_range(0.0, 16.0) = 0.0;
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 output_color = vec4(0, 0, 0, 0);
	vec2 pixel = UV / TEXTURE_PIXEL_SIZE;

	int x_min = max(int(pixel.x - strength), 0);
	int x_max = min(int(pixel.x + strength), int(1.0 / TEXTURE_PIXEL_SIZE.x));
	int y_min = max(int(pixel.y - strength), 0);
	int y_max = min(int(pixel.y + strength), int(1.0 / TEXTURE_PIXEL_SIZE.y));

	int count = 0;
	for (int x = x_min; x <= x_max; x++) {
		for (int y = y_min; y <= y_max; y++) {
			vec4 orig_color = texture(TEXTURE, vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE);
			float intensity = (0.2126 * orig_color.x) + (0.7152 * orig_color.y) + (0.0722 * orig_color.z);
			output_color += (vec4(intensity, intensity, intensity, orig_color.w));
			count++;
		}
	}

	COLOR = output_color / float(count) * color;
}
