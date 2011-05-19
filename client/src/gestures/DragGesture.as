package gestures {
	import flash.geom.Point;
	
	public class DragGesture implements Gesture {
		private static const MIN:int = 100;
		private var startPoint:Point = null;
		
		public function DragGesture() {
		}
		
		public function check(p:Point, mouseToggle:Boolean = false):Boolean {
			//first time
			if (!startPoint) {
				startPoint = p;
				return false;
			}
			
			//met minimum distance
			if (Point.distance(startPoint, p) >= MIN) {
				startPoint = p;
				return true;
			}
			
			//default
			return false;
		}
	}
}