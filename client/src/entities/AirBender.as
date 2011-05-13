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
		
		override protected function checkScreenBoundaries():void {
			if (x < 0 || x + width > FP.width)
				shouldBounceHorizontal = true;
			
			if (y < 0 || y + height > FP.height)
				shouldBounceVertical = true;
		}
		
		/**
		 * Bounce effect
		 * @param	e
		 * @param	ratioX
		 * @param	ratioY
		 * @return
		 */
		override protected function checkExcludeCollide(e:MovableEntity, ratioX:int, ratioY:int):int {
			//declare variables
			var result:int = super.checkExcludeCollide(e, ratioX, ratioY);
			
			//bounce
			if (result == hitTop || result == hitBottom)
				shouldBounceVertical = true;
			else if (result == hitLeft || result == hitRight)
				shouldBounceHorizontal = true;
			
			//return result
			return result;
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