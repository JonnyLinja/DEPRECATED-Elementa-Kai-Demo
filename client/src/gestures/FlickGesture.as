package gestures {
	import general.Utils;
	
	public class FlickGesture extends Gesture {
		//constants
		private static const MIN_SPEED:int = 100;
		private static const MAX_SPEED:int = 50;
		
		//variables
		protected var flickStart:Boolean = false;
		protected var currentX:Number = 0;
		protected var currentY:Number = 0;
		protected var frames:int = 0;
		
		public function FlickGesture() {
			
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	mouse		ignores
		 * @param	flick		ignores
		 * @param	ratio
		 */
		override public function update(x:Number, y:Number, mouse:Boolean, flick:Boolean, ratio:int = 1):void {
			if (!started) {
				//first time
				startX = x;
				startY = y;
				started = true;
			}else {
				//next times
				startX = currentX;
				startY = currentY;
			}
			
			currentX = x;
			currentY = y;
			frames = ratio;
			
			//set flick start
			if (!flickStart && Utils.distance(startX, startY, currentX, currentY) / frames >= MIN_SPEED)
				flickStart = true;
		}
		
		override public function check():int {
			//not started
			if (!flickStart)
				return NOT_STARTED;
			
			//ended
			if (Utils.distance(startX, startY, currentX, currentY) / frames <= MAX_SPEED)
				return SUCCESS;
			
			//catch all
			return STARTED;
		}
		
		override public function reset():void {
			//super
			super.reset();
			
			//reset
			flickStart = false;
		}
	}
}