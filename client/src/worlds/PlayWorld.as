package worlds {
	import playerio.Message;
	
	import flashpunk.utils.Input;
	import flashpunk.utils.Key;
	import flashpunk.World;
	import flashpunk.FP;
	
	import networking.Net;
	import entities.Bender;
	import commands.Command;
	import general.Utils;
	import worlds.GameWorld;
	
	public class PlayWorld extends World {
		//worlds
		private var perceivedWorld:GameWorld = new GameWorld();
		private var trueWorld:GameWorld = new GameWorld();
		
		//command datastructure
		private var firstCommand:Command; //first in linked list
		private var lastCommand:Command; //last in linked list
		private var trueCommand:Command; //last executed true command
		private var perceivedCommand:Command; //last executed perceived command
		
		//networking
		private var m:Message = null; //to send
		
		//frames
		private const frameRate:uint = 20; //50 fps
		private const frameDelay:uint = 3; //how many frames to delay inputs by - has to be at least 1!
		private var trueFrame:uint = 0; //current frame of true
		private var trueMaxFrame:uint = 0; //maximum received true frame
		private var perceivedFrame:uint = 0; //current frame of perceived
		
		//time
		private var nextFrameTime:uint = 0; //for perceived
		
		//boolean checks
		private var isP1:Boolean;
		private var shouldRender:Boolean = true;
		
		//my inputs
		private var a:Boolean = false;
		private var d:Boolean = false;
		private var w:Boolean = false;
		private var s:Boolean = false;
		
		public function PlayWorld(isP1:Boolean) {
			//set variables
			this.isP1 = isP1;
			nextFrameTime = FP.time;
			
			//message handler
			Net.conn.addMessageHandler(Net.messageCommands, receiveEnemyCommands);
		}
		
		/**
		 * Inserts to the command linked list with a linear search from end
		 * @param	c
		 */
		private function insertCommand(c:Command):void {
			//declare vars
			var current:Command = lastCommand;
			
			//insertion
			if (current) {
				//add to existing
				
				//search for position based on frames
				while (c.frame < current.frame) {
					current = current.prev;
					if (!current)
						break;
				}
				
				//connect linked list
				if (current) {
					//add normally
					c.prev = current;
					c.next = current.next;
					if (c.next) {
						//not last command
						(c.next).prev = c;
					}else {
						//last one, reset last command
						lastCommand = c;
					}
					current.next = c;
				}else {
					//is at beginning of list - should never happen but just in case
					c.next = firstCommand;
					firstCommand.prev = c;
					firstCommand = c;
				}
			}else {
				//is first command
				lastCommand = c;
				firstCommand = c;
			}
		}
		
		/**
		 * Inserts current player command
		 * Updates the message variable with a new command
		 * Used for current player commands only, not received ones
		 * @param	c
		 */
		private function addMyCommand(c:Command):void {
			//insert command
			insertCommand(c);
			
			//instantiate message and add frame/mouse
			if (!m) {
				//message
				m = Net.conn.createMessage(Net.messageCommands);
				
				//frame
				m.add(c.frame);
				
				//mouse
				//m.add(Input.mouseX);
				//m.add(Input.mouseY);
			}
				
			//add command type to message
			m.add(c.command);
		}
		
		/**
		 * Inserts enemy command
		 * Executed upon receiving an enemy command
		 * @param	m
		 */
		private function receiveEnemyCommands(m:Message):void {
			//declare variables
			var length:int = m.length;
			var c:int;
			//var mouseX:int = m.getInt(1);
			//var mouseY:int = m.getInt(2);
			
			//increment true max
			trueMaxFrame = m.getUInt(0);
			
			Utils.log("frame difference is " + (perceivedFrame - trueMaxFrame));
			
			//loop insert new command
			for (var pos:int=1; pos<length; pos++) {
				c = m.getInt(pos);
				switch(c) {
					case Command.W:
					case Command.A:
					case Command.S:
					case Command.D:
						insertCommand(new Command(!isP1, c, trueMaxFrame, false));
				}
			}
		}
		
		/**
		 * Updates true, perceived, and inputs
		 */
		override public function update():void {
			FP.elapsed = frameRate / 1000;
			updateTrueWorld();
			updatePerceivedWorld();
			updateInputs();
		}
		
		/**
		 * Updates the true world if able
		 * If able, performs rollback on the perceived world
		 */
		private function updateTrueWorld():void {
			//determine frame to loop to
			var leastFrame:Number = Utils.least(trueMaxFrame, perceivedFrame);
			
			//should render
			if(trueFrame <= leastFrame)
				shouldRender = true;
			else
				return;
			
			//declare variables
			var shouldRollback:Boolean = false;
			var commandToCheck:Command;
			
			//loop update true
			do {
				//commands
				if (firstCommand) {
					//at least 1 command!, loop through them
					while (true) {
						//set command to check
						if (!trueCommand)
							//never executed command before, check against firstCommand
							commandToCheck = firstCommand;
						else
							//executed command before, check against nextCommand
							commandToCheck = trueCommand.next;
						
						//should execute command check
						if (!commandToCheck || commandToCheck.frame != trueFrame)
							break;
						
						//should rollback
						shouldRollback = true;
						
						//execute command
						trueWorld.executeCommand(commandToCheck.player, commandToCheck.command);
						
						//increment true command
						trueCommand = commandToCheck;
					}
				}
				
				//update true world
				trueWorld.updateGameWorld();
				
				//increment true frame
				trueFrame++;
			}while (trueFrame <= leastFrame);
			
			//should rollback
			if (!shouldRollback)
				return;
			
			//rollback
			perceivedWorld.rollback(trueWorld);
			perceivedCommand = trueCommand;
			
			//loop update perceived
			for (var tempFrame:int = trueFrame; tempFrame < perceivedFrame; tempFrame++ ) {
				//commands
				if (firstCommand) {
					//at least 1 command!, loop through them
					while (true) {
						//set command to check
						if (!perceivedCommand)
							//never executed command before, check against firstCommand
							commandToCheck = firstCommand;
						else
							//executed command before, check against nextCommand
							commandToCheck = perceivedCommand.next;
						
						//should execute command check
						if (!commandToCheck || commandToCheck.frame != tempFrame)
							break;
						
						//execute command
						perceivedWorld.executeCommand(commandToCheck.player, commandToCheck.command);
						
						//increment perceived command
						perceivedCommand = commandToCheck;
					}
				}
				
				//update perceived world
				perceivedWorld.updateGameWorld();
			}
		}
		
		/**
		 * Updates the perceived world if able
		 * If able, sends message to server
		 */
		private function updatePerceivedWorld():void {
			//should render
			if (FP.time >= nextFrameTime)
				shouldRender = true;
			else
				return;
			
			/*
			//send message
			if (m) {
				Net.conn.sendMessage(m);
				m = null;
			}
			*/
			
			//declare variables
			var commandToCheck:Command;
			
			//loop update perceived
			do {
				//commands
				if (firstCommand) {
					//at least 1 command!, loop through them
					while (true) {
						//set command to check
						if (!perceivedCommand) {
							//never executed command before, check against firstCommand
							commandToCheck = firstCommand;
						}else
							//executed command before, check against nextCommand
							commandToCheck = perceivedCommand.next;
						
						//should execute command check
						if (!commandToCheck || commandToCheck.frame != perceivedFrame)
							break;
						
						//execute command
						perceivedWorld.executeCommand(commandToCheck.player, commandToCheck.command);
						
						//increment perceived command
						perceivedCommand = commandToCheck;
					}
				}
				
				//update perceived world
				perceivedWorld.updateGameWorld();
				
				//increment perceived frame
				perceivedFrame++;
				
				//increment next frame
				nextFrameTime += frameRate;
			}while (FP.time >= nextFrameTime);
		}
		
		/**
		 * Adds to current command list
		 * Adds new commands to the message to be sent
		 */
		private function updateInputs():void {
			if (!shouldRender)
				return;
			
			//left
			if(Input.check(Key.A) != a) {
				a = !a;
				addMyCommand(new Command(isP1, Command.A, perceivedFrame+frameDelay));
			}
			
			//right
			if(Input.check(Key.D) != d) {
				d = !d;
				addMyCommand(new Command(isP1, Command.D, perceivedFrame + frameDelay));
			}
			
			//up
			if(Input.check(Key.W) != w) {
				w = !w;
				addMyCommand(new Command(isP1, Command.W, perceivedFrame+frameDelay));
			}
			
			//down
			if(Input.check(Key.S) != s) {
				s = !s;
				addMyCommand(new Command(isP1, Command.S, perceivedFrame+frameDelay));
			}
			
			//send message
			if (m) {
				Net.conn.sendMessage(m);
				m = null;
			}
		}
		
		/**
		 * Renders the perceived world
		 */
		override public function render():void {
			if(shouldRender)
				perceivedWorld.render();
			shouldRender = false;
		}
		
		/**
		 * Destroys the command linked list and the two worlds upon finishing
		 */
		override public function end():void {
			
		}
	}
}