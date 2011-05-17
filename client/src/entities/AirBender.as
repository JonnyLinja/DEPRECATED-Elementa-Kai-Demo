package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	import physics.ForceComponent;
	
	import general.Utils;
	
	public class AirBender extends Bender {
		//collision
		public static const COLLISION_TYPE:String = "airbender";
		
		//speed
		private const MAX:Number = 15;
		private const ACCEL:Number = .2;
		private const DECEL:Number = .1;
		
		//size
		private const W:uint = 25;
		private const H:uint = 32;
		
		//sprite
		[Embed(source = '../../images/airbender.PNG')]
		private static const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, W, H);
		
		//bounce
		private var shouldBounceVertical:Boolean;
		private var shouldBounceHorizontal:Boolean;
		
		public function AirBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = AirBender.COLLISION_TYPE;
			
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
			
			//temp animation test
			sprite_map.add("walkdown", [0, 1, 2], 20, true);
			sprite_map.play("walkdown");
		}
		
		override protected function resetShouldVariables():void {
			super.resetShouldVariables();
			shouldBounceVertical = false;
			shouldBounceHorizontal = false;
		}
		
		override protected function resolveShouldVariables():void {
			super.resolveShouldVariables();
			
			//bounce
			if (shouldBounceVertical)
				bounceVertical();
			if (shouldBounceHorizontal)
				bounceHorizontal();
		}
		
		override protected function collideShouldStop(hitTest:int):void {
			if (hitTest == HIT_TOP || hitTest == HIT_BOTTOM)
				shouldBounceVertical = true;
			else if (hitTest == HIT_LEFT || hitTest == HIT_RIGHT)
				shouldBounceHorizontal = true;
		}
		
		override protected function didCollideWithBender(e:Bender, hitTest:int):void {
			if (hitTest == HIT_TOP) {
				shouldBounceVertical = true;
				if (isMovingUp())
					e.windForce.y += moveForce.y.velocity;
			}else if (hitTest == HIT_BOTTOM) {
				shouldBounceVertical = true;
				if (isMovingDown())
					e.windForce.y += moveForce.y.velocity;
			}else if (hitTest == HIT_LEFT) {
				shouldBounceHorizontal = true;
				if (isMovingLeft())
					e.windForce.x += moveForce.x.velocity;
			}else if (hitTest == HIT_RIGHT) {
				shouldBounceHorizontal = true;
				if (isMovingRight())
					e.windForce.x += moveForce.x.velocity;
			}
		}
		
		private function bounceVertical():void {
			var temp:Number = upForce.velocity;
			upForce.velocity = -downForce.velocity;
			downForce.velocity = -temp;
		}
		
		private function bounceHorizontal():void {
			var temp:Number = leftForce.velocity;
			leftForce.velocity = -rightForce.velocity;
			rightForce.velocity = -temp;
		}
	}
}