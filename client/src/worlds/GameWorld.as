package worlds {
	import commands.Command;
	import entities.Bender;
	import entities.AirBender;
	import entities.EarthBender;
	import entities.FireBender;
	import entities.Wall;
	import entities.WaterBender;
	import entities.Boulder;
	
	import flashpunk.World;
	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	//temporary
	import flashpunk.FP;
	import general.Utils;
	
	public class GameWorld extends World {
		private var player1:Bender;
		private var player2:Bender;
		
		public function GameWorld() {
			player1 = new AirBender(200, 10);
			player2 = new EarthBender(150, 10);
			add(player1);
			add(player2);
			add(new Wall( -FP.width, -FP.height, FP.width * 3, FP.height)); //top
			add(new Wall( -FP.width, FP.height, FP.width * 3, FP.height)); //bottom
			add(new Wall( -FP.width, -FP.height, FP.width, FP.height * 3)); //left
			add(new Wall( FP.width, -FP.height, FP.width, FP.height * 3)); //right
			updateLists();
		}
		
		public function executeCommand(command:Command):void {
			if (command.type == Command.A) {
				//left
				if(command.player)
					player1.moveLeft = !player1.moveLeft;
				else
					player2.moveLeft = !player2.moveLeft;
			}else if (command.type == Command.D) {
				//right
				if(command.player)
					player1.moveRight = !player1.moveRight;
				else
					player2.moveRight = !player2.moveRight;
			}else if (command.type == Command.W) {
				//up
				if(command.player)
					player1.moveUp = !player1.moveUp;
				else
					player2.moveUp = !player2.moveUp;
			}else if (command.type == Command.S) {
				//down
				if(command.player)
					player1.moveDown = !player1.moveDown;
				else
					player2.moveDown = !player2.moveDown;
			}else if (command.type == Command.MOUSE_TOGGLE) {
				//create boulder
				//temporary, everyone can do it on both mouse down AND up
				var boulder:Boulder = create(Boulder, true) as Boulder;
				boulder.x = command.x - boulder.halfWidth;
				boulder.y = command.y - boulder.halfHeight;
			}
		}
		
		override public function update():void {
			super.update();
			
			updateLists();
		}
		
		public function executeCommandWithPoint(isP1:Boolean, command:int, x:Number, y:Number):void {
			
		}
		
		override public function end():void {
			
		}
	}
}