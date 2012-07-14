package entities {
	import entities.Bender;
	
	public class EarthBender extends Bender {
		//animations
		public static const CREATE_DUST_ANIMATION:String = "createdust";
		public static const CREATE_BOULDER_ANIMATION:String = "createboulder";
		
		//collision
		public static const COLLISION_TYPE:String = "earthbender";
		
		//speed
		private const MAX:Number = 6;
		public var shouldHalveSpeed:Boolean = false;
		
		//size
		private const W:uint = 23;
		private const H:uint = 32;
		
		//sprite
		[Embed(source = '../../images/earthbender.PNG')]
		private static const image:Class; 
		
		public function EarthBender(x:Number, y:Number) {
			//super
			super(x, y, image, W, H);
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = EarthBender.COLLISION_TYPE;
			
			//max
			moveForce.max = MAX;
			
			//animation
			sprite_map.add(EarthBender.CREATE_DUST_ANIMATION, [1, 4, 7, 10], 33, true);
			sprite_map.add(EarthBender.CREATE_BOULDER_ANIMATION, [4, 7, 10, 1], 8, true);
		}
		
		override public function update():void {
			//speed
			shouldHalveSpeed = false;
			
			//super
			super.update();
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
			
			//halve speed
			if (shouldHalveSpeed) {
				moveForce.x.velocity /= 2;
				moveForce.y.velocity /= 2;
			}
			
			//total
			x += moveForce.x.velocity;
			y += moveForce.y.velocity;
		}
	}
}