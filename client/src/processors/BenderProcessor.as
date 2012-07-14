package processors {
	import net.flashpunk.Rollbackable;
	import net.flashpunk.rollback.GameWorld;
	import net.flashpunk.rollback.Command;
	import net.flashpunk.Destroyable;
	
	import general.CommandList;
	
	import moves.Move;
	import entities.Bender;
	
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
		
		//mouse positions
		protected var mouseX:Number;
		protected var mouseY:Number;
		
		//moves
		protected var currentMove:Move;
		
		//frame buffer
		protected var frameBuffer:int = 0;
		
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
			
			//mouse
			player.mouseX = mouseX;
			player.mouseY = mouseY;
			
			//decrement buffer
			if (frameBuffer > 0)
				frameBuffer--;
		}
		
		public function add(c:Command):void {
			//movement
			if (c.type == CommandList.A)
				a = !a;
			else if (c.type == CommandList.D)
				d = !d;
			else if (c.type == CommandList.W)
				w = !w;
			else if (c.type == CommandList.S)
				s = !s;
			
			//mouse
			mouseX = c.x;
			mouseY = c.y;
		}
		
		public function rollback(orig:Rollbackable):void {
			//cast
			var p:BenderProcessor = orig as BenderProcessor;
			
			//rollback
			a = p.a;
			s = p.s;
			d = p.d;
			w = p.w;
			mouseX = p.mouseX;
			mouseY = p.mouseY;
			canMove = p.canMove;
			frameBuffer = p.frameBuffer;
		}
		
		public function destroy():void {
			world = null;
			player = null;
			currentMove = null;
		}
	}
}