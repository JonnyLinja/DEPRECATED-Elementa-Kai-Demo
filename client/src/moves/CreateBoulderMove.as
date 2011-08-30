package moves {
	import entities.Bender;
	import entities.Boulder;
	import entities.EarthBender;
	
	import worlds.GameWorld;
	
	public class CreateBoulderMove extends Move {
		public function CreateBoulderMove(world:GameWorld, player:Bender) {
			super(world, player);
		}
		
		override public function get duration():int {
			return 20;
		}
		
		public function execute(x:Number, y:Number):void {
			//create boulder
			var boulder:Boulder = world.create(Boulder, true) as Boulder;
			boulder.x = x - boulder.halfWidth;
			boulder.y = y - boulder.halfHeight;
			
			//animation
			player.play(EarthBender.CREATE_BOULDER_ANIMATION);
		}
	}
}