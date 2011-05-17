package worlds {
	import flashpunk.World;
	import flashpunk.FP;
	import general.Utils;
	import playerio.*;
	import networking.Net;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	public class LoginWorld extends World {
		private var pokeStart:int;
		private const LOCAL:Boolean = false;
		
		public function LoginWorld() {
		}
		
		override public function begin():void {
			//Connect and join the room
			PlayerIO.connect(
				FP.stage,								//Referance to stage
				Net.GAME_ID,								//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",								//Connection id, default is public
				"GuestUser",							//Username
				"",										//User auth. Can be left blank if authentication is disabled on connection
				handleConnect,							//Function executed on successful connect
				handleError								//Function executed if we recive an error
			);
		}
		
		/**
		 * Called on a playerio related error
		 * Displays error message
		 * @param	error
		 */
		private function handleError(error:PlayerIOError):void {
			Utils.log(error.name + ":");
			Utils.log(error.message);
		}
		
		/**
		 * Called on successful connection
		 * Joins the lobby
		 * @param	client
		 */
		private function handleConnect(client:Client):void {
			//local
			if(LOCAL)
				client.multiplayer.developmentServer = "localhost:8184";
			
			//log
			Utils.log("Connected to server")
			
			//join lobby
			client.multiplayer.createJoinRoom(
				Net.ROOM_LOBBY,						//Room id. If set to null a random roomid is used
				Net.GAME_TYPE,						//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoinLobby,					//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
			
			//store client
			Net.client = client;
		}

		/**
		 * Called on joining the lobby
		 * Begins ping checks
		 * Waits for room change message
		 * @param	conn
		 */
		private function handleJoinLobby(conn:Connection):void {
			//log
			Utils.log("joined lobby, waiting for opponent")
			
			//store connection
			Net.conn = conn;
			
			//message handlers
			Net.conn.addMessageHandler(Net.MESSAGE_ROOM_CHANGE, handleRoomChange);
			Net.conn.addMessageHandler(Net.MESSAGE_POKE, handlePoke);
			
			//send ping request
			pokeStart = getTimer();
			Net.conn.send(Net.MESSAGE_POKE);
		}
		
		/**
		 * Called on receiving poke
		 * Displays ping
		 * @param	m
		 */
		private function handlePoke(m:Message):void {
			//display ping
			var currentTime:int = getTimer();
			Utils.log("ping: " + (currentTime - pokeStart) + " ms");
			
			//resend ping request
			if (flash.utils.getQualifiedClassName( FP.world ) == "worlds::LoginWorld") {
				pokeStart = currentTime;
				Net.conn.send(Net.MESSAGE_POKE);
			}
		}
		
		/**
		 * Called on getting a game room
		 * Disconnects from lobby
		 * Joins new room
		 * @param	m
		 */
		private function handleRoomChange(m:Message):void {
			//kill old connection
			Net.conn.removeMessageHandler(Net.MESSAGE_POKE, null);
			Net.conn.removeMessageHandler(Net.MESSAGE_ROOM_CHANGE, null);
			Net.conn.disconnect();
			Net.conn = null;
			
			//log
			var newRoom:String = m.getString(0);
			Utils.log("player found, joining game room " + newRoom);
			
			//join room
			Net.client.multiplayer.createJoinRoom(
				newRoom,							//Room id. If set to null a random roomid is used
				Net.GAME_TYPE,						//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoinGame,						//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		private function handleJoinGame(conn:Connection):void {
			//log
			Utils.log("joined game room, waiting for other player");
			
			//store connection
			Net.conn = conn;
			
			//message handlers
			Net.conn.addMessageHandler(Net.MESSAGE_START, handleStart);
		}
		
		/**
		 * Called when is ready -> both players have joined the room
		 * Should not be in title state; move it later
		 * @param	m
		 */
		private function handleStart(m:Message):void {
			//log
			Utils.log("starting game");
			
			//should have a faster check for isPlaying, but may not matter as shouldn't get start again
			if (flash.utils.getQualifiedClassName( FP.world ) == "worlds::LoginWorld")
				//play game
				FP.world = new PlayWorld(m.getBoolean(0));
			else
				//display error
				Utils.log("Received redundant start command");
		}
	}

}