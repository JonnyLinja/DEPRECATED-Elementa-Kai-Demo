package gestures {
	public class Gesture {
		public static const NOT_READY:int = 0;
		public static const SUCCESS:int = 1;
		public static const FAILURE:int = -1;
		
		public function update(x:Number, y:Number, mouseDown:Boolean, ratio:int = 1):void {
			
		}
		
		public function check():int {
			return NOT_READY;
		}
		
		public function reset():void {
			
		}
	}
}