package moves {
	import worlds.GameWorld;
	
	public class Move {
		//variables
		protected var world:GameWorld = null;
		
		public function Move(world:GameWorld) {
			this.world = world;
		}
	}
}