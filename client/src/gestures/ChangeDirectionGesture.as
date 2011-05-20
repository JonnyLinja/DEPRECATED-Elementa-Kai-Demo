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
		
		public function check(p:Point, mouseDown:Boolean = false):Boolean {
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
				lastDirection = direction;
				lastPoint = p;
				return false;
			}
			
			//check
			if (!isAdjacent(direction, lastDirection)) {
				Utils.log(direction + " (" + p.x + "," + p.y + ")");
				lastDirection = direction;
				lastPoint = p;
				return true;
			}
			
			//default
			return false;
		}
		
		private function isAdjacent(n1:int, n2:int):Boolean {
			if (n1 == 7) {
				if (n2 == 4 || n2 == 7 || n2 == 8)
					return true;
			}else if (n1 == 8) {
				if (n2 == 7 || n2 == 8 || n2 == 9)
					return true;
			}else if (n1 == 9) {
				if (n2 == 8 || n2 == 9 || n2 == 6)
					return true;
			}else if (n1 == 6) {
				if (n2 == 9 || n2 == 6 || n2 == 3)
					return true;
			}else if (n1 == 3) {
				if (n2 == 6 || n2 == 3 || n2 == 2)
					return true;
			}else if (n1 == 2) {
				if (n2 == 3 || n2 == 2 || n2 == 1)
					return true;
			}else if (n1 == 1) {
				if (n2 == 2 || n2 == 1 || n2 == 4)
					return true;
			}else if (n1 == 4) {
				if (n2 == 1 || n2 == 4 || n2 == 7)
					return true;
			}
			
			//default
			return false;
		}
		
		public function reset():void {
			
		}
	}
}