package gestures {
	import commands.Command;
	
	public class GestureProcessor {
		//booleans
		protected var isP1:Boolean = false;
		
		//command
		protected var currentCommand:Command = null;
		
		public function GestureProcessor(isP1:Boolean) {
			this.isP1 = isP1;
		}
		
		public function update(frame:uint, x:Number, y:Number, mouseDown:Boolean, ratio:int = 1):void {
			
		}
		
		public function check():Command {
			return currentCommand;
		}
	}
}