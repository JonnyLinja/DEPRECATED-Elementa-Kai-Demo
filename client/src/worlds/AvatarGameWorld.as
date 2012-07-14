package worlds {
	import net.flashpunk.Rollbackable;
	import net.flashpunk.rollback.GameWorld;
	import net.flashpunk.FP;
	import net.flashpunk.rollback.Command;
	
	import entities.Bender;
	import entities.EarthBender;
	import entities.Wall;
	
	import processors.BenderProcessor;
	
	import general.CommandList;
	
	import worlds.ScoreWorld;
	
	public class AvatarGameWorld extends GameWorld {
		//entities
		private var p1:Bender = new EarthBender(10, 10);
		private var p2:Bender = new EarthBender(400, 400);
		
		//processors - should combine with p1 and p2 entities
		private var processor1:BenderProcessor;
		private var processor2:BenderProcessor;
		
		public function AvatarGameWorld() {
			//super with frame rate 33
			super(33);
			
			processor1 = new BenderProcessor(this, p1);
			processor2 = new BenderProcessor(this, p2);
		}
		
		override public function begin():void {
			//super
			super.begin();
			
			//add entities
			add(p1);
			add(p2);
			add(new Wall( -FP.width, -FP.height, FP.width * 3, FP.height)); //top
			add(new Wall( -FP.width, FP.height, FP.width * 3, FP.height)); //bottom
			add(new Wall( -FP.width, -FP.height, FP.width, FP.height * 3)); //left
			add(new Wall( FP.width, -FP.height, FP.width, FP.height * 3)); //right
		}
		
		override public function executeCommand(c:Command):void {
			//super
			super.executeCommand(c);
			
			//send to appropriate processor
			if (c.player)
				processor1.add(c);
			else
				processor2.add(c);
		}
		
		override public function update():void {
			//update processors
			processor1.update();
			processor2.update();
			
			//super
			super.update();
			
			//determine end world - slightly hackish with isTrue check but is easiest way
			//problem is that playworld is mid execution when this is called
			//can cause problems that way hrmm
			//may want to do the callback method then
			if (isTrueWorld && (p1.hp == 0 || p2.hp == 0))
				FP.world = new ScoreWorld;
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//declare variables
			var g:AvatarGameWorld = orig as AvatarGameWorld;
			
			//rollback processors
			processor1.rollback(g.processor1);
			processor2.rollback(g.processor2);
		}
		
		override public function end():void {
			//super
			super.end();
			
			//processors
			processor1.destroy();
			processor2.destroy();
			processor1 = null;
			processor2 = null;
			
			//entities
			p1 = null;
			p2 = null;
		}
	}
}