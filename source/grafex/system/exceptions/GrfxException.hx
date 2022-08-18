package grafex.system.exceptions;

import haxe.Exception;

class GrfxException extends Exception
{
    @:noCompletion public var exceptionType(default, null):String;
    @:noCompletion public var exceptionCode(default, null):Int;

    public function new(type:String, message:String, code:Int)
    {
        super(message);
        this.exceptionType = type;
        this.exceptionCode = code;
    }

    public function getType()
    {
        return exceptionType;
    }

    public function getCode()
    {
        return exceptionCode;
    }

    override public function toString()
    {
        return exceptionType + exceptionCode + ': ' + message;
    }
}