// Boing! by ThaeHan

class FuckingTriangleEffect extends Effect
{
	public var shader:FuckingTriangle = new FuckingTriangle();

	public function new(rotx:Float, roty:Float)
	{
		shader.rotX.value = [rotx];
		shader.rotY.value = [roty];
	}
}

class FuckingTriangle extends FlxShader
{
	@:glFragmentSource('
	
	
			#pragma header
			
			const vec3 vertices[18] = vec3[18] (
			vec3(-0.5, 0.0, -0.5),
			vec3( 0.5, 0.0, -0.5),
			vec3(-0.5, 0.0,  0.5),
			
			vec3(-0.5, 0.0,  0.5),
			vec3( 0.5, 0.0, -0.5),
			vec3( 0.5, 0.0,  0.5),
			
			vec3(-0.5, 0.0, -0.5),
			vec3( 0.5, 0.0, -0.5),
			vec3( 0.0, 1.0,  0.0),
			
			vec3(-0.5, 0.0,  0.5),
			vec3( 0.5, 0.0,  0.5),
			vec3( 0.0, 1.0,  0.0),
			
			vec3(-0.5, 0.0, -0.5),
			vec3(-0.5, 0.0,  0.5),
			vec3( 0.0, 1.0,  0.0),
			
			vec3( 0.5, 0.0, -0.5),
			vec3( 0.5, 0.0,  0.5),
			vec3( 0.0, 1.0,  0.0)
		);

		const vec2 texCoords[18] = vec2[18] (
			vec2(0., 1.),
			vec2(1., 1.),
			vec2(0., 0.),
			
			vec2(0., 0.),
			vec2(1., 1.),
			vec2(1., 0.),
			
			vec2(0., 1.),
			vec2(1., 1.),
			vec2(.5, 0.),
			
			vec2(0., 1.),
			vec2(1., 1.),
			vec2(.5, 0.),
			
			vec2(0., 1.),
			vec2(1., 1.),
			vec2(.5, 0.),
			
			vec2(0., 1.),
			vec2(1., 1.),
			vec2(.5, 0.)
		);

		vec4 vertexShader(in vec3 vertex, in mat4 transform) {
			return transform * vec4(vertex, 1.);
		}

		vec4 fragmentShader(in vec2 uv) {
			return flixel_texture2D(bitmap, uv);
		}


		const float fov  = 70.0;
		const float near = 0.1;
		const float far  = 10.;

		const vec3 cameraPos = vec3(0., 0.3, 2.);

			uniform float rotX = -25.;
			uniform float rotY = 45.;
		vec4 pixel(in vec2 ndc, in float aspect, inout float depth, in int vertexIndex) {

			
			

			mat4 proj  = perspective(fov, aspect, near, far);
			mat4 view  = translate(-cameraPos);
			mat4 model = rotateX(rotX) * rotateY(rotY);
			
			mat4 mvp  = proj * view * model;

			vec4 v0 = vertexShader(vertices[vertexIndex  ], mvp);
			vec4 v1 = vertexShader(vertices[vertexIndex+1], mvp);
			vec4 v2 = vertexShader(vertices[vertexIndex+2], mvp);
			
			vec2 t0 = texCoords[vertexIndex  ] / v0.w; float oow0 = 1. / v0.w;
			vec2 t1 = texCoords[vertexIndex+1] / v1.w; float oow1 = 1. / v1.w;
			vec2 t2 = texCoords[vertexIndex+2] / v2.w; float oow2 = 1. / v2.w;
			
			v0 /= v0.w;
			v1 /= v1.w;
			v2 /= v2.w;
			
			vec3 tri = bary(v0.xy, v1.xy, v2.xy, ndc);
			
			if(tri.x < 0. || tri.x > 1. || tri.y < 0. || tri.y > 1. || tri.z < 0. || tri.z > 1.) {
				return vec4(0.);
			}
			
			float triDepth = baryLerp(v0.z, v1.z, v2.z, tri);
			if(triDepth > depth || triDepth < -1. || triDepth > 1.) {
				return vec4(0.);
			}
			
			depth = triDepth;
			
			float oneOverW = baryLerp(oow0, oow1, oow2, tri);
			vec2 uv        = uvLerp(t0, t1, t2, tri) / oneOverW;
			return fragmentShader(uv);

		}


void main()
{
    vec2 ndc = ((gl_FragCoord.xy * 2.) / openfl_TextureSize.xy) - vec2(1.);
    float aspect = openfl_TextureSize.x / openfl_TextureSize.y;
    vec3 outColor = vec3(.4,.6,.9);
    
    float depth = 1.0;
    for(int i = 0; i < 18; i += 3) {
        vec4 tri = pixel(ndc, aspect, depth, i);
        outColor = mix(outColor.rgb, tri.rgb, tri.a);
    }
    
    gl_FragColor = vec4(outColor, 1.);
}
	
	
	
	')
	public function new()
	{
		super();
	}
}
