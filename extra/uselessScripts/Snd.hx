import faxe.Faxe;

using StringTools;

enum TVVar{
	TVVVolume;
	TVVPan;
}

@:publicFields
class TweenV {
	static var GUID = 0;
	var uid 		= 0;
	
	var man 		: SndTV;	 
	var parent		: Snd;
	var n			: Float;
	var ln			: Float;
	var speed		: Float;
	var from		: Float;
	var to			: Float;
	var type		: TType;
	var plays		: Int;
	var varType		: TVVar; 
	var onUpdate	: Null<TweenV->Void>;
	var onEnd		: Null<TweenV->Void>;
	var isDebug		= false;
	
	public inline function new (
		parent:Snd	 ,
	    n:Float		 ,
	    ln:Float	 ,
		varType:TVVar,
	    speed:Float	 ,
	    from:Float	 ,
	    to:Float	 ,
	    type:h2d.Tweenie.TType ,
	    plays		 ,
	    onUpdate	 ,
	    onEnd		 
	) {
		this.parent			= parent		;
		this.n			    = n			 	;
		this.ln			    = ln			;
		this.varType 		= varType 		;
		this.speed		    = speed			;
		this.from		    = from			;
		this.to			    = to			;
		this.type		    = type		 	;
		this.plays		    = plays		 	;
		this.onUpdate	    = onUpdate	 	;
		this.onEnd		    = onEnd		 	;
	}
	
	public inline function reset(
		parent:Snd	 ,
	    n:Float		 ,
	    ln:Float	 ,
		varType:TVVar,
	    speed:Float	 ,
	    from:Float	 ,
	    to:Float	 ,
	    type:TType	 ,
	    plays:Int	 ,
	    onUpdate	 ,
	    onEnd		 
	) {
		this.parent			= parent		;
		this.n			    = n			 	;
		this.ln			    = ln			;
		this.speed		    = speed			;
		this.from		    = from			;
		this.to			    = to			;
		this.type		    = type		 	;
		this.plays		    = plays		 	;
		this.onUpdate	    = onUpdate	 	;
		this.onEnd		    = onEnd		 	;
		this.varType 		= varType 		;
		isDebug		= false;
		uid = GUID++;
	}
	
	public function clear(){
		n 			= 0.0;
		ln			= 0.0;
		speed 		= 0.0;
		plays		= 0;
		from		= 0.0;
		to			= 0.0;
		parent = null;
		onEnd = null;
		onUpdate = null;
		isDebug		= false;
		uid = GUID++;
	}
	
	
	public 
	inline
	function apply( val ) {
		switch(varType){
			case TVVVolume: {
				parent.volume = val;
				#if debug
				if( isDebug )
				trace("tv:" + val);
				#end
			}
			case TVVPan: 	parent.pan = val;
		}
		
	}
	
	public inline function kill( withCbk = true ) {
		if ( withCbk )	
			man.terminateTween( this );
		else 
			man.forceTerminateTween( this) ;
	}
	
}

class SndTV {
	static var DEFAULT_DURATION = DateTools.seconds(1);
	public var fps 				= 60.0;
	public var isDebug			= false;

	var tlist					: hxd.Stack<TweenV>;

	public function new() {
		tlist = new hxd.Stack<TweenV>();
		tlist.reserve(8);
	}
	
	function onError(e) {
		trace(e);
	}
	
	public function count() {
		return tlist.length;
	}
	
	public inline function create(parent:Snd, vartype:TVVar, to:Float, ?tp:h2d.Tweenie.TType, ?duration_ms:Float) : TweenV{
		return create_(parent, vartype, to, tp, duration_ms);
	}
	
	public function exists(p:Snd) {
		for (t in tlist)
			if (t.parent == p )
				return true;
		return false;
	}
	
	public var pool : hxd.Stack<TweenV> = new hxd.Stack();

	function create_(p:Snd, vartype:TVVar,to:Float, ?tp:h2d.Tweenie.TType, ?duration_ms:Float) : TweenV{
		if ( duration_ms==null )
			duration_ms = DEFAULT_DURATION;

		#if debug
		if ( p == null ) trace("tween2 creation failed to:"+to+" tp:"+tp);
		#end
			
		if ( tp==null ) tp = TEase;

		{
			for(t in tlist.backWardIterator())
				if(t.parent==p && t.varType == vartype) {
					forceTerminateTween(t);
				}
		}
		
		var from = switch( vartype ){
			case TVVVolume 	: p.volume;
			case TVVPan 	: p.pan;
		}
		var t : TweenV;
		if (pool.length == 0){
			t = new TweenV(
				p,
				0.0,
				0.0,
				vartype,
				1 / ( duration_ms*fps/1000 ),
				from,
				to,
				tp,
				1,
				null,
				null
			);
		}
		else {
			t = pool.pop();
			t.reset(
				p,
				0.0,
				0.0,
				vartype,
				1 / ( duration_ms*fps/1000 ),
				from,
				to,
				tp,
				1,
				null,
				null
			); 
			
		}

		if( t.from==t.to )
			t.ln = 1;

		t.man = this;
		tlist.push(t);

		return t;
	}

	public static inline 
	function fastPow2(n:Float):Float {
		return n*n;
	}
	
	public static inline 
	function fastPow3(n:Float):Float {
		return n*n*n;
	}

	public static inline 
	function bezier(t:Float, p0:Float, p1:Float,p2:Float, p3:Float) {
		return
			fastPow3(1-t)*p0 +
			3*( t*fastPow2(1-t)*p1 + fastPow2(t)*(1-t)*p2 ) +
			fastPow3(t)*p3;
	}

	public function killWithoutCallbacks(parent:Snd) {
		for (t in tlist.backWardIterator())
			if (t.parent==parent ){
				forceTerminateTween(t);
				return true;
			}
		return false;
	}
	
	public function terminate(parent:Snd) {
		for (t in tlist.backWardIterator())
			if (t.parent==parent){
				forceTerminateTween(t);
			}
	}
	
	public function forceTerminateTween(t:TweenV) {
		var tOk = tlist.remove(t);
		if( tOk ){
			t.clear();
			pool.push(t);
		}
	}
	
	public function terminateTween(t:TweenV, ?fl_allowLoop=false) {
		var v = t.from + (t.to - t.from) * h2d.Tweenie.interp(t.type, 1);
		t.apply(v);
		onUpdate(t, 1);
		
		var ouid = t.uid;
		
		onEnd(t);
		
		if( ouid == t.uid ){
			if( fl_allowLoop && (t.plays==-1 || t.plays>1) ) {
				if( t.plays!=-1 )
					t.plays--;
				t.n = t.ln = 0;
			}
			else {
				forceTerminateTween(t);
			}
		}
	}
	
	public function terminateAll() {
		for(t in tlist)
			t.ln = 1;
		update();
	}
	
	inline
	function onUpdate(t:TweenV, n:Float) {
		if ( t.onUpdate!=null )
			t.onUpdate(t);
	}
	
	inline
	function onEnd(t:TweenV) {
		if ( t.onEnd!=null )
			t.onEnd(t);
	}
	
	public function update(?tmod = 1.0) {
		if ( tlist.length > 0 ) {
			for (t in tlist.backWardIterator() ) {
				var dist = t.to-t.from;
				if (t.type==TRand)
					t.ln+=if(Std.random(100)<33) t.speed * tmod else 0;
				else
					t.ln += t.speed * tmod;
					
				t.n = h2d.Tweenie.interp(t.type, t.ln);
				
				if ( t.ln<1 ) {
					var val = t.from + t.n*dist;
					
					t.apply(val);
					
					onUpdate(t, t.ln);
				}
				else
				{
					terminateTween(t, true);
				}
			}
		}
	}
}

class Channel {
	public var		name:String;
	public var 		onEnd : Void -> Void 	= null;
	public var		isDebug = false;
	
	var started 	= true;
	var paused 		= false;
	var disposed 	= false;
	var completed 	= false;
		
	inline function new( ?name:String = null ){
		if ( name == null )
			this.name = C.EMPTY_STRING;
		else 
			this.name = name;
	}
	
	public function poolBack(){
		started 	= false;
		paused 		= false;
		disposed 	= true;
		completed 	= true;
		isDebug 	= false;
	}
	
	public function reset(){
		started 	= false;
		paused 		= false;
		disposed 	= false;
		completed 	= false;
		isDebug 	= false;
	}
	
	public function stop(){
		started = false;
	}
	
	public function pause(){
		paused = false;
		started = true;
	}
	
	public function resume(){
		paused = true;
		started = true;
	}
	
	public function dispose(){
		setVolume(0);
		disposed = true;
		onEnd = null;
	}
	
	public function onComplete() {
		completed = true;
		if( onEnd!=null ) {
			var cb = onEnd;
			onEnd = null;
			cb();
		}
	}
	
	public function isComplete(){
		
		return completed || (started && !isPlaying());
	}
	
	public function getPlayCursorSec() : Float {
		throw "override me";
		return 0.0;
	}
	
	public function getPlayCursorMs() : Float {
		throw "override me";
		return 0.0;
	}
	
	public function setPlayCursorSec(posSec:Float) {
		setPlayCursorMs( posSec * 1000.0 );
	}
	
	public function setPlayCursorMs(posMs:Float) {
		throw "override me";
	}
	
	public function isPlaying(){
		throw "override me";
		return false;
	}
	
	public function getVolume():Float{
		throw "override me";
		return 0.0;
	}
	
	public function setVolume(v:Float){
		throw "override me";
	}
	
	public function setNbLoops(nb:Int){
		
	}
}

class ChannelEventInstance extends Channel {
	public static var EMPTY_STRING = "";
	public var data : FmodStudioEventInstanceRef = null;
	
	function new(?name:String){
		super(name);
		started = false;
	}
	
	public static var pool = {
		var p = new hxd.Pool<ChannelEventInstance>(ChannelEventInstance);
		p;
	}
	
	public static function alloc(data : FmodStudioEventInstanceRef, ?name:String=null ){
		var s = pool.alloc();
		
		s.reset();
		
		s.data = data;
		s.name = name == null ? EMPTY_STRING : name;
		return s;
	}
	
	public static function delete( c : ChannelEventInstance){
		c.dispose();
		pool.delete(c);
	}
	
	public function getData()	return data;
	
	public override function dispose(){
		super.dispose();
		if ( data != null){
			data.release();
			data = null;
		}
	}
	
	public override function poolBack(){
		super.poolBack();
		ChannelEventInstance.delete(this);
	}
	
	public override function stop(){
		if (data != null) data.stop(FmodStudioStopMode.StopAllowFadeout());
		super.stop();
	}
	
	public override function pause(){
		super.pause();
		if(data!=null) data.setPaused(true);
	}
	
	public override function resume(){
		super.resume();
		if(data!=null) data.setPaused(false);
	}
	
	public override function isPlaying(){
		if ( completed ) return false;
		
		if ( data == null ) {
			return false;
		}
		
		var b : Bool = false;
		data.getPaused( Cpp.addr(b));
		return !b;
	}
	
	public override  function getPlayCursorSec() : Float {
		if ( data == null ) return 0.0;
		
		var pos : Int = 0;
		var res = data.getTimelinePosition( Cpp.addr(pos) );
		var posF : Float = 1.0 * pos / 1000.0;
		return posF;
	}
	
	public override function getPlayCursorMs() : Float {
		if ( data == null ) return 0.0;
		
		var pos : Int = 0;
		var res = data.getTimelinePosition( Cpp.addr(pos) );
		return 1.0 * pos;
	}
	
	public override function setPlayCursorMs(posMs:Float) {
		if ( data == null ) return;
		
		if ( posMs < 0.0) posMs = 0.0;
		var pos : Int = 0;
		pos = Math.round( posMs );
		var res = data.setTimelinePosition( pos );
		if ( res != FMOD_OK){
		}
	}
	
	public override function setNbLoops(nb:Int){
		
	}
	
	public override function getVolume() : Float{
		if (data == null ) return 0.0;
		
		var vol : cpp.Float32 = 0.0;
		var fvol : cpp.Float32 = 0.0;
		var res = data.getVolume( Cpp.addr(vol),Cpp.addr(fvol) );
		if ( res != FMOD_OK){
		}
		return vol;
	}
	
	public override function setVolume(v:Float){
		if (data == null ){
			return;
		}
		
		var res = data.setVolume( hxd.Math.clamp(v,0,1) );
	}
}

class ChannelLowLevel extends Channel{
	
	public static var EMPTY_STRING = "";
	public var 		data : FmodChannelRef 	= null;
	
	function new( data : FmodChannelRef, ?name:String ){
		super(name);
		this.data = data;
		started = true;
	}
	
	public static var pool = {
		var p = new hxd.Pool<ChannelLowLevel>(ChannelLowLevel);
	}
	
	public static function alloc(data : FmodChannelRef, ?name ){
		var s = pool.alloc();
		
		s.reset();
		
		s.data = data;
		s.name = name == null?EMPTY_STRING:name;
		
		return s;
	}
	
	public static function delete( c : ChannelLowLevel){
		c.dispose();
		pool.delete(c);
	}
	
	public function getData(){
		return data;
	}	
	
	public override function poolBack(){
		super.poolBack();
		ChannelLowLevel.delete(this);
	}
	
	public override function stop(){
		if (data != null) data.stop();
		super.stop();
	}
	
	public override function pause(){
		super.pause();
		if(data!=null) data.setPaused(true);
	}
	
	public override function resume(){
		super.resume();
		if(data!=null) data.setPaused(false);
	}
	
	public override function dispose(){
		super.dispose();
		data = null;
	}
	
	public override function isPlaying(){
		if ( completed ) return false;
		
		if (data == null) {
			return false;
		}
		var b : Bool = false;
		var res = data.isPlaying( Cpp.addr(b));
		if ( res != FMOD_OK ){
			return false;
		}
		return b;
	}

	public override  function getPlayCursorSec() : Float {
		if (data == null) return 0.0;
		
		var pos : cpp.UInt32 = 0;
		var res = data.getPosition( Cpp.addr(pos), faxe.Faxe.FmodTimeUnit.FTM_MS );
		var posF : Float = 1.0 * pos * 1000.0;
		return posF;
	}
	
	public override function getPlayCursorMs() : Float {
		if (data == null) return 0.0;
		
		var pos : cpp.UInt32 = 0;
		var res = data.getPosition( Cpp.addr(pos), faxe.Faxe.FmodTimeUnit.FTM_MS );
		return 1.0 * pos;
	}

	
	public override function setPlayCursorMs(posMs:Float) {
		if (data == null) return;
		
		if ( posMs < 0.0) posMs = 0.0;
		var posU : cpp.UInt32 = 0;
		posU = Math.round( posMs );
		var res = data.setPosition( posU, FmodTimeUnit.FTM_MS );
	}
	
	public override function setNbLoops(nb:Int){
		if (data == null) return;
		data.setMode(FmodMode.FMOD_LOOP_NORMAL);
		data.setLoopCount(nb);
	}
	
	public override function getVolume():Float{
		if (data == null) return 0.0;
		
		var vol : cpp.Float32 = 0.0;
		var res = data.getVolume( Cpp.addr(vol) );
		return vol;
	}
	
	public override function setVolume(v:Float){
		if (data == null)
		{
			return;
		}
		
		var vcl = hxd.Math.clamp(v, 0, 1);
		var res = data.setVolume( vcl );
	}
	
	
}

class Sound 
{
	public var name = "";
	public var length(get, null) 						: Float;
	public var id3 	: Dynamic							= null;
	public var isDebug = false;
	
	var disposed = false;
	
	function new( ?name:String=null ){
		disposed = false;
	}
	
	function get_length() : Float{
		return 0.0;
	}
	
	public function getDuration(): Float{
		return getDurationMs();
	}
	
	public function getDurationSec() : Float{
		return length;
	}
	
	public function getDurationMs() : Float{
		return length * 1000.0;
	}
	
	public function dispose(){
		if (disposed) return;
		disposed = true;
	}
	
	public function play( ?offsetMs : Float = 0.0, ?nbLoops:Int = 1, ?volume:Float = 1.0 ) : Channel {
		return null;
	}
}

class SoundLowLevel extends Sound{
	
	public var data : FmodSoundRef					 	= null;
	
	public function new( data : cpp.Pointer<faxe.Faxe.FmodSound>, ?name:String = null ){
		super(name);
		this.data = Cpp.ref(data);
	}
	
	public function getData(){
		return data;
	}
	
	public override function dispose(){
		super.dispose();
		
		if ( Snd.released ) {
			data = null;
			return;
		}
		
		if(data!=null)
			data.release();
		data = null;
	}
	
	override function get_length() : Float{
		if (disposed) return 0.0;
		
		var pos : cpp.UInt32 = 0;
		var res = data.getLength( Cpp.addr(pos), FmodTimeUnit.FTM_MS );
		var posF = 1.0 * pos / 1000.0;
		return posF;
	}
	
	public override function play( ?offsetMs : Float = 0.0, ?nbLoops:Int = 1, ?volume:Float = 1.0) : Channel {
		var nativeChan : FmodChannelRef = FaxeRef.playSoundWithHandle( data , false);
		var chan = ChannelLowLevel.alloc( nativeChan, name );
		
		@:privateAccess chan.started = true;
		@:privateAccess chan.completed = false;
		@:privateAccess chan.disposed = false;
		@:privateAccess chan.paused = false;
		
		
		if( offsetMs != 0.0 ) 	chan.setPlayCursorMs( offsetMs );
		if( volume != 1.0 ) 	chan.setVolume( volume );
		if( nbLoops > 1 ) 		chan.setNbLoops( nbLoops );
		
		return chan;
	}
}


class SoundEvent extends Sound{
	
	public var data : FmodStudioEventDescriptionRef	= null;
	
	public function new( data : FmodStudioEventDescriptionRef, ?name:String = null ){
		super(name);
		this.data = data;
	}
	
	public override function dispose(){
		super.dispose();
		
		if ( Snd.released ) {
			data = null;
			return;
		}
		
		if ( data != null){
			data.releaseAllInstances();
			data = null;
		}
	}
	public function getData(){
		return data;
	}
	
	override function get_length() : Float{
		if (disposed) return 0.0;
		
		var pos : Int = 0;
		var res = data.getLength( Cpp.addr(pos) );
		var posF = 1.0 * pos / 1000.0;
		return posF;
	}
	
	public override function play( ?offsetMs : Float = 0.0, ?nbLoops:Int = 1, ?volume:Float = 1.0) : Channel{
		var nativeInstance : FmodStudioEventInstanceRef = data.createInstance();
		var chan = ChannelEventInstance.alloc( nativeInstance, name );
	
		nativeInstance.start();
		
		@:privateAccess chan.started = true;
		@:privateAccess chan.completed = false;
		@:privateAccess chan.disposed = false;
		@:privateAccess chan.paused = false;
		
		if( offsetMs != 0.0 ) 	chan.setPlayCursorMs( offsetMs );
		if( volume != 1.0 ) 	chan.setVolume( volume );
		
		return chan;
	}
}

class Snd {
	public static var EMPTY_STRING = "";
	public static var 	PLAYING 		: hxd.Stack<Snd> 	= new hxd.Stack();
	static var 	MUTED 									= false;
	static var 	DISABLED		 						= false;
	static var 	GLOBAL_VOLUME 							= 1.0;
	static var 	TW 										= new SndTV();
	
	public var 	name			: String				;
	public var 	pan						: Float					= 0.0;
	public var 	volume(default,set) 	: Float 				= 1.0;
	public var 	curPlay 		: Null<Channel> 		= null;
	public var 	bus				= otherBus;	
	public var  isDebug = true;
	public var 	onStop 									= new hxd.Signal();
	public var 	sound 		: Sound						= null;
		
	var onEnd				: Null<Void->Void>			= null;
	static var fmodSystem 	: FmodSystemRef				= null;
	
	public static var otherBus = new SndBus();
	public static var sfxBus = new SndBus();
	public static var musicBus = new SndBus();
	
	public function new( snd : Sound, ?name:String ) {
		volume = 1;
		pan = 0;
		sound = snd;
		muted = false;
		this.name = name==null?EMPTY_STRING:name;
	}
	
	public function isLoaded() {
		return sound!=null;
	}
	
	public function stop(){
		
		TW.terminate(this);
		
		PLAYING.remove(this);
		
		if ( isPlaying() && !onStop.isTriggering )
			onStop.trigger();
			
		if ( curPlay != null){
			curPlay.dispose();
			curPlay.poolBack();
			curPlay = null;
		}
		
		//bus = otherBus;
	}
	
	public function dispose(){
		
		if ( isPlaying() ){
			stop();
		}
		
		if ( curPlay != null){
			curPlay.dispose();
			curPlay.poolBack();
			curPlay = null;
		}
		
		if ( sound != null) {
			sound.dispose();
			sound = null;
		}
		
		onStop.dispose();
		
		onEnd = null;
		curPlay = null;
	}

	public inline function getPlayCursor() : Float {
		if ( curPlay == null) return 0.0;
		return curPlay.getPlayCursorMs();
	}
	
	
	public function play(?vol:Float, ?pan:Float) : Snd {
		if( vol == null ) 		vol = volume;
		if( pan == null )		pan = this.pan;

		start(0, vol, 0.0);
		
		return this;
	}
	
	public function start(loops:Int=0, vol:Float=1.0, ?startOffsetMs:Float=0.0) {
		if ( DISABLED )
		{
			return;
		}
		if ( sound == null )
		{
			return;
		}

		if ( isPlaying() )
		{
			stop();
		}
			
		TW.terminate(this);
		
		this.volume = vol;
		this.pan = normalizePanning(pan);
		
		PLAYING.push(this);
		curPlay = sound.play( startOffsetMs, loops, getRealVolume());
	}

	public function startNoStop(?loops:Int=0, ?vol:Float=1.0, ?startOffsetMs:Float=0.0) : Null<Channel>{
		if ( DISABLED )
		{
			return null;
		}
		if ( sound == null )
		{
			return null;
		}
		
		this.volume = vol;
		this.pan = normalizePanning(pan);
		
		curPlay = sound.play( startOffsetMs, loops, getRealVolume());
		
		return curPlay;
	}
	
	public inline function getDuration() {
		return getDurationMs();
	}
	
	public inline function getDurationSec() {
		return sound.length;
	}

	public inline function getDurationMs() {
		return sound.length * 1000.0;
	}
	
	public static inline 
	function trunk(v:Float, digit:Int) : Float{
		var hl = Math.pow( 10.0 , digit );
		return Std.int( v * hl ) / hl;
	}
	
	public static function dumpMemory(){
		var v0 : Int = 0;
		var v1 : Int = 0;
		var v2 : Int = 0;
		
		var v0p : cpp.Pointer<Int> = Cpp.addr(v0);
		var v1p : cpp.Pointer<Int> = Cpp.addr(v1);
		var v2p : cpp.Pointer<Int> = Cpp.addr(v2);
		var str = "";
		var res = fmodSystem.getSoundRAM( v0p, v1p, v2p );
		
		inline function f( val :Float) : Float{
			return trunk(val, 2);
		}
		
		if( v2 > 0 ){
			str+="fmod Sound chip RAM all:" + f(v0 / 1024.0) + "KB \t max:" + f(v1 / 1024.0) + "KB \t total: " + f(v2 / 1024.0) + " KB\r\n";
		}
		
		v0 = 0;
		v1 = 0;
		
		var res = FaxeRef.Memory_GetStats( v0p, v1p, false );
		str += "fmod Motherboard chip RAM all:" + f(v0 / 1024.0) + "KB \t max:" + f(v1 / 1024.0) + "KB \t total: " + f(v2 / 1024.0) + " KB";
		return str;
	}
	
	public function playLoop(?loops = 9999, ?vol:Float=1.0, ?startOffset = 0.0) : Snd {
		if( vol==null )
			vol = volume;

		start(loops, vol, startOffset);
		return this;
	}
	
	function set_volume(v:Float) {
		volume = v;
		refresh();
		return volume;
	}
	
	public function setVolume(v:Float) {
		set_volume(v);
	}
	
	public inline function getRealPanning() {
		return pan;
	}

	public function setPanning(p:Float) {
		pan = p;
		refresh();
	}

	public function onEndOnce(cb:Void->Void) {
		onEnd = cb;
	}
	
	public function fadePlay(?fadeDuration = 100, ?endVolume:Float=1.0 ) {
		var p = play(0.0001);
		tweenVolume(endVolume, fadeDuration);
		return p;
	}
	
	public function fadePlayLoop(?fadeDuration = 100, ?endVolume:Float=1.0 , ?loops=9999) {
		var p = playLoop(loops,0);
		tweenVolume(endVolume, fadeDuration);
		return p;
	}
	
	public function fadeStop( ?fadeDuration = 100 ) {
		if ( !isPlaying()){
			return null;
		}
		
		isDebug = true;
		var t = tweenVolume(0, fadeDuration);
		t.onEnd = _stop;
		return t;
	}
	
	public var muted : Bool = false;
	
	public function toggleMute()
	{
		muted = !muted;
		setVolume(volume);
	}
	public function mute() 
	{
		muted = true;
		setVolume(volume);
	}
	public function unmute()
	{
		muted = false;
		setVolume(volume);
	}
	
	public function isPlaying()
	{
		if ( curPlay == null )
		{
			return false;
		}
		return curPlay.isPlaying();
	}
	
	public static function init(){
		#if debug
		trace("[Snd] fmod init");
		#end
		Faxe.fmod_init( 256 );
		fmodSystem = FaxeRef.getSystem();
		released = false;
	}
	
	public static var released = true;
	
	public static function release(){
		TW.terminateAll();
		for (s in PLAYING)
			s.dispose();
		PLAYING.hardReset();
		released = true;
		Faxe.fmod_release();
		#if !prod
		trace("fmod released");
		#end
	}
	
	public static function setGlobalVolume(vol:Float) {
		GLOBAL_VOLUME = normalizeVolume(vol);
		refreshAll();
	}
	
	function refresh() {
		if ( curPlay != null ) {
			var vol = getRealVolume();
			curPlay.setVolume( vol );
		}
	}
	
	public function	setPlayCursorSec( pos:Float ) 	{
		if (curPlay != null)	{
			curPlay.setPlayCursorSec(pos);
		}
	}
	
	public function	setPlayCursorMs( pos:Float ){ 
		if (curPlay != null) 	
			curPlay.setPlayCursorMs(pos);
	}
	
	public function tweenVolume(v:Float, ?easing:h2d.Tweenie.TType, ?milliseconds:Float=100) : TweenV
	{
		if ( easing == null ) easing = h2d.Tweenie.TType.TEase;
		var t = TW.create(this, TVVVolume, v, easing, milliseconds);
		return t;
	}
	
	public function tweenPan(v:Float, ?easing:h2d.Tweenie.TType, ?milliseconds:Float=100) : TweenV
	{
		if ( easing == null ) easing = h2d.Tweenie.TType.TEase;
		var t = TW.create(this, TVVPan, v, easing, milliseconds);
		return t;
	}
	
	public inline function getRealVolume()
	{
		var v = volume * GLOBAL_VOLUME * (DISABLED?0:1) * (MUTED?0:1) * (muted?0:1) * bus.volume;
		if ( v <= 0.001)
			v = 0.0;
		return normalizeVolume(v);
	}
	
	static inline function normalizeVolume(f:Float)
	{
		return hxd.Math.clamp(f, 0,1);
	}

	static inline function normalizePanning(f:Float)
	{
		return hxd.Math.clamp(f, -1,1);
	}
	
	static var _stop = function(t:TweenV)
	{
		t.parent.stop();
	}
	
	static var _refresh = function(t:TweenV)
	{
		if ( released )
		{
			return;
		}
		
		t.parent.refresh();
	}
	
	static function refreshAll()
	{
		for(s in PLAYING)
			s.refresh();
	}
	
	function onComplete()
	{
		if (curPlay != null)
		{
			curPlay.onComplete();
		}
		stop();
	}
	
	public function isComplete(){
		if ( curPlay == null )
		{

			return true;
		}
		return curPlay.isComplete();
	}
		
	public static var DEBUG_TRACK = false;
	
	public static function loadSound( path:String, streaming : Bool, blocking : Bool  ) : Sound
	{
		
		if ( released )
			return null;
		
		var mode = FMOD_DEFAULT;
		
		if ( streaming ) 	mode |= FMOD_CREATESTREAM;
		if ( !blocking ) 	mode |= FMOD_NONBLOCKING;
			
		mode |= FmodMode.FMOD_2D;
		
		
		if( DEBUG_TRACK) trace("Snd:loading " + path);
		
		var snd : cpp.RawPointer<faxe.Faxe.FmodSound> = cast  null;
		var sndR :  cpp.RawPointer<cpp.RawPointer<faxe.Faxe.FmodSound>> = cpp.RawPointer.addressOf(snd);
		
		#if switch
		if ( !path.startsWith("rom:"))
			path = "rom://" + path;
		#end
		
		var res : FmodResult = fmodSystem.createSound( 
			Cpp.cstring(path),
			mode,
			Cpp.nullptr(),
			sndR
		);
			
		if ( res != FMOD_OK){
			#if(!prod)
			trace("unable to load " + path + " code:" + res+" msg:"+FaxeRef.fmodResultToString(res));
			#end
			return null;
		}
		
		var n:String = null;
		
		#if debug
		n  = new bm.Path(path).getFilename();
		#end
			
		return new SoundLowLevel(cpp.Pointer.fromRaw(snd),n);
	}
	
	public static function loadEvent( path:String ) : Sound {
		if ( released ) {
			return null;
		}
		
		
		if( DEBUG_TRACK) trace("Snd:loadingEvent " + path);
		
		if ( !path.startsWith("event:/"))
			path = "event:/" + path;
		
		var fss : FmodStudioSystemRef = faxe.FaxeRef.getStudioSystem();
		var ev = fss.getEvent( path);
		
		if ( ev == null ) return null;
		
		if ( !ev.isLoaded() )
		{
			var t0 = haxe.Timer.stamp();
			ev.loadSampleData();
			var t1 = haxe.Timer.stamp();
		}
		
		return new SoundEvent( ev, path);
	}
	
	public static function fromFaxe( path:String ) : Snd
	{
		if ( released )
			return null;
		
		var s : cpp.Pointer<FmodSound> = faxe.Faxe.fmod_get_sound(path );
		if ( s == null){
			#if (!prod)
			trace("unable to find " + path);
			#end
			return null;
		}
		
		var n:String = null;
		
		#if debug
		n  = new bm.Path(path).getFilename();
		#end
		
		return new Snd( new SoundLowLevel(s,n), path);
	}
	
	public static function loadSfx( path:String ) : Snd {
		var s : Sound = loadSound(path, false, false);
		if ( s == null) return null;
		return new Snd( s, s.name);
	}
	
	public static function loadSong( path:String ) : Snd {
		var s : Sound = loadSound(path, true, true);
		if ( s == null) return null;
		return new Snd( s,  s.name);
	}
	
	public static function load( path:String, streaming=false,blocking=true ) : Snd {
		var s : Sound = loadSound(path, streaming, blocking);
		if ( s == null) {
			#if !prod
			trace("no such file " + path);
			#end
			return null;
		}
		return new Snd( s,  s.name);
	}
	
	public static function terminateTweens()
	{
		TW.terminateAll();
	}
	
	public static function update()
	{
		for ( p in PLAYING.backWardIterator())
			if ( p.isComplete()){
				p.onComplete();
			}
		TW.update();
		
		if(!released ) Faxe.fmod_update();
	}
	
	public static function loadSingleBank( filename : String ) : Null<faxe.Faxe.FmodStudioBankRef>{
		if ( released )
		{
			#if debug 
			trace("FMOD not active "+filename);
			#end
			return null;
		}
		
		if ( filename.endsWith(".fsb"))
		{
			#if debug 
			trace("fsb files not supported");
			#end
			return null;
		}
		
		var t0 = haxe.Timer.stamp();
		var fsys = FaxeRef.getStudioSystem();
		var fbank : cpp.RawPointer < FmodStudioBank > = null;
		
		Lib.loadMode();
		var result = fsys.loadBankFile( 
			cpp.ConstCharStar.fromString( filename ), 
			FmodStudioLoadBank.FMOD_STUDIO_LOAD_BANK_NONBLOCKING, 
			cpp.RawPointer.addressOf(fbank));
		Lib.playMode();	
		
		if (result != FMOD_OK)
		{
			#if debug
			trace("FMOD failed to LOAD sound bank with errcode:" + result + " errmsg:" + FaxeRef.fmodResultToString(result) + "\n");
			#end
			return null;
		}
			
		var t1 = haxe.Timer.stamp();
		return cast fbank;
	}
}