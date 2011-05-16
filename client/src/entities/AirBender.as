package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	import physics.ForceComponent;
	
	import general.Utils;
	
	public class AirBender extends Bender {
		//collision
		public static const collisionType:String = "airbender";
		
		//size
		private const w:uint = 25;
		private const h:uint = 32;
		
		//sprite
		[Embed(source = '../../images/airbender.PNG')]
		private const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, w, h);
		
		//speed
		private const max:Number = 15;
		private const accel:Number = .2;
		private const decel:Number = .1;
		
		//bounce
		private var shouldBounceVertical:Boolean;
		private var shouldBounceHorizontal:Boolean;
		
		public function AirBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = w;
			height = h;
			
			//collision type
			type = AirBender.collisionType;
			
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
			if (hitTest == hitTop || hitTest == hitBottom)
				shouldBounceVertical = true;
			else if (hitTest == hitLeft || hitTest == hitRight)
				shouldBounceHorizontal = true;
		}
		
		override protected function didCollideWithBender(e:Bender, hitTest:int):void {
			if (hitTest == hitTop) {
				shouldBounceVertical = true;
				if (isMovingUp())
					e.windForce.y += moveForce.y.velocity;
			}else if (hitTest == hitBottom) {
				shouldBounceVertical = true;
				if (isMovingDown())
					e.windForce.y += moveForce.y.velocity;
			}else if (hitTest == hitLeft) {
				shouldBounceHorizontal = true;
				if (isMovingLeft())
					e.windForce.x += moveForce.x.velocity;
			}else if (hitTest == hitRight) {
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