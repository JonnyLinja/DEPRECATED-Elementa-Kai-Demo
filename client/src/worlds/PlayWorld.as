package worlds {
	import flash.geom.Point;
	import gestures.Gesture;
	
	import playerio.Message;
	
	import flashpunk.World;
	import flashpunk.FP;
	import flashpunk.utils.Input;
	import flashpunk.utils.Key;
	
	import flash.utils.getTimer;
	
	import networking.Net;
	import entities.Bender;
	import commands.Command;
	import commands.MouseCommand;
	import general.Utils;
	import worlds.GameWorld;
	import gestures.DragGesture;
	import gestures.FlickGesture;
	import inputs.BenderInput;
	
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
		private static const FRAME_DELAY:uint = 3; //how many frames to delay inputs by - has to be at least 1!
		private static const FRAME_MIN_SEND:uint = 10; //tries sends mouse position - was set to 10!
		private var trueFrame:uint = 0; //current frame of true
		private var perceivedFrame:uint = 0; //current frame of perceived
		private var lastEnemyFrame:uint = 0; //last frame received by enemy
		private var lastMyFrame:uint = 0; //last frame inputted by player
		
		//time
		private var currentTime:uint = 0;
		private var nextFrameTime:uint = 0; //for perceived
		
		//game loop
		private var perceivedUpdateCount:int; //number of times perceived was updated during this frame
		
		//boolean checks
		private var isP1:Boolean;
		private var shouldRender:Boolean = true;
		private var c:Boolean;
		
		//gestures
		private var dragGesture:DragGesture = new DragGesture;
		
		//inputs
		private var myInputs:BenderInput;
		
		public function PlayWorld(isP1:Boolean) {
			//set variables
			this.isP1 = isP1;
			nextFrameTime = getTimer();
			
			//message handler
			Net.conn.addMessageHandler(Net.MESSAGE_COMMANDS, receiveEnemyCommands);
			
			//sync
			trueWorld.beginSync();
			perceivedWorld.beginSync();
			
			//inputs
			myInputs = new BenderInput(isP1); //eventually specific to bender type
			
			//log
			Utils.log("isP1 " + isP1);
			
			//perceivedWorld.camera.x = 100;
			
			/*
			//temp
			if (!isP1)
				gestureProcessor = new EarthGestureProcessor(isP1);
			else
				gestureProcessor = new GestureProcessor(isP1);
			*/
		}
		
		/**
		 * Window focus
		 */
		override public function focusLost():void {
			Input.clear();
			myInputs.lostWindowFocus = true;
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
				m = Net.conn.createMessage(Net.MESSAGE_COMMANDS);
				
				//frame
				m.add(c.frame-lastMyFrame);
				lastMyFrame = c.frame;
				
				//mouse
				m.add(Input.mouseX);
				m.add(Input.mouseY);
			}
				
			//add command type to message
			m.add(c.type);
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
			var cMouseX:int = m.getInt(1);
			var cMouseY:int = m.getInt(2);
			
			//increment true max
			lastEnemyFrame += m.getUInt(0);
			
			//if((perceivedFrame - lastEnemyFrame) > 0)
				//Utils.log("frame difference is " + (perceivedFrame - lastEnemyFrame));
			
			//loop insert new command
			for (var pos:int=3; pos<length; pos++) {
				c = m.getInt(pos);
				switch(c) {
					case Command.W:
					case Command.A:
					case Command.S:
					case Command.D:
						insertCommand(new Command(!isP1, c, lastEnemyFrame));
						break;
					default:
						insertCommand(new MouseCommand(!isP1, c, lastEnemyFrame, cMouseX, cMouseY));
						break;
				}
			}
		}
		
		/**
		 * Updates true, perceived, and inputs
		 */
		override public function update():void {
			currentTime = getTimer();
			
			//set elapsed
			FP.elapsed = GameWorld.FRAME_ELAPSED;
			
			//updates
			updateTrueWorld();
			updatePerceivedWorld();
			updateInputsAndGestures();
			
			var ftime:int = getTimer();
			var ttime:int = (ftime-currentTime);
			
			//if(ttime != 0)
				//Utils.log(stime + " -> " + ftime + " = " + ttime);
		}
		
		/**
		 * Updates the true world if able
		 * If able, performs rollback on the perceived world
		 */
		private function updateTrueWorld():void {
			//determine frame to loop to
			var leastFrame:Number = Math.min(lastEnemyFrame, perceivedFrame-1);
			
			//synchronize
			if(trueFrame <= leastFrame)
				//shouldRender = true;
				trueWorld.synchronize(perceivedWorld);
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
						trueWorld.executeCommand(commandToCheck);
						
						//increment true command
						trueCommand = commandToCheck;
					}
				}
				
				//update true world
				trueWorld.update();
				
				//increment true frame
				trueFrame++;
			}while (trueFrame <= leastFrame);
			
			//should rollback
			if (!shouldRollback)
				return;
			
			//rollback
			perceivedWorld.synchronize(trueWorld);
			perceivedWorld.rollback(trueWorld);
			perceivedCommand = trueCommand;
			
			//loop update perceived
			for (var tempFrame:int = trueFrame; tempFrame < perceivedFrame-1; tempFrame++ ) {
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
						perceivedWorld.executeCommand(commandToCheck);
						
						//increment perceived command
						perceivedCommand = commandToCheck;
					}
				}
				
				//update perceived world
				perceivedWorld.update();
			}
		}
		
		/**
		 * Updates the perceived world if able
		 * If able, sends message to server
		 */
		private function updatePerceivedWorld():void {
			//should render
			if (currentTime >= nextFrameTime)
				shouldRender = true;
			else
				return;
			
			//reset count
			perceivedUpdateCount = 0;
			
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
						perceivedWorld.executeCommand(commandToCheck);
						
						//increment perceived command
						perceivedCommand = commandToCheck;
					}
				}
				
				//update perceived world
				perceivedWorld.update();
				
				//increment perceived frame
				perceivedFrame++;
				
				//increment count
				perceivedUpdateCount++;
				
				//increment next frame
				nextFrameTime += GameWorld.FRAME_RATE;
			}while (currentTime >= nextFrameTime);
		}
		
		/**
		 * Adds to current command list
		 * Adds new commands to the message to be sent
		 */
		private function updateInputsAndGestures():void {
			
			//temp display shit
			if (Input.check(Key.C) != c) {
				c = !c;
				if (c)
					printCommands();
			}
			
			
			//determine is should run
			if (!shouldRender)
				return;
			
			//declare variables
			var toSendFrame:uint = perceivedFrame + FRAME_DELAY;
			
			//update gestures (note these gestures don't care about mouse click)
			dragGesture.update(Input.mouseX, Input.mouseY, false, false, perceivedUpdateCount);
			
			//update bender inputs
			myInputs.update(toSendFrame, perceivedUpdateCount);
			
			//add my commands from the input class
			while (myInputs.hasNext())
				addMyCommand(myInputs.getNext());
			
			//blank commands
			if (!m) {
				if (lastMyFrame + FRAME_MIN_SEND < toSendFrame || dragGesture.check() == Gesture.SUCCESS)
					addMyCommand(new MouseCommand(isP1, MouseCommand.BLANK, toSendFrame, Input.mouseX, Input.mouseY));
			}
			
			//send message
			if (m) {
				dragGesture.reset(); //only need to check distance if nothing else has been sent for a while
				
				Net.conn.sendMessage(m);
				m = null;
			}
		}
		
		/**
		 * Renders the perceived world
		 */
		override public function render():void {
			if (shouldRender)
				perceivedWorld.render();
			shouldRender = false;
		}
		
		/**
		 * Destroys the command linked list and the two worlds upon finishing
		 */
		override public function end():void {
			Net.conn.removeMessageHandler(Net.MESSAGE_COMMANDS, null);
		}
		
		
		public function displayCommands():String {
			var result:String = "====================FRAMES====================\n";
			result += "true: " + trueFrame + "\nperceived:" + perceivedFrame + "\n";
			
			result += "====================COMMANDS====================\n";
			result += "frame\ttype\tplayer\tx\ty\n"
			
			//declare variables
			var cmd:Command = firstCommand;
			
			while (cmd) {
				//print
				if (cmd is MouseCommand)
					result += cmd.frame + "\t" + cmd.type + "\t" + cmd.player + "\t" + (cmd as MouseCommand).x + "\t" + (cmd as MouseCommand).y + "\n";
				else
					result += cmd.frame + "\t" + cmd.type + "\t" + cmd.player + "\n";
				if (cmd == trueCommand)
					result += "\ttrue\n";
				if (cmd == perceivedCommand)
					result += "\tperceived\n";
				if (cmd.prev && (cmd.prev).next != cmd)
					result += "\tstructure error, prev.next != self\n";
				if (cmd.next && (cmd.next).prev != cmd)
					result += "\tstructure error, next.prev != self\n";
				
				//increment
				cmd = cmd.next;
			}
			
			return result;
		}
		
		public function printCommands():void {
			Utils.log(displayCommands());
		}
		
	}
}