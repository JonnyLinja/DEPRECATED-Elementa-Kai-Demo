package worlds {
	
	//consider making the fps 20!
	
	import commands.Command;
	
	import processors.BenderProcessor;
	import processors.AirProcessor;
	import processors.EarthProcessor;
	
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import entities.AirBender;
	import entities.EarthBender;
	import entities.FireBender;
	import entities.Wall;
	import entities.WaterBender;
	
	import flashpunk.RollbackableWorld;
	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	//temporary
	import flashpunk.FP;
	import general.Utils;
	
	public class GameWorld extends RollbackableWorld {
		//frame constants
		public static const FRAME_RATE:uint = 33; //~30 fps
		public static const FRAME_ELAPSED:Number = FRAME_RATE / 1000;
		
		//players
		private var player1:Bender;
		private var player2:Bender;
		
		//commands
		private var processor1:BenderProcessor;
		private var processor2:BenderProcessor;
		
		public function GameWorld() {
			FP.screen.color = 0x000000;
			player1 = new AirBender(200, 10);
			processor1 = new AirProcessor(this, player1);
			player2 = new EarthBender(150, 10);
			processor2 = new EarthProcessor(this, player2);
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
			processor1.update();
			processor2.update();
			updateLists();
			super.update();
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//declare variables
			var g:GameWorld = orig as GameWorld;
			
			//rollback processors
			processor1.rollback(g.processor1);
			processor2.rollback(g.processor2);
		}
		
		override public function end():void {
			player1 = null;
			player2 = null;
		}
	}
}