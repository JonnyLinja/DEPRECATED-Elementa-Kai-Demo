package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	
	import general.Utils;
	
	public class FireBender extends Bender {
		//collision
		public static const collisionType:String = "firebender";
		
		//size
		private const w:uint = 25;
		private const h:uint = 32;
		
		//sprite
		[Embed(source = '../../images/firebender.PNG')]
		private const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, w, h);
		
		//speed
		private const max:Number = 7;
		private const accel:Number = .25;
		private const decel:Number = .5;
		
		public function FireBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = w;
			height = h;
			
			//collision type
			type = FireBender.collisionType;
			
			//max
			moveForce.max = max;
			leftForce.maxVelocity = max;
			rightForce.maxVelocity = max;
			upForce.maxVelocity = max;
			downForce.maxVelocity = max;
			
			//accel
			leftForce.acceleration = -accel;
			rightForce.acceleration = accel;
			upForce.acceleration = -accel;
			downForce.acceleration = accel;
			
			//decel
			leftForce.deceleration = decel;
			rightForce.deceleration = -decel;
			upForce.deceleration = decel;
			downForce.deceleration = -decel;
			
			//temp animation test
			sprite_map.add("walkdown", [0, 1, 2], 20, true);
			sprite_map.play("walkdown");
		}
	}
}