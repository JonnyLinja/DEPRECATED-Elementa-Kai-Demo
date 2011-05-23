package commands {
	import flashpunk.Rollbackable;
	
	import worlds.GameWorld;
	
	import entities.Bender;
	import entities.Boulder;
	
	public class EarthCommandProcessor extends CommandProcessor implements Rollbackable {
		
		public function EarthCommandProcessor(world:GameWorld, player:Bender) {
			super(world, player);
		}
		
		override protected function handleMouseCommand(c:Command):void {
			super.handleMouseCommand(c);
			
		}
		
		protected function createBoulder(x:Number, y:Number):void {
			//create boulder
			var boulder:Boulder = world.create(Boulder, true) as Boulder;
			boulder.x = x - boulder.halfWidth;
			boulder.y = y - boulder.halfHeight;
		}
		
		override public function rollback(orig:Rollbackable):void {
			super.rollback(orig);
			
			//cast
			var ep:EarthCommandProcessor = orig as EarthCommandProcessor;
		}
	}
}