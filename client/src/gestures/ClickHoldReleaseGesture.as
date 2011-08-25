package gestures {
	import flashpunk.Rollbackable;
	
	public class ClickHoldReleaseGesture extends Gesture {
		//constants
		private static const MIN_FRAME_COUNT:int = 7;
		private static const LEEWAY:int = 5;
		
		//variables
		private var succeeded:Boolean = false;
		private var failed:Boolean = false;
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
		
		override public function update(x:Number, y:Number, mouse:Boolean, flick:Boolean, ratio:int = 1):void {
			//if need update -> reset required
			if (succeeded)
				return;
			
			if (!started) {
				//start
				if(mouse) {
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
				
				if (!mouse) {
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
			//not ready
			if (!started)
				return NOT_STARTED;
			
			//success
			if (succeeded)
				return SUCCESS;
			
			//fail
			if (failed)
				return FAIL;
			
			//default
			return STARTED;
		}
		
		override public function reset():void {
			//super
			super.reset();
			
			//reset
			failed = false;
			succeeded = false;
			frame_count = 0;
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var g:ClickHoldReleaseGesture = orig as ClickHoldReleaseGesture;
			
			//rollback
			failed = g.failed;
			succeeded = g.succeeded;
			frame_count = g.frame_count;
		}
	}
}