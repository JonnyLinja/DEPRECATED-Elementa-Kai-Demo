package moves {
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import entities.EarthBender;
	import entities.Dust;
	import worlds.GameWorld;
	
	public class PrepareBoulderMove extends Move {
		//variables
		public var x:Number;
		public var y:Number;
		private var dust:Dust;
		private var hasDust:Boolean = false;
		
		public function PrepareBoulderMove(world:GameWorld, player:Bender) {
			super(world, player);
			
			//create dust
			dust = world.create(Dust, true) as Dust;
			dust.visible = false;
		}
		
		override public function execute():void {
			if (!hasDust)
				hasDust = true;
			else
				return;
			
			//set position
			dust.visible = true;
			dust.x = x - dust.halfWidth;
			dust.y = y - dust.halfHeight;
			
			//animate bender
			player.play(EarthBender.CREATE_DUST_ANIMATION);
		}
		
		override public function finish():void {
			if(hasDust) {
				dust.visible = false;
				hasDust = false;
				player.play(Bender.WALK_ANIMATION);
			}
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			return;
			
			//cast
			var p:PrepareBoulderMove = orig as PrepareBoulderMove;
			
			/*
			//hack job, shouldn't need it
			if (hasDust != p.hasDust) {
				if (hasDust)
					world.remove(dust);
				else {
					dust = world.create(Dust, true) as Dust;
					dust.x = p.x - dust.halfWidth;
					dust.y = p.y - dust.halfHeight;
				}
			}
			*/
			
			//rollback
			hasDust = p.hasDust;
			x = p.x;
			y = p.y;
		}
	}
}