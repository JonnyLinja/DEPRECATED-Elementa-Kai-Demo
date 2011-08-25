package moves {
	import entities.Bender;
	import entities.Boulder;
	
	import worlds.GameWorld;
	
	public class CreateBoulderMove extends Move {
		//variables
		public var x:Number;
		public var y:Number;
		
		public function CreateBoulderMove(world:GameWorld, player:Bender) {
			super(world, player);
		}
		
		override public function execute():void {
			//create boulder
			var boulder:Boulder = world.create(Boulder, true) as Boulder;
			boulder.x = x - boulder.halfWidth;
			boulder.y = y - boulder.halfHeight;
		}
	}
}