package entities {
	import flashpunk.Entity;
	
	public class Wall extends Entity {
		public static const collisionType:String = "wall";
		
		public function Wall(x:Number, y:Number, width:Number, height:Number) {
			super(x, y);
			
			this.width = width;
			this.height = height;
			
			type = Wall.collisionType;
		}
	}
}