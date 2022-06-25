package data;

class EngineData
{
    public static var grafexEngineVersion:String = getVersion(); //This is also used for Discord RPC  || Maybe, why not ¯\_(ツ)_/¯ - Snake
    public static var PsychEngineLuaCheckersVersion:String = '0.5.2h'; // This for FUnKIN lua Psych Version checkers - PurSnake

    public static function getVersion():String
    {
        return '0.4';
        // does nothing now
    }
}

