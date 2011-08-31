package gestures.receive {
	import flashpunk.Rollbackable;
	
	import gestures.Gesture;
	
	public class ClickFlickGesture extends Gesture implements ReceiveGesture {
		//minimum distance check? not sure
		
		//mouse
		private var flick:Boolean = false;
		private var success:Boolean = false;
		private var fail:Boolean = false;
		
		public function ClickFlickGesture() {
			
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	mouse		uses
		 * @param	flick		uses
		 * @param	ratio
		 */
		public function update(x:Number, y:Number, mouse:Boolean, flick:Boolean, ratio:int = 1):void {
			if (!started) {
				if (mouse) {
					this.flick = flick;
					started = true;
					startX = x;
					startY = y;
				}
			}else {
				if (this.flick != flick) {
					//finish check
					/*
					if (!mouse)
						success = true;
					else
						fail = true;
					*/
					success = true;
				}
			}
		}
		
		override public function check():int {
			//not started
			if (!STARTED)
				return NOT_STARTED;
			
			//ended
			if (success)
				return SUCCESS;
			else if (fail)
				return FAIL;
			
			//catch all
			return STARTED;
		}
		
		override public function reset():void {
			//super
			super.reset();
			
			//reset
			flick = false;
			success = false;
			fail = false;
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var f:ClickFlickGesture = orig as ClickFlickGesture;
			
			//rollback
			flick = f.flick;
			success = f.success;
			fail = f.fail;
		}
	}
}