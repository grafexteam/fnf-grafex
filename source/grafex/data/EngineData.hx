package grafex.data;

class EngineData
{
    public static var notParsedVersion:Array<Int> = [0, 5, 0];
    
    public static var grafexEngineVersion:String = (notParsedVersion[0] + '.' + notParsedVersion[1] + '.' + notParsedVersion[2]).toString(); //parseVersion(notParsedVersion); //This is also used for Discord RPC  || Maybe, why not ¯\_(ツ)_/¯ - Snake
    public static var PsychEngineLuaCheckersVersion:String = '0.6.3'; // This for FUnKIN lua Psych Version checkers - PurSnake

    public static var devsNicks:Array<String> = ['JustXale', 'PurSnake', 'MrOlegTitov'];

    public static var githubLink:String = 'https://github.com/grafexteam/fnf-grafex';
}

