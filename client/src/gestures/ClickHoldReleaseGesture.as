package gestures {
	public class ClickHoldReleaseGesture extends Gesture {
		//constants
		private static const MIN_FRAME_COUNT:int = 7;
		private static const LEEWAY:int = 5;
		
		//variables
		private var failed:Boolean = false;
		private var succeeded:Boolean = false;
		private var frame_count:int = 0;
		
		public function ClickHoldReleaseGesture() {
			
		}
		
		private function didMove(x:Number, y:Number):Boolean {
			//x
			if (x < startX) {
				//left
				if (x + LEEWAY < startX)
					return true;
			}else if (x > startX) {
				//right
				if (x - LEEWAY > startX)
					return true;
			}
			
			//y
			if (y < startY) {
				//up
				if (y + LEEWAY < startY)
					return true;
			}else if (y > startY) {
				//down
				if (y - LEEWAY > startY)
					return true;
			}
			
			//default
			return false;
		}
		
		override public function update(x:Number, y:Number, mouseDown:Boolean, ratio:int = 1):void {
			//if need update -> reset required
			if (failed || succeeded)
				return;
			
			if (!started) {
				//start
				if(mouseDown) {
					startX = x;
					startY = y;
					started = true;
				}
			}else {
				//move check
				if (didMove(x, y)) {
					failed = true;
					return;
				}
				
				if (!mouseDown) {
					//finish
					
					//frame count check
					if (frame_count < MIN_FRAME_COUNT)
						failed = true;
					else
						succeeded = true;
				}else {
					//keep checking
					
					//increment frame count
					frame_count += ratio;
				}
			}
		}
		
		override public function check():int {
			//success
			if (succeeded)
				return SUCCESS;
			
			//failure
			if (failed)
				return FAILURE;
			
			//default
			return NOT_READY;
		}
		
		override public function reset():void {
			//super
			super.reset();
			
			//reset
			succeeded = false;
			failed = false;
			frame_count = 0;
		}
	}
}