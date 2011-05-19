package commands {
	import entities.Bender;
	import flash.geom.Point;
	import worlds.GameWorld;
	
	public class CommandProcessor {
		protected var world:GameWorld = null;
		protected var player:Bender = null;
		protected var mouseDown:Boolean = false;
		protected var justToggled:Boolean;
		
		public function CommandProcessor(world:GameWorld, player:Bender) {
			this.world = world;
			this.player = player;
		}
		
		public function add(c:Command):void {
			//reset
			justToggled = false;
			
			//movement
			if (c.type == Command.A)
				player.moveLeft = !player.moveLeft;
			else if (c.type == Command.D)
				player.moveRight = !player.moveRight;
			else if (c.type == Command.W)
				player.moveUp = !player.moveUp;
			else if (c.type == Command.S)
				player.moveDown = !player.moveDown;
			else {
				//mouse
				if (c.type == Command.MOUSE_TOGGLE) {
					justToggled = true;
					mouseDown = !mouseDown;
				}
				player.mouse.x = c.x;
				player.mouse.y = c.y;
			}
		}
		
		public function rollback(p:CommandProcessor):void {
			mouseDown = p.mouseDown;
		}
	}
}