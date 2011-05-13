package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	
	import general.Utils;
	
	public class EarthBender extends Bender {
		//collision
		public static const collisionType:String = "earthbender";
		
		//size
		private const w:uint = 23;
		private const h:uint = 32;
		
		//sprite
		[Embed(source = '../../images/earthbender.PNG')]
		private const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, w, h);
		
		//speed
		private const max:Number = 4;
		
		public function EarthBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = w;
			height = h;
			
			//collision type
			type = EarthBender.collisionType;
			
			//max
			moveForce.max = max;
			
			//temp animation test
			sprite_map.add("walkdown", [0, 1, 2], 20, true);
			sprite_map.play("walkdown");
		}
		
		override protected function updateMovement():void {
			//horizontal
			if (moveLeft && !moveRight)
				moveForce.x.velocity = -max;
			else if (moveRight && !moveLeft)
				moveForce.x.velocity = max;
			else
				moveForce.x.velocity = 0;
			
			//vertical
			if (moveUp && !moveDown)
				moveForce.y.velocity = -max;
			else if (moveDown && !moveUp)
				moveForce.y.velocity = max;
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