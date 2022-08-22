package grafex.system.typedefs;

import grafex.system.typedefs.GrfxObjectProperties;

typedef GrfxStageSprite = {
	var name:String;
	var type:String;
	@:optional var animation:GrfxStageAnim;
	var props:GrfxObjectProperties;
}