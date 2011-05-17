package entities {
	import flashpunk.Entity;
	
	import physics.ForceVector;
	import physics.WindForce;
	
	import general.Utils;
	
	public class MovableEntity extends Entity {		
		//forces
		public var moveForce:ForceVector = new ForceVector();
		public var windForce:WindForce = new WindForce();
		
		public function MovableEntity(x:Number = 0, y:Number = 0) {
			//position
			this.x = x;
			this.y = y;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
			//wall
			checkCollide(Wall.COLLISION_TYPE, didCollideWithWall, true);
		}
		
		protected function didCollideWithWall(e:Wall, hitTest:int):void {
			Utils.log("hittest: " + hitTest);
		}
		
		override public function update():void {
			super.update();
			
			//windforce
			windForce.applyDecel();
			x += windForce.x;
			y += windForce.y;
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