package moves {
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import worlds.GameWorld;
	
	public class Move implements Rollbackable {
		//variables
		protected var world:GameWorld = null;
		protected var player:Bender = null;
		
		public function Move(world:GameWorld, player:Bender) {
			this.world = world;
			this.player = player;
		}
		
		public function execute():void {
			
		}
		
		public function finish():void {
			
		}
		
		public function rollback(orig:Rollbackable):void {
			
		}
	}
}