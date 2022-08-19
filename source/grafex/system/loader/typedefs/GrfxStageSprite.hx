package grafex.system.loader.typedefs;

import grafex.system.assets.typedefs.GrfxObjectProperties;

typedef GrfxStageSprite = {
	var name:String;
	var type:String;
	@:optional var animation:GrfxStageAnim;
	var props:GrfxObjectProperties;
}