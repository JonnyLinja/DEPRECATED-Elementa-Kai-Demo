package commands {
	import flash.geom.Point;
	import gestures.ClickDragDragVerticalGesture;
	import worlds.GameWorld;
	import entities.Bender;
	import entities.Boulder;
	
	public class EarthCommandProcessor extends CommandProcessor {
		private var createBoulderGesture:ClickDragDragVerticalGesture = new ClickDragDragVerticalGesture;
		
		public function EarthCommandProcessor(world:GameWorld, player:Bender) {
			super(world, player);
		}
		
		override protected function handleMouseCommand(c:Command):void {
			super.handleMouseCommand(c);
			
			//should determine if click on boulder first
			//then should determine if it was OK or not
			if(createBoulderGesture.check(new Point(c.x, c.y), mouseDown)) {
				createBoulder(createBoulderGesture.startPoint.x, createBoulderGesture.startPoint.y);
				createBoulderGesture.reset();
			}
		}
		
		protected function createBoulder(x:Number, y:Number):void {
			//create boulder
			var boulder:Boulder = world.create(Boulder, true) as Boulder;
			boulder.x = x - boulder.halfWidth;
			boulder.y = y - boulder.halfHeight;
		}
		
		override public function rollback(p:CommandProcessor):void {
			super.rollback(p);
			
			//cast
			var ep:EarthCommandProcessor = p as EarthCommandProcessor;
			
			//rollback gestures
			createBoulderGesture.rollback(ep.createBoulderGesture);
		}
	}
}