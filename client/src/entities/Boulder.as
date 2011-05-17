package entities {
	import flashpunk.graphics.Spritemap;
	
	public class Boulder extends MovableEntity {
		//collision
		public static const COLLISION_TYPE_BOULDER_CREATING:String = "boulder creating";
		public static const COLLISION_TYPE_BOULDER_STILL:String = "boulder still";
		public static const COLLISION_TYPE_BOULDER_MOVING:String = "boulder moving";
		
		//speed
		private const MAX:Number = 20;
		private const ACCEL:Number = .2;
		
		//size
		private const W:uint = 40;
		private const H:uint = 34;
		
		//collision helper
		public var shoved:Boolean = false;
		
		//sprite
		[Embed(source = '../../images/boulder.PNG')]
		private static const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, W, H);
		
		public function Boulder(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = Boulder.COLLISION_TYPE_BOULDER_STILL;
			
			//max
			moveForce.max = MAX;
			
			//overlap
			preventWallOverlap = false;
			
			//image
			sprite_map.setFrame(2, 0);
		}
	}
}