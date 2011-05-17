package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	
	import general.Utils;
	
	public class EarthBender extends Bender {
		//collision
		public static const COLLISION_TYPE:String = "earthbender";
		
		//speed
		private const MAX:Number = 4;
		
		//size
		private const W:uint = 23;
		private const H:uint = 32;
		
		//sprite
		[Embed(source = '../../images/earthbender.PNG')]
		private static const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, W, H);
		
		public function EarthBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = EarthBender.COLLISION_TYPE;
			
			//max
			moveForce.max = MAX;
			
			//temp animation test
			sprite_map.add("walkdown", [0, 1, 2], 20, true);
			sprite_map.play("walkdown");
		}
		
		override protected function updateMovement():void {
			//horizontal
			if (moveLeft && !moveRight)
				moveForce.x.velocity = -MAX;
			else if (moveRight && !moveLeft)
				moveForce.x.velocity = MAX;
			else
				moveForce.x.velocity = 0;
			
			//vertical
			if (moveUp && !moveDown)
				moveForce.y.velocity = -MAX;
			else if (moveDown && !moveUp)
				moveForce.y.velocity = MAX;
			else
				moveForce.y.velocity = 0;
			
			//max
			moveForce.applyMax();
			
			//total
			x += moveForce.x.velocity;
			y += moveForce.y.velocity;
		}
	}
}