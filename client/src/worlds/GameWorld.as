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
		
		/**
		 * Constructor
		 * Instantiates variables
		 * @param	isP1
		 */
		public function GameWorld() {
			player1 = new AirBender(200, 0);
			player2 = new WaterBender(150, 0);
			add(player1);
			add(player2);
			add(new Wall( -FP.width, -FP.height, FP.width * 3, FP.height));
			add(new Wall( -FP.width, FP.height, FP.width * 3, FP.height));
			add(new Wall( -FP.width, -FP.height, FP.width, FP.height * 3));
			add(new Wall( FP.width, -FP.height, FP.width, FP.height * 3));
			updateLists();
		}
		
		/**
		 * Executes a command
		 * @param	command
		 */
		public function executeCommand(isP1:Boolean, command:int):void {
			if (command == Command.A) {
				if(isP1)
					player1.moveLeft = !player1.moveLeft;
				else
					player2.moveLeft = !player2.moveLeft;
			}else if (command == Command.D) {
				if(isP1)
					player1.moveRight = !player1.moveRight;
				else
					player2.moveRight = !player2.moveRight;
			}else if (command == Command.W) {
				if(isP1)
					player1.moveUp = !player1.moveUp;
				else
					player2.moveUp = !player2.moveUp;
			}else if (command == Command.S) {
				if(isP1)
					player1.moveDown = !player1.moveDown;
				else
					player2.moveDown = !player2.moveDown;
			}
		}
		
		/**
		 * Executes a command that also has point data
		 * @param	isP1
		 * @param	command
		 * @param	x
		 * @param	y
		 */
		public function executeCommandWithPoint(isP1:Boolean, command:int, x:Number, y:Number):void {
			
		}
		
		/**
		 * Destroys all entities
		 */
		override public function end():void {
			
		}
		
		override public function updateGameWorld():void {
			super.updateGameWorld();
			//Utils.log("Update true with elapsed " + FP.elapsed);
		}
	}
}