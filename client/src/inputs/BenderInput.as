package inputs {
	import flashpunk.utils.Input;
	import flashpunk.utils.Key;
	
	import general.Utils;
	import commands.Command;
	import commands.MouseCommand;
	import gestures.Gesture;
	import gestures.FlickGesture;
	
	public class BenderInput {
		//commands
		private var list:Vector.<Command> = new Vector.<Command>;
		
		//gestures
		private var flickGesture:FlickGesture = new FlickGesture;
		
		//booleans
		private var isP1:Boolean = false;
		public var lostWindowFocus:Boolean = false;
		
		//my inputs
		private var a:Boolean = false;
		private var d:Boolean = false;
		private var w:Boolean = false;
		private var s:Boolean = false;
		private var mouse:Boolean = false;
		private var flick:Boolean = false;
		
		public function BenderInput(isP1:Boolean) {
			this.isP1 = isP1;
		}
		
		public function hasNext():Boolean {
			return (list.length > 0);
		}
		
		public function getNext():Command {
			return list.pop();
		}
		
		public function update(toSendFrame:int, frameCount:int):void {
			flickGesture.update(Input.mouseX, Input.mouseY, false, false, frameCount);
			
			if (lostWindowFocus) {
				//left
				if (a) {
					a = false;
					list.push(new Command(isP1, Command.A, toSendFrame));
				}
				
				//right
				if (d) {
					d = false;
					list.push(new Command(isP1, Command.D, toSendFrame));
				}
				
				//up
				if (w) {
					w = false;
					list.push(new Command(isP1, Command.W, toSendFrame));
				}
				
				//down
				if (s) {
					s = false;
					list.push(new Command(isP1, Command.S, toSendFrame));
				}
				
				//mouse
				if (mouse) {
					mouse = false;
					list.push(new MouseCommand(isP1, MouseCommand.CLICK, toSendFrame, Input.mouseX, Input.mouseY));
				}
				
				//flick
				if (flick) {
					flick = false;
					Utils.log("tog flick finish");
					list.push(new MouseCommand(isP1, MouseCommand.FLICK, toSendFrame, Input.mouseX, Input.mouseY));
				}
				
				//reset
				lostWindowFocus = false;
			}else {
				//left
				if(Input.check(Key.A) != a) {
					a = !a;
					list.push(new Command(isP1, Command.A, toSendFrame));
				}
				
				//right
				if(Input.check(Key.D) != d) {
					d = !d;
					list.push(new Command(isP1, Command.D, toSendFrame));
				}
				
				//up
				if(Input.check(Key.W) != w) {
					w = !w;
					list.push(new Command(isP1, Command.W, toSendFrame));
				}
				
				//down
				if(Input.check(Key.S) != s) {
					s = !s;
					list.push(new Command(isP1, Command.S, toSendFrame));
				}
				
				//mouse
				if (Input.mouseDown != mouse) {
					mouse = !mouse;
					list.push(new MouseCommand(isP1, MouseCommand.CLICK, toSendFrame, Input.mouseX, Input.mouseY));
				}
				
				//flick
				if (flick) {
					//flick started, determine stop
					if (flickGesture.check() == Gesture.SUCCESS) {
						flick = !flick;
						Utils.log("flick stop");
						list.push(new MouseCommand(isP1, MouseCommand.FLICK, toSendFrame, Input.mouseX, Input.mouseY));
						flickGesture.reset();
					}
				}else {
					//flick finished, determine start
					if (flickGesture.check() == Gesture.STARTED) {
						flick = !flick;
						Utils.log("flick start");
						list.push(new MouseCommand(isP1, MouseCommand.FLICK, toSendFrame, Input.mouseX, Input.mouseY));
					}
				}
			}
		}
	}
}