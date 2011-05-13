package networking {
	import playerio.Client;
	import playerio.Connection;

	/**
	 * ...
	 * @author 
	 */
	public class Net {
		//connection variables
		public static var conn:Connection;
		public static var client:Client;
		
		//general constants
		public static const gameID:String = "";
		public static const gameType:String = "ElementaKai";
		public static const roomLobby:String = "LOBBY";
		
		//message constants
		public static const messageRoomChange:String = "R";
		public static const messageStart:String = "S";
		public static const messageCommands:String = "C";
		public static const messagePoke:String = "P";
		
		public function Net() {}
	}
}