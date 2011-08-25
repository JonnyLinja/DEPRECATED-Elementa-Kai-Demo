package processors {
	import flashpunk.Rollbackable;
	import gestures.Gesture;
	
	import entities.Bender;
	import worlds.GameWorld;
	
	import gestures.ClickHoldReleaseGesture;
	
	import moves.PrepareBoulderMove;
	import moves.CreateBoulderMove;
	
	public class EarthProcessor extends BenderProcessor {
		//gestures
		private var clickHoldReleaseGesture:ClickHoldReleaseGesture = new ClickHoldReleaseGesture;
		
		//moves
		private var prepareBoulderMove:PrepareBoulderMove;
		private var createBoulderMove:CreateBoulderMove;
		
		public function EarthProcessor(world:GameWorld, player:Bender) {
			super(world, player);
			prepareBoulderMove = new PrepareBoulderMove(world, player);
			createBoulderMove = new CreateBoulderMove(world, player);
		}
		
		override public function update():void {
			//super
			super.update();
			
			//update gestures
			clickHoldReleaseGesture.update(player.mouseX, player.mouseY, click, flick);
			
			//check gestures
			if (clickHoldReleaseGesture.check() == Gesture.STARTED) {
				//movement
				canMove = false;
				
				//create dust animation
				prepareBoulderMove.x = clickHoldReleaseGesture.x;
				prepareBoulderMove.y = clickHoldReleaseGesture.y;
				prepareBoulderMove.execute();
			}else if (clickHoldReleaseGesture.check() == Gesture.SUCCESS) {
				//kill dust
				prepareBoulderMove.finish();
				
				//create boulder
				createBoulderMove.x = clickHoldReleaseGesture.x;
				createBoulderMove.y = clickHoldReleaseGesture.y;
				createBoulderMove.execute();
				clickHoldReleaseGesture.reset();
			}else if (clickHoldReleaseGesture.check() == Gesture.FAIL) {
				//kill dust
				prepareBoulderMove.finish();
				
				//cancel
				if(!click)
					clickHoldReleaseGesture.reset();
			}
			
			//hack enable movement
			//will be different once more moves are there
			if(!click)
				canMove = true;
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var p:EarthProcessor = orig as EarthProcessor;
			
			//rollback
			clickHoldReleaseGesture.rollback(p.clickHoldReleaseGesture);
			prepareBoulderMove.rollback(p.prepareBoulderMove);
		}
	}
}