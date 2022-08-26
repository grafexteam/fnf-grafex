package grafex.system.typedefs;

typedef GrfxCredits = {   
    var credits:Array<GrfxCredit>;
}

typedef GrfxCredit = {   
    var name:String;
    @:optional var icon:String;
    @:optional var role:String;
    @:optional var socialLink:String;
    @:optional var bgColor:String; 
}