package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	
	import general.Utils;
	
	public class FireBender extends Bender {
		//collision
		public static const COLLISION_TYPE:String = "firebender";
		
		//speed
		private const MAX:Number = 14;
		private const ACCEL:Number = .5;
		private const DECEL:Number = 1;
		
		//size
		private const W:uint = 25;
		private const H:uint = 32;
		
		//sprite
		[Embed(source = '../../images/firebender.PNG')]
		private static const image:Class;
		
		public function FireBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y, image, W, H);
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = FireBender.COLLISION_TYPE;
			
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