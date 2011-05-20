package gestures {
	import flash.geom.Point;
	
	public interface Gesture {
		function check(p:Point, mouseDown:Boolean = false):Boolean;
		function reset():void;
	}
}