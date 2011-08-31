package gestures.send {
	import general.Utils;
	
	import gestures.Gesture;
	
	public class DragGesture extends Gesture implements SendGesture {
		//constants
		private static const MIN_DISTANCE:int = 25;
		
		//variables
		protected var currentX:Number = 0;
		protected var currentY:Number = 0;
		
		public function DragGesture() {
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	mouse		ignores
		 * @param	ratio
		 */
		public function update(x:Number, y:Number, mouse:Boolean, ratio:int = 1):void {
			//first time
			if (!started) {
				startX = x;
				startY = y;
				started = true;
				
				currentX = x;
				currentY = y;
			}else {
				currentX = x;
				currentY = y;
			}
		}
		
		override public function check():int {
			//not ready
			if (!started)
				return NOT_STARTED;
			
			//success
			if (Utils.distance(startX, startY, currentX, currentY) >= MIN_DISTANCE)
				return SUCCESS;
			
			//failure
			return FAIL;
		}
	}
}