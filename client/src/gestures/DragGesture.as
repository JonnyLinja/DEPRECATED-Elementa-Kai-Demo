package gestures {
	import general.Utils;
	
	public class DragGesture extends Gesture {
		//constants
		private static const MIN_DISTANCE:int = 25;
		
		//variables
		protected var currentX:Number = 0;
		protected var currentY:Number = 0;
		
		public function DragGesture() {
		}
		
		override public function update(x:Number, y:Number, mouseDown:Boolean, ratio:int = 1):void {
			//first time
			if (!started) {
				startX = x;
				startY = y;
				started = true;
			}
			
			currentX = x;
			currentY = y;
		}
		
		override public function check():int {
			//not ready
			if (!started)
				return NOT_READY;
			
			//success
			if (Utils.distance(startX, startY, currentX, currentY) >= MIN_DISTANCE)
				return SUCCESS;
			
			//failure
			return FAILURE;
		}
	}
}