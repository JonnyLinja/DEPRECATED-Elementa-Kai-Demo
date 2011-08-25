package entities {
	import flashpunk.graphics.Spritemap;
	import entities.SpriteMapEntity;
	
	public class Dust extends SpriteMapEntity {
		//size
		private const W:uint = 40;
		private const H:uint = 34;
		
		//sprite
		[Embed(source = '../../images/dust.PNG')]
		private static const image:Class;
		
		public function Dust(x:Number = 0, y:Number = 0) {
			super(x, y);
			
			//sprite
			sprite_map = new Spritemap(image, W, H);
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = "dust";
			
			//animate
			sprite_map.add("foobar", [0, 1, 2, 3], 10, true);
			sprite_map.play("foobar");
		}
	}
}