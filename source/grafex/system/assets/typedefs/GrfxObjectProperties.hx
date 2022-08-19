package grafex.system.assets.typedefs;

typedef GrfxObjectProperties = {
    var x:Null<Float>;
    var y:Null<Float>;
    var scrollfactor:Array<Float>;
    var scale:Null<Float>;
    var image:Null<String>;
    var animation:GrfxAnimatedSprite;

    @:optional var width:Null<Float>;
    @:optional var height:Null<Float>;
    @:optional var alpha:Null<Float>;
    @:optional var antialiasing:Null<Bool>;
}