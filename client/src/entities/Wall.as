package entities {
	import flashpunk.RollbackableEntity;
	
	public class Wall extends RollbackableEntity {
		public static const COLLISION_TYPE:String = "wall";
		
		public function Wall(x:Number, y:Number, width:Number, height:Number) {
			super(x, y);
			
			this.width = width;
			this.height = height;
			
			type = Wall.COLLISION_TYPE;
		}
	}
}