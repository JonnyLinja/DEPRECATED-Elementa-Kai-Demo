package entities {
	import flash.geom.Point;
	import flashpunk.Entity;
	import physics.ForceVector;
	import physics.WindForceVector;
	
	public class MovableEntity extends Entity {
		//constants
		public const hitNone:int = 0;
		public const hitTop:int = 1;
		public const hitBottom:int = 2;
		public const hitLeft:int = 3;
		public const hitRight:int = 4;
		
		//forces
		public var moveForce:ForceVector = new ForceVector();
		public var windForce:WindForceVector = new WindForceVector();
		
		//to move
		public var shouldMoveX:Number;
		public var shouldMoveY:Number;
		
		public function MovableEntity(x:Number=0, y:Number=0) {
			this.x = x;
			this.y = y;
		}
		
		private function resetShouldMove():void {
			shouldMoveX = 0;
			shouldMoveY = 0;
		}
		
		override public function preUpdate():void {
			resetShouldMove();
			super.preUpdate();
		}
		
		/**
		 * Moves colliding entities out of the way
		 * Assumes that entities do collide
		 * @param	e
		 * @param	ratioX
		 * @param	ratioY
		 * @param	selfMovable
		 * @param	eMovable
		 * @return
		 */
		public function excludeCollide(e:MovableEntity, ratioX:int, ratioY:int):int {
			//declare variables
			var intersect:Point = getIntersectRect(e);
			
			//exclude
			if (hitHorizontal(intersect, ratioX, ratioY)) {
				//horizontal
				if (x < e.x) {
					//left
					shouldMoveX -= intersect.x;
					return hitRight;
				}else {
					//right
					shouldMoveX += intersect.x;
					return hitLeft;
				}
			}else {
				//vertical
				if (y < e.y) {
					//up
					shouldMoveY -= intersect.y;
					return hitBottom;
				}else {
					//down
					shouldMoveY += intersect.y;
					return hitTop;
				}
			}
		}
		
		/**
		 * Returns point with the size of the intersecting collision rectangle
		 * @param	e
		 * @return
		 */
		public function getIntersectRect(e:MovableEntity):Point {
			//declare variables
			var intersectionWidth:Number = 0;
			var intersectionHeight:Number = 0;
			
			//horizontal
			if (x < e.x)
				intersectionWidth = Math.abs(x + width - e.x);
			else if (e.x != x)
				intersectionWidth = Math.abs(e.x + e.width - x);
			
			//vertical
			if (y < e.y)
				intersectionHeight = Math.abs(y + height - e.y);
			else if (e.y != y)
				intersectionHeight = Math.abs(e.y + e.height - y);
			
			//return point
			return new Point(intersectionWidth, intersectionHeight);
		}
		
		/**
		 * If collision is favored towards the horizontal axes
		 * @param	intersect
		 * @param	ratioX
		 * @param	ratioY
		 * @return
		 */
		public function hitHorizontal(intersect:Point, ratioX:int, ratioY:int):Boolean {
			return ((intersect.x / ratioY) <= (intersect.y / ratioX));
		}
	}
}