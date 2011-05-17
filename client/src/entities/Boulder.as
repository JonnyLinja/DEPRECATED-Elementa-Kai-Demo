package entities {
	public class Boulder extends MovableEntity {
		//collision
		public static const COLLISION_TYPE_BOULDER_CREATING:String = "boulder creating";
		public static const COLLISION_TYPE_BOULDER_STILL:String = "boulder still";
		public static const COLLISION_TYPE_BOULDER_MOVING:String = "boulder moving";
		
		//speed
		private const MAX:Number = 20;
		private const ACCEL:Number = .2;
		
		//size
		private const W:uint = 25;
		private const H:uint = 32;
		
		//sprite
		[Embed(source = '../../images/boulder.PNG')]
		private static const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, W, H);
		
		public function Boulder(x:Number = 0, y:Number = 0) {
			
		}
	}
}