shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

const mat2 myt = mat2(vec2(0.12121212, 0.13131313), vec2(-0.13131313, 0.12121212));
const vec2 mys = vec2(1e4, 1e6);

vec2 rhash(vec2 uv) {
  uv *= myt;
  uv *= mys;
  return fract(fract(uv / mys) * uv);
}

vec3 hash(vec3 p) {
  return fract(sin(vec3(dot(p, vec3(1.0, 57.0, 113.0)),
                        dot(p, vec3(57.0, 113.0, 1.0)),
                        dot(p, vec3(113.0, 1.0, 57.0)))) *
               43758.5453);
}

float voronoi2d(const in vec2 point) {
  vec2 p = floor(point);
  vec2 f = fract(point);
  float res = 0.0;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      vec2 b = vec2(float(i), float(j));
      vec2 r = vec2(b) - f + rhash(p + b);
      res += 1. / pow(dot(r, r), 8.);
    }
  }
  return pow(1. / res, 0.0625);
}

vec4 fire(vec4 color, vec2 uv, float time) {
    // Scale the UV coordinates and apply time offset for animation
    vec2 fireuv = vec2(
        (uv * 10.0).x, 
        (uv * 10.0 + time * 3.0).y);

	vec2 modifiedDistUvs = vec2(uv.x - 0.5, uv.y - 0.7);
	modifiedDistUvs.y *= 0.5;
	modifiedDistUvs.x *= 1.5;
    float dist = distance(modifiedDistUvs, vec2(0.0, 0.0));
    color = vec4(voronoi2d(fireuv));

    float taper = smoothstep(0.0, 1.0, 1.0 - dist * 2.0);
    color *= taper;
	color *= vec4(1, 0, 0, 1);
	color += taper * vec4(1, .5, 0, 1);

    return color;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR = fire(COLOR, UV, TIME);
	// COLOR = vec4(UV, 0.5, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
