package processors {
	import flashpunk.Rollbackable;
	
	import commands.Command;
	import commands.MouseCommand;
	
	import moves.Move;
	import entities.Bender;
	import worlds.GameWorld;
	
	public class BenderProcessor implements Rollbackable {
		//worlds and entities
		protected var world:GameWorld = null;
		protected var player:Bender = null;
		
		//booleans
		protected var canMove:Boolean = true;
		protected var w:Boolean = false;
		protected var a:Boolean = false;
		protected var s:Boolean = false;
		protected var d:Boolean = false;
		protected var click:Boolean = false;
		protected var flick:Boolean = false;
		
		//moves
		protected var currentMove:Move;
		
		public function BenderProcessor(world:GameWorld, player:Bender) {
			this.world = world;
			this.player = player;
		}
		
		public function update():void {
			 if (canMove) {
				//enable movement
				player.moveLeft = a;
				player.moveRight = d;
				player.moveUp = w;
				player.moveDown = s;
			}else {
				//disable movement
				player.moveLeft = false;
				player.moveRight = false;
				player.moveUp = false;
				player.moveDown = false;
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
			
			if (c.type == MouseCommand.CLICK)
				click = !click;
			else if (c.type == MouseCommand.FLICK)
				flick = !flick;
		}
		
		public function rollback(orig:Rollbackable):void {
			//cast
			var p:BenderProcessor = orig as BenderProcessor;
			
			//rollback
			a = p.a;
			s = p.s;
			d = p.d;
			w = p.w;
			canMove = p.canMove;
			flick = p.flick;
			click = p.click;
		}
	}
}