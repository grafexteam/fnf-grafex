package flixel.shaders;

import flixel.system.FlxAssets.FlxShader;

using StringTools;

class BuildingEffect
{
	public var shader:BuildingShader = new BuildingShader();

	public function new()
	{
		shader.alphaShit.value = [0];
	}

	public function addAlpha(alpha:Float)
	{
		trace(shader.alphaShit.value[0]);
		shader.alphaShit.value[0] += alpha;
	}

	public function setAlpha(alpha:Float)
	{
		shader.alphaShit.value[0] = alpha;
	}
}

class BuildingShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header
    uniform float alphaShit;
    void main()
    {

      vec4 color = flixel_texture2D(bitmap,openfl_TextureCoordv);
      if (color.a > 0.0)
        color-=alphaShit;

      gl_FragColor = color;
    }
  ')
	public function new()
	{
		super();
	}
}