package commands {
	import flashpunk.Rollbackable;
	
	import worlds.GameWorld;
	import entities.Bender;
	import moves.CreateBoulderMove;
	
	//needs to accomodate startups and cooldowns
	//needs to accomodate buffering of commands
	
	public class EarthCommandProcessor extends CommandProcessor {
		//frames
		private var beginFrame:int = 0;
		
		//moves
		private var boulder:CreateBoulderMove;
		
		public function EarthCommandProcessor(world:GameWorld, player:Bender) {
			//super
			super(world, player);
			
			//instantiate moves
			boulder = new CreateBoulderMove(world);
		}
		
		override protected function handleMouseCommand(c:MouseCommand):void {
			//super
			super.handleMouseCommand(c);
			
			if (c.type == MouseCommand.BEGIN) {
				canMove = false;
				beginFrame = c.frame;
				
				//temporary, won't work with buffers
				startup = 0;
				cooldown = 0;
			}else if (c.type == MouseCommand.CANCEL) {
				canMove = true;
			}else if (c.type == MouseCommand.CLICK_HOLD_RELEASE) {
				canMove = true;
				
				//create
				boulder.create(c.x, c.y);
				
				//cooldowns and startups
				startup = CreateBoulderMove.startup - (c.frame - beginFrame);
				cooldown = CreateBoulderMove.cooldown;
			}
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var p:EarthCommandProcessor = orig as EarthCommandProcessor;
			
			//rollback
			beginFrame = p.beginFrame;
		}
	}
}