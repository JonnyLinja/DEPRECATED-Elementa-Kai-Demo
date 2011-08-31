package processors {
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import entities.Boulder;
	import worlds.GameWorld;
	
	import gestures.Gesture;
	import gestures.receive.ClickHoldReleaseGesture;
	import gestures.receive.ClickFlickGesture;
	
	import moves.PrepareBoulderMove;
	import moves.CreateBoulderMove;
	import moves.ThrowBoulderMove;
	
	import general.Utils;
	
	public class EarthProcessor extends BenderProcessor {
		//booleans
		private var didClickBoulder:Boolean = false;
		
		//gestures
		private var clickHoldReleaseGesture:ClickHoldReleaseGesture = new ClickHoldReleaseGesture;
		private var clickFlickGesture:ClickFlickGesture = new ClickFlickGesture;
		
		//moves
		private var prepareBoulderMove:PrepareBoulderMove;
		private var createBoulderMove:CreateBoulderMove;
		private var throwBoulderMove:ThrowBoulderMove;
		
		public function EarthProcessor(world:GameWorld, player:Bender) {
			super(world, player);
			prepareBoulderMove = new PrepareBoulderMove(world, player);
			createBoulderMove = new CreateBoulderMove(world, player);
			throwBoulderMove = new ThrowBoulderMove(world, player);
		}
		
		override public function update():void {
			//determine clicked boulder
			if (justToggledMouse && click) {
				if (world.collidePoint(Boulder.COLLISION_TYPE_BOULDER_STILL, player.mouseX, player.mouseY) != null) {
					//Utils.log("just clicked on a stationary boulder!");
					didClickBoulder = true;
				}else
					didClickBoulder = false;
			}
			
			//check moves
			if (didClickBoulder)
				checkThrowBoulder();
			else {
				checkCreateBoulder();
			}
			
			//hack enable movement
			//will be different once more moves are there
			if(!canMove && frameBuffer == 0 && !click) {
				canMove = true;
				player.play("");
			}
			
			//super - hacked to be at end since it's easier
			super.update();
		}
		
		private function checkThrowBoulder():void {
			//test click flick
			clickFlickGesture.update(player.mouseX, player.mouseY, click, flick);
			
				//check success
				if (clickFlickGesture.check() == Gesture.SUCCESS) {
					//throw
					throwBoulderMove.execute(clickFlickGesture.x, clickFlickGesture.y, player.mouseX, player.mouseY);
					
					//reset
					clickFlickGesture.reset();
				}
			
			/*
			if (clickFlickGesture.check() == Gesture.STARTED) {
				//Utils.log("click flick start");
			}else if (clickFlickGesture.check() == Gesture.SUCCESS) {
				//Utils.log("click flick success");
				
				//throw
				throwBoulderMove.execute(clickFlickGesture.x, clickFlickGesture.y, player.mouseX, player.mouseY);
				
				clickFlickGesture.reset();
			}else if (clickFlickGesture.check() == Gesture.FAIL) {
				//Utils.log("click flick fail");
				clickFlickGesture.reset();
			}*/
		}
		
		private function checkCreateBoulder():void {
			//update click hold release gesture
			if (frameBuffer == 0) {
				clickHoldReleaseGesture.update(player.mouseX, player.mouseY, click, flick);
			
				//check gestures
				if (clickHoldReleaseGesture.check() == Gesture.STARTED) {
					//movement
					canMove = false;
					
					//create dust animation
					prepareBoulderMove.execute(clickHoldReleaseGesture.x, clickHoldReleaseGesture.y);
				}else if (clickHoldReleaseGesture.check() == Gesture.SUCCESS) {
					//kill dust
					prepareBoulderMove.finish();
					
					//create boulder
					createBoulderMove.execute(clickHoldReleaseGesture.x, clickHoldReleaseGesture.y);
					
					//set buffer
					frameBuffer += createBoulderMove.duration;
					
					//reset gesture
					clickHoldReleaseGesture.reset();
				}else if (clickHoldReleaseGesture.check() == Gesture.FAIL) {
					//kill dust
					prepareBoulderMove.finish();
					player.play("");
					
					//cancel
					if(!click)
						clickHoldReleaseGesture.reset();
				}
			}
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var p:EarthProcessor = orig as EarthProcessor;
			
			//rollback
			didClickBoulder = p.didClickBoulder;
			clickHoldReleaseGesture.rollback(p.clickHoldReleaseGesture);
			clickFlickGesture.rollback(p.clickFlickGesture);
			prepareBoulderMove.rollback(p.prepareBoulderMove);
		}
	}
}