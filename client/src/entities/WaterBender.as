package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	
	import general.Utils;
	
	public class WaterBender extends Bender {
		//collision
		public static const COLLISION_TYPE:String = "waterbender";
		
		//speed
		private const MAX:Number = 8;
		private const ACCEL:Number = .5;
		private const DECEL:Number = .5;
		
		//size
		private const W:uint = 23;
		private const H:uint = 32;
		
		//sprite
		[Embed(source = '../../images/waterbender.PNG')]
		private static const image:Class; 
		
		public function WaterBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y, image, W, H);
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = WaterBender.COLLISION_TYPE;
			
			//max
			moveForce.max = MAX;
			leftForce.maxVelocity = MAX;
			rightForce.maxVelocity = MAX;
			upForce.maxVelocity = MAX;
			downForce.maxVelocity = MAX;
			
			//accel
			leftForce.acceleration = -ACCEL;
			rightForce.acceleration = ACCEL;
			upForce.acceleration = -ACCEL;
			downForce.acceleration = ACCEL;
			
			//decel
			leftForce.deceleration = DECEL;
			rightForce.deceleration = -DECEL;
			upForce.deceleration = DECEL;
			downForce.deceleration = -DECEL;
		}
	}
}