package networking {
	import playerio.Client;
	import playerio.Connection;
	
	public class Net {
		//connection variables
		public static var conn:Connection;
		public static var client:Client;
		
		//general constants
		public static const GAME_ID:String = "";
		public static const GAME_TYPE:String = "ElementaKai";
		public static const ROOM_LOBBY:String = "LOBBY";
		
		//message constants
		public static const MESSAGE_ROOM_CHANGE:String = "R";
		public static const MESSAGE_START:String = "S";
		public static const MESSAGE_COMMANDS:String = "C";
		public static const MESSAGE_POKE:String = "P";
		
		public function Net() {}
	}
}