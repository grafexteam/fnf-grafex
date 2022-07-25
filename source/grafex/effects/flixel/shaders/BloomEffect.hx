class BloomEffect extends Effect
{
	public var shader:BloomShader = new BloomShader();

	public function new(blurSize:Float, intensity:Float)
	{
		shader.blurSize.value = [blurSize];
		shader.intensity.value = [intensity];
	}
}

class BloomShader extends FlxShader
{
	@:glFragmentSource('
	
	#pragma header
	
	uniform float intensity = 0.35;
	uniform float blurSize = 1.0/512.0;
void main()
{
   vec4 sum = vec4(0);
   vec2 texcoord = openfl_TextureCoordv;
   int j;
   int i;

   //thank you! http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/ for the 
   //blur tutorial
   // blur in y (vertical)
   // take nine samples, with the distance blurSize between them
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 4.0*blurSize, texcoord.y)) * 0.05;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 3.0*blurSize, texcoord.y)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - 2.0*blurSize, texcoord.y)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x - blurSize, texcoord.y)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y)) * 0.16;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + blurSize, texcoord.y)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 2.0*blurSize, texcoord.y)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 3.0*blurSize, texcoord.y)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x + 4.0*blurSize, texcoord.y)) * 0.05;
	
	// blur in y (vertical)
   // take nine samples, with the distance blurSize between them
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 4.0*blurSize)) * 0.05;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 3.0*blurSize)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - 2.0*blurSize)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y - blurSize)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y)) * 0.16;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + blurSize)) * 0.15;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 2.0*blurSize)) * 0.12;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 3.0*blurSize)) * 0.09;
   sum += flixel_texture2D(bitmap, vec2(texcoord.x, texcoord.y + 4.0*blurSize)) * 0.05;

   //increase blur with intensity!
   gl_FragColor = sum*intensity + flixel_texture2D(bitmap, texcoord); 
  // if(sin(iTime) > 0.0)
   //    fragColor = sum * sin(iTime)+ texture(iChannel0, texcoord);
  // else
	//   fragColor = sum * -sin(iTime)+ texture(iChannel0, texcoord);
}
	
	
	')
	public function new()
	{
		super();
	}
}
