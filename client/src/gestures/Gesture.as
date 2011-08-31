package gestures {
	import flashpunk.Rollbackable;
	
	public class Gesture implements Rollbackable {
		//constants
		public static const FAIL:int = -1;
		public static const NOT_STARTED:int = 0;
		public static const STARTED:int = 1;
		public static const SUCCESS:int = 2;
		
		//variables
		protected var startX:Number = 0;
		protected var startY:Number = 0;
		protected var started:Boolean = false;
		
		public function get x():Number {
			return startX;
		}
		
		public function get y():Number {
			return startY;
		}
		
		public function check():int {
			return NOT_STARTED;
		}
		
		public function reset():void {
			started = false;
		}
		
		public function rollback(orig:Rollbackable):void {
			//cast
			var g:Gesture = orig as Gesture;
			
			//rollback
			startX = g.startX;
			startY = g.startY;
			started = g.started;
		}
	}
}