package moves {
	import worlds.GameWorld;
	import entities.Boulder;
	
	public class CreateBoulderMove extends Move {
		//constants
		public static const startup:int = 7;
		public static const cooldown:int = 5;
		
		public function CreateBoulderMove(world:GameWorld) {
			super(world);
		}
		
		public function create(x:Number, y:Number):void {
			//create boulder
			var boulder:Boulder = world.create(Boulder, true) as Boulder;
			boulder.x = x - boulder.halfWidth;
			boulder.y = y - boulder.halfHeight;
		}
	}
}