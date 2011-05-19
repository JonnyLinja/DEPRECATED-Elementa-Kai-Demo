package gestures {
	import flash.geom.Point;
	import general.Utils;
	
	//USELESS
	//MIGHT REMOVE LATER
	//KEEPING FOR REFERENCE
	
	public class ChangeDirectionGesture implements Gesture {
		private var lastDirection:int = 0; //uses numpad where 7 is top left and 3 is bottom right
		private var lastPoint:Point = null;
		
		public function ChangeDirectionGesture() {
		}
		
		public function check(p:Point, mouseToggle:Boolean = false):Boolean {
			//first time
			if (!lastPoint) {
				lastPoint = p;
				return false;
			}
			
			//declare variables
			var direction:int = Utils.direction(lastPoint, p);
			
			//ignore 0s
			if (direction == 0)
				return false;
			if (lastDirection == 0) {
				Utils.log("0");
				lastDirection = direction;
				lastPoint = p;
				return false;
			}
			
			//check
			if (direction != lastDirection) {
				Utils.log(direction + " (" + p.x + "," + p.y + ")");
				lastDirection = direction;
				lastPoint = p;
				return true;
			}
			
			//default
			return false;
		}
	}
}