package moves {
	import flashpunk.Rollbackable;
	
	import entities.Bender;
	import entities.EarthBender;
	import entities.Dust;
	import worlds.GameWorld;
	
	public class PrepareBoulderMove extends Move {
		//variables
		private var dust:Dust;
		private var hasDust:Boolean = false;
		
		public function PrepareBoulderMove(world:GameWorld, player:Bender) {
			super(world, player);
			
			//create dust
			dust = world.create(Dust, true) as Dust;
			dust.visible = false;
		}
		
		public function execute(x:Number, y:Number):void {
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
				//player.play(Bender.WALK_ANIMATION);
			}
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var p:PrepareBoulderMove = orig as PrepareBoulderMove;
			
			//rollback
			hasDust = p.hasDust;
		}
	}
}