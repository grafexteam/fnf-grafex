package grafex.system.typedefs;

typedef GrfxObjectProperties = {
    @:optional var x:Null<Float>;
    @:optional var y:Null<Float>;
    @:optional var scrollfactor:Array<Float>;
    @:optional var scale:Null<Float>;
    @:optional var image:Null<String>;
    @:optional var animation:GrfxAnimatedSprite;

    @:optional var width:Null<Float>;
    @:optional var height:Null<Float>;
    @:optional var alpha:Null<Float>;
    @:optional var antialiasing:Null<Bool>;
}