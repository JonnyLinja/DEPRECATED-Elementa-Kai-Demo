package processors {
	import entities.Bender;
	import worlds.GameWorld;
	
	public class AirProcessor extends BenderProcessor {
		public function AirProcessor(world:GameWorld, player:Bender) {
			super(world, player);
		}
	}
}