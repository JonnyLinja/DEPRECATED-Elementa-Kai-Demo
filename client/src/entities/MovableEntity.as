package entities {
	import flashpunk.Entity;
	import physics.ForceVector;
	import physics.WindForceVector;
	
	public class MovableEntity extends Entity {
		public var moveForce:ForceVector = new ForceVector();
		public var windForce:WindForceVector = new WindForceVector();
		
		public function MovableEntity(x:Number=0, y:Number=0) {
			this.x = x;
			this.y = y;
		}
	}
}