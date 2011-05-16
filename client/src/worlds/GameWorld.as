package worlds {
	import commands.Command;
	import entities.Bender;
	import entities.AirBender;
	import entities.EarthBender;
	import entities.FireBender;
	import entities.Wall;
	import entities.WaterBender;
	
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
			player2 = new WaterBender(150, 10);
			add(player1);
			add(player2);
			add(new Wall( -FP.width, -FP.height, FP.width * 3, FP.height)); //top
			add(new Wall( -FP.width, FP.height, FP.width * 3, FP.height)); //bottom
			add(new Wall( -FP.width, -FP.height, FP.width, FP.height * 3)); //left
			add(new Wall( FP.width, -FP.height, FP.width, FP.height * 3)); //right
			updateLists();
		}
		
		public function executeCommand(isP1:Boolean, command:int):void {
			if (command == Command.A) {
				//left
				if(isP1)
					player1.moveLeft = !player1.moveLeft;
				else
					player2.moveLeft = !player2.moveLeft;
			}else if (command == Command.D) {
				//right
				if(isP1)
					player1.moveRight = !player1.moveRight;
				else
					player2.moveRight = !player2.moveRight;
			}else if (command == Command.W) {
				//up
				if(isP1)
					player1.moveUp = !player1.moveUp;
				else
					player2.moveUp = !player2.moveUp;
			}else if (command == Command.S) {
				//down
				if(isP1)
					player1.moveDown = !player1.moveDown;
				else
					player2.moveDown = !player2.moveDown;
			}
		}
		
		public function executeCommandWithPoint(isP1:Boolean, command:int, x:Number, y:Number):void {
			
		}
		
		override public function end():void {
			
		}
	}
}