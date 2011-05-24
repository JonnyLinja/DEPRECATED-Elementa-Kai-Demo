package commands {
	import worlds.GameWorld;
	import entities.Bender;
	
	public class AirCommandProcessor extends CommandProcessor {
		public function AirCommandProcessor(world:GameWorld, player:Bender) {
			super(world, player);
		}
	}
}