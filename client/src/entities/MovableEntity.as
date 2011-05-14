package entities {
	import flash.geom.Point;
	
	import flashpunk.Entity;
	import flashpunk.FP;
	
	import general.Utils;
	
	import physics.ForceVector;
	import physics.WindForce;
	
	//MAY WANT TO MOVE THIS STUFF TO ENTITY ITSELF
	
	public class MovableEntity extends Entity {
		//constants
		public const hitNone:int = 0;
		public const hitTop:int = 1;
		public const hitBottom:int = 2;
		public const hitLeft:int = 3;
		public const hitRight:int = 4;
		
		//forces
		public var moveForce:ForceVector = new ForceVector();
		public var windForce:WindForce = new WindForce();
		
		//should
		public var shouldMoveX:Number;
		public var shouldMoveY:Number;
		
		public function MovableEntity(x:Number = 0, y:Number = 0) {
			//position
			this.x = x;
			this.y = y;
		}
		
		protected function resetShouldVariables():void {
			shouldMoveX = 0;
			shouldMoveY = 0;
		}
		
		protected function resolveShouldVariables():void {
			x += shouldMoveX;
			y += shouldMoveY;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			resetShouldVariables();
			checkClampOnScreen();
		}
		
		override public function update():void {
			super.update();
			resolveShouldVariables();
			
			//windforce
			windForce.applyDecel();
			x += windForce.x;
			y += windForce.y;
		}
		
		/**
		 * Moves colliding entities out of the way
		 * Assumes that entities did collide
		 * @param	e
		 * @param	ratioX
		 * @param	ratioY
		 * @param	selfMovable
		 * @param	eMovable
		 * @return
		 */
		protected function checkExcludeCollide(e:MovableEntity, ratioX:int, ratioY:int):int {
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
		protected function getIntersectRect(e:MovableEntity):Point {
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
		protected function hitHorizontal(intersect:Point, ratioX:int, ratioY:int):Boolean {
			return ((intersect.x / ratioY) <= (intersect.y / ratioX));
		}
		
		protected function checkOffScreenLeft(clamp:Boolean=true):Boolean {
			if (x < 0) {
				if(clamp)
					shouldMoveX -= x;
				return true;
			}
			return false;
		}
		
		protected function checkOffScreenRight(clamp:Boolean=true):Boolean {
			if (x + width > FP.width) {
				if(clamp)
					shouldMoveX -= (x + width - FP.width);
				return true;
			}
			return false;
		}
		
		protected function checkOffScreenTop(clamp:Boolean=true):Boolean {
			if (y < 0) {
				if(clamp)
					shouldMoveY -= y;
				return true;
			}
			return false;
		}
		
		protected function checkOffScreenBottom(clamp:Boolean=true):Boolean {
			if (y + height > FP.height) {
				if(clamp)
					shouldMoveY -= (y + height - FP.height);
				return true;
			}
			return false;
		}
		
		protected function checkClampOnScreen():void {
			checkOffScreenLeft();
			checkOffScreenRight();
			checkOffScreenTop();
			checkOffScreenBottom();
		}
		
		public function isMovingUp():Boolean {
			return (moveForce.y.velocity < 0);
		}
		
		public function isMovingDown():Boolean {
			return (moveForce.y.velocity > 0);
		}
		
		public function isMovingLeft():Boolean {
			return (moveForce.x.velocity < 0);
		}
		
		public function isMovingRight():Boolean {
			return (moveForce.x.velocity > 0);
		}
		
		override public function rollback(oldEntity:Entity):void {
			super.rollback(oldEntity);
			
			//declare
			var temp:MovableEntity = oldEntity as MovableEntity;
			
			//rollback forces
			moveForce.rollback(temp.moveForce);
		}
	}
}