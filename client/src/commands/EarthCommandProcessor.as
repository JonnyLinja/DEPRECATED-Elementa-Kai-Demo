package commands {
	import worlds.GameWorld;
	import entities.Bender;
	import entities.Boulder;
	
	public class EarthCommandProcessor extends CommandProcessor {
		//private static const createMinDistance:Number = 300;
		//private var didChangeVertical:Boolean = false;
		//private var verticalDistance1:Number = 0;
		//private var verticalDistance2:Number = 0;
		
		public function EarthCommandProcessor(world:GameWorld, player:Bender) {
			super(world, player);
		}
		
		override public function add(c:Command):void {
			super.add(c);
			
			if (justToggled && mouseDown)
				createBoulder(c.x, c.y);
			
			/*
			if (mouseDown) {
				if (list.length > 0) {
					//did change direction
					if (!didChangeVertical && Utils.didChangeSign(list[length - 1].y, c.y))
						didChangeVertical = true;
					
					var newDist:Number = Math.abs(list[length - 1].y - c.y);
					
					//increase distance
					if (!didChangeVertical)
						verticalDistance1 += newDist;
					else
						verticalDistance2 += newDist;
					
					Utils.log("new dist is " + newDist);
				}
				
				//push command
				list.push(c);
			}else if (justToggled) {
				//just released
				
				Utils.log("vert distances are " + verticalDistance1 + " and " + verticalDistance2);
				
				if (didChangeVertical && Math.min(verticalDistance1, verticalDistance2) >= createMinDistance)
					createBoulder(c.x, c.y);
				
				//reset
				didChangeVertical = false;
				verticalDistance1 = 0;
				verticalDistance2 = 0;
			}
			*/
		}
		
		protected function createBoulder(x:Number, y:Number):void {
			//create boulder
			var boulder:Boulder = world.create(Boulder, true) as Boulder;
			boulder.x = x - boulder.halfWidth;
			boulder.y = y - boulder.halfHeight;
		}
	}
}