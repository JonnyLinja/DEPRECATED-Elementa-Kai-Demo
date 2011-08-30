package moves {
	import entities.Boulder;
	import worlds.GameWorld;
	import entities.Bender;
	
	import general.Utils;
	
	public class ThrowBoulderMove extends Move {
		public function ThrowBoulderMove(world:GameWorld, player:Bender) {
			super(world, player);
		}
		
		override public function get duration():int {
			return 0;
		}
		
		public function execute(startX:Number, startY:Number, finalX:Number, finalY:Number):void {
			//select boulder - repeated since can't pass by reference from processor
			var boulder:Boulder = world.collidePoint(Boulder.COLLISION_TYPE_BOULDER_STILL, startX, startY) as Boulder;
			
			if (!boulder) {
				//this shouldn't happen, but it does
				//means throw is being called too many times from the processor due to rollback
				//not sure why as in theory it shouldn't happen
				
				//Utils.log("error: unable to find boulder");
				return;
			}
			
			//throw to final x and final y
			boulder.throwBoulder(finalX, finalY);
		}
	}
}