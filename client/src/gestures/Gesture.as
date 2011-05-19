package gestures {
	import flash.geom.Point;
	
	public interface Gesture {
		function check(p:Point, mouseToggle:Boolean=false):Boolean;
	}
}