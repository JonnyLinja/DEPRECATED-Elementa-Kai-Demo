package commands {
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import worlds.GameWorld;
	
	public class CommandProcessor implements Rollbackable {
		protected var world:GameWorld = null;
		protected var player:Bender = null;
		protected var mouseDown:Boolean = false;
		protected var justToggled:Boolean;
		
		public function CommandProcessor(world:GameWorld, player:Bender) {
			this.world = world;
			this.player = player;
		}
		
		public function add(c:Command):void {
			//movement commands
			if (c.type == Command.A)
				player.moveLeft = !player.moveLeft;
			else if (c.type == Command.D)
				player.moveRight = !player.moveRight;
			else if (c.type == Command.W)
				player.moveUp = !player.moveUp;
			else if (c.type == Command.S)
				player.moveDown = !player.moveDown;
			else
				handleMouseCommand(c);
		}
		
		protected function handleMouseCommand(c:Command):void {
			/*
			if (c.type == Command.MOUSE_TOGGLE) {
				justToggled = true;
				mouseDown = !mouseDown;
			}else
				justToggled = false;
			*/
			player.mouseX = c.x;
			player.mouseY = c.y;
		}
		
		public function rollback(orig:Rollbackable):void {
			//cast
			var p:CommandProcessor = orig as CommandProcessor;
			
			mouseDown = p.mouseDown;
		}
	}
}