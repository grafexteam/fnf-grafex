class InvertColorsEffect extends Effect
{
	public var shader:InvertShader = new InvertShader();

	public function new(lockAlpha)
	{
		//	shader.lockAlpha.value = [lockAlpha];
	}
}

class InvertShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header
    
    vec4 sineWave(vec4 pt)
    {
	
	return vec4(1.0 - pt.x, 1.0 - pt.y, 1.0 - pt.z, pt.w);
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        gl_FragColor = sineWave(texture2D(bitmap, uv));
		gl_FragColor.a = 1.0 - gl_FragColor.a;
    }')
	public function new()
	{
		super();
	}
}