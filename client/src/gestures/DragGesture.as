package gestures {
	import general.Utils;
	
	public class DragGesture extends Gesture {
		private static const MIN:int = 25;
		private var startX:Number = 0;
		private var startY:Number = 0;
		private var currentX:Number = 0;
		private var currentY:Number = 0;
		private var started:Boolean = false;
		
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
			if (Utils.distance(startX, startY, currentX, currentY) >= MIN)
				return SUCCESS;
			
			//failure
			return FAILURE;
		}
		
		override public function reset():void {
			started = false;
		}
	}
}