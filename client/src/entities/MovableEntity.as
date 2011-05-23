package entities {
	import flash.geom.Point;
	import flashpunk.Rollbackable;
	
	import flashpunk.Entity;
	import flashpunk.FP;
	
	import physics.ForceVector;
	import physics.WindForce;
	
	import general.Utils;
	
	public class MovableEntity extends Entity {		
		//forces
		public var moveForce:ForceVector = new ForceVector();
		public var windForce:WindForce = new WindForce();
		
		//overlap
		protected var preventWallOverlap:Boolean = true;
		
		public function MovableEntity(x:Number = 0, y:Number = 0) {
			//position
			this.x = x;
			this.y = y;
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
		
		public function isOffScreenHorizontal():Boolean {
			if (x < 0)
				return true;
			if (x + width > FP.width)
				return true;
			return false;
		}
		
		public function isOffScreenVertical():Boolean {
			if (y < 0)
				return true;
			if (y + height > FP.height)
				return true;
			return false;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
			//wall
			checkCollide(Wall.COLLISION_TYPE, preventWallOverlap, didCollideWithWall);
		}
		
		protected function didCollideWithWall(e:Entity, hitTestResult:int, intersectSize:Point):void {
		}
		
		override public function update():void {
			super.update();
			
			//windforce
			windForce.applyDecel();
			x += windForce.x;
			y += windForce.y;
		}
		
		override public function rollback(orig:Rollbackable):void {
			super.rollback(orig);
			
			//declare
			var e:MovableEntity = orig as MovableEntity;
			
			//rollback forces
			moveForce.rollback(e.moveForce);
		}
	}
}