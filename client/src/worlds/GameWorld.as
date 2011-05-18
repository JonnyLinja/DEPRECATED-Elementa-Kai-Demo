package worlds {
	import commands.Command;
	import commands.CommandProcessor;
	import commands.EarthCommandProcessor;
	
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
		internal var player1:Bender;
		internal var player2:Bender;
		internal var processor1:CommandProcessor;
		internal var processor2:CommandProcessor;
		
		public function GameWorld() {
			player1 = new AirBender(200, 10);
			processor1 = new CommandProcessor(this, player1);
			player2 = new EarthBender(150, 10);
			processor2 = new EarthCommandProcessor(this, player2);
			add(player1);
			add(player2);
			add(new Wall( -FP.width, -FP.height, FP.width * 3, FP.height)); //top
			add(new Wall( -FP.width, FP.height, FP.width * 3, FP.height)); //bottom
			add(new Wall( -FP.width, -FP.height, FP.width, FP.height * 3)); //left
			add(new Wall( FP.width, -FP.height, FP.width, FP.height * 3)); //right
			updateLists();
		}
		
		public function executeCommand(c:Command):void {
			if (c.player)
				processor1.add(c);
			else
				processor2.add(c);
		}
		
		override public function update():void {
			super.update();
			
			updateLists();
		}
		
		public function executeCommandWithPoint(isP1:Boolean, command:int, x:Number, y:Number):void {
			
		}
		
		override public function end():void {
			player1 = null;
			player2 = null;
		}
	}
}