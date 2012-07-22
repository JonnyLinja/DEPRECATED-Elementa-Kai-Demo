package general {
	import flash.external.ExternalInterface;
	import flash.geom.Point
	
	import net.flashpunk.Entity;

	public class Utils {
		/**
		 * Collision did not occur
		 */
		public static const HIT_NONE:int = 0;
		
		/**
		 * Collided along the top side
		 */
		public static const HIT_TOP:int = 1;
		
		/**
		 * Collided along the bottom side
		 */
		public static const HIT_BOTTOM:int = 2;
		
		/**
		 * Collided along the left side
		 */
		public static const HIT_LEFT:int = 3;
		
		/**
		 * Collided along the right side
		 */
		public static const HIT_RIGHT:int = 4;
		
		/**
		 * Returns which side was hit
		 * Assumes that the two Entites DO ALREADY COLLIDE
		 * @param	e1
		 * @param	e2
		 * @param	e1Movable
		 * @param	e2Movable
		 * @param	intersect
		 * @return
		 */
		public static function hitTest(e1:Entity, e2:Entity, e1Movable:Boolean=false, e2Movable:Boolean=false, intersect:Point=null):int {
			if (!intersect)
				intersect = getIntersectRect(e1, e2);
			
			/*
			//ratio - may not need, might be able to fudge with 1-1 ratio
			//right now set to use bigger of the two
			//could set to use smaller no problem
			var ratioX:int;
			var ratioY:int;
			if (width * height > e.width * e.height) {
				ratioX = width;
				ratioY = height;
			}else {
				ratioX = e.width;
				ratioY = e.height;
			}
			*/
			
			var ratioX:int = 1;
			var ratioY:int = 1;
			
			//exclude
			var halfIntersect:Number;
			if (intersect.x / ratioY <= intersect.y / ratioX) {
				//horizontal
				if (e1.x < e2.x) {
					//left
					if (e1Movable && e2Movable) {
						halfIntersect = intersect.x * 0.5;
						e1.x -= halfIntersect;
						e2.x += halfIntersect;
					}else if (e1Movable)
						e1.x -= intersect.x
					else if (e2Movable)
						e2.x += intersect.x;
					return HIT_RIGHT;
				}else {
					//right
					if (e1Movable && e2Movable) {
						halfIntersect = intersect.x * 0.5;
						e1.x += halfIntersect;
						e2.x -= halfIntersect;
					}else if (e1Movable)
						e1.x += intersect.x
					else if (e2Movable)
						e2.x -= intersect.x;
					return HIT_LEFT;
				}
			}else {
				//vertical
				if (e1.y < e2.y) {
					//up
					if (e1Movable && e2Movable) {
						halfIntersect = intersect.y * 0.5;
						e1.y -= halfIntersect;
						e2.y += halfIntersect;
					}else if (e1Movable)
						e1.y -= intersect.y;
					else if (e2Movable)
						e2.y += intersect.y;
					return HIT_BOTTOM;
				}else {
					//down
					if (e1Movable && e2Movable) {
						halfIntersect = intersect.y * 0.5;
						e1.y += halfIntersect;
						e2.y -= halfIntersect;
					}else if (e1Movable)
						e1.y += intersect.y;
					else if (e2Movable)
						e2.y -= intersect.y;
					return HIT_TOP;
				}
			}
		}
		
		/**
		 * Returns point with the size of the intersecting collision rectangle
		 * @param	e
		 * @return
		 */
		public static function getIntersectRect(e1:Entity, e2:Entity):Point {
			//declare variables
			var intersectionWidth:Number = 0;
			var intersectionHeight:Number = 0;
			
			//horizontal
			if (e1.x < e2.x)
				intersectionWidth = Math.abs(e1.x + e1.width - e2.x);
			else if (e2.x != e1.x)
				intersectionWidth = Math.abs(e2.x + e2.width - e1.x);
			else
				intersectionWidth = Math.min(e1.width, e2.width);
			
			//vertical
			if (e1.y < e2.y)
				intersectionHeight = Math.abs(e1.y + e1.height - e2.y);
			else if (e2.y != e1.y)
				intersectionHeight = Math.abs(e2.y + e2.height - e1.y);
			else
				intersectionHeight = Math.min(e1.height, e2.height);
			
			//return point
			return new Point(intersectionWidth, intersectionHeight);
		}
		
		/**
		 * Sends message to JavaScript
		 * @param	data
		 */
		public static function log(data:String):void {
			try {
				ExternalInterface.call("log", data);
			}catch (e:*) {
				trace(data);
			}
		}
		
		/**
		 * Generic swap function
		 * @param	a
		 * @param	b
		 */
		public static function swap(a:Object, b:Object):void {
			var c:Object = a;
			a = b;
			b = c;
		}
		
		/**
		 * Negative version of the number
		 * @param	n
		 * @return
		 */
		public static function negative(n:Number):Number {
			if (n < 0)
				return n;
			return -n;
		}
		
		/**
		 * Distance formula
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return
		 */
		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt((dx * dx) + (dy * dy));
		}
		
		/**
		 * Determines if went from positive to negative or vice versa
		 * @param	n1
		 * @param	n2
		 * @return
		 */
		public static function didChangeSign(n1:Number, n2:Number):Boolean {
			if (n1 < 0 && n2 > 0)
				return true;
			if (n1 > 0 && n2 < 0)
				return true;
			return false;
		}
		
		/**
		 * Returns an int for an 8way direction. Follows the numpad on the keyboard
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return
		 */
		public static function direction(x1:Number, y1:Number, x2:Number, y2:Number):int {
			//declare variables
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			var rotation:int = rotation(dx, dy);
			
			//Utils.log("rotation is " + rotation);
			
			//return direction
			if(rotation >= 337 || rotation <= 23)
				return 4; //left
			if (rotation < 67)
				return 7; //top left
			if (rotation <= 113)
				return 8; //top
			if (rotation < 157)
				return 9; //top right
			if (rotation <= 203)
				return 6; //right
			if (rotation < 247)
				return 3; //bottom right
			if (rotation <= 293)
				return 2; //bottom
			if (rotation < 337)
				return 1; //bottom left
			
			//default
			return 0;
		}
		
		/**
		 * Returns the rotation angle in degrees
		 * Note that it is still using Flash points, so left/right and up/down are mixed up
		 * @param	dx
		 * @param	dy
		 * @return
		 */
		public static function rotation(dx:Number, dy:Number):Number {
			var result:Number = Math.atan2(dy, dx) * 180 / Math.PI;
			if (result < 0)
				result += 360
			return result;
		}
		
		public function Utils() {
			
		}
	}

}