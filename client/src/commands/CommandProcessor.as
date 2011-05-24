package commands {
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import worlds.GameWorld;
	import moves.Move;
	
	public class CommandProcessor implements Rollbackable {
		//worlds and entities
		protected var world:GameWorld = null;
		protected var player:Bender = null;
		
		//startups and cooldowns
		protected var startup:int = 0;
		protected var cooldown:int = 0;
		
		//buffer
		protected var bufferedMove:Move = null; //not sure if should do it this way...
		
		//booleans
		protected var canMove:Boolean = true;
		protected var w:Boolean = false;
		protected var a:Boolean = false;
		protected var s:Boolean = false;
		protected var d:Boolean = false;
		
		public function CommandProcessor(world:GameWorld, player:Bender) {
			this.world = world;
			this.player = player;
		}
		
		public function update():void {
			//default prevent movement
			player.moveLeft = false;
			player.moveRight = false;
			player.moveUp = false;
			player.moveDown = false;
			
			//startup, cooldowns, movement
			if (startup > 0) {
				startup--;
			}else if (cooldown > 0) {
				cooldown--;
			}else if (canMove) {
				//enable movement
				player.moveLeft = a;
				player.moveRight = d;
				player.moveUp = w;
				player.moveDown = s;
			}
		}
		
		public function add(c:Command):void {
			//movement
			if (c.type == Command.A)
				a = !a;
			else if (c.type == Command.D)
				d = !d;
			else if (c.type == Command.W)
				w = !w;
			else if (c.type == Command.S)
				s = !s;
			//mouse
			else if (c is MouseCommand)
				handleMouseCommand(c as MouseCommand);
		}
		
		protected function handleMouseCommand(c:MouseCommand):void {
			player.mouseX = c.x;
			player.mouseY = c.y;
		}
		
		public function rollback(orig:Rollbackable):void {
			//cast
			var c:CommandProcessor = orig as CommandProcessor;
			
			//rollback
			startup = c.startup;
			cooldown = c.cooldown;
			a = c.a;
			s = c.s;
			d = c.d;
			w = c.w;
			canMove = c.canMove;
		}
	}
}