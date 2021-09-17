package;

import Sys.sleep;
import discord_rpc.DiscordRpc;
import Data;

using StringTools;

class DiscordClient
{
	public function new()
	{
		DiscordRpc.start({
			clientID: "886589338345947156",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}
	
	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}
	
	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menu",
			state: null,
			largeImageKey: 'logo',
			largeImageText: "Grafex Engine"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		// I deleted traces, so this does nothing now - Xale
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		// I deleted traces, so this does nothing now - Xale
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'logo',
			largeImageText: "Graphex " + EngineData.modEngineVersion,
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});
	}
}
