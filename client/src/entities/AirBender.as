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
		/*
		override protected function checkOffScreenLeft(clamp:Boolean=true):Boolean {
			var result:Boolean = super.checkOffScreenLeft(false);
			if (result)
				shouldBounceHorizontal = true;
			return result;
		}
		
		override protected function checkOffScreenRight(clamp:Boolean=true):Boolean {
			var result:Boolean = super.checkOffScreenRight(false);
			if (result)
				shouldBounceHorizontal = true;
			return result;
		}
		
		override protected function checkOffScreenTop(clamp:Boolean=true):Boolean {
			var result:Boolean = super.checkOffScreenTop(false);
			if (result)
				shouldBounceVertical = true;
			return result;
		}
		
		override protected function checkOffScreenBottom(clamp:Boolean=true):Boolean {
			var result:Boolean = super.checkOffScreenBottom(false);
			if (result)
				shouldBounceVertical = true;
			return result;
		}
		*/
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
			var isBender:Boolean = Utils.isBender(e);
			
			//bounce and add windforce to other benders
			//may want to split add windforce up for clarity later
			if (result == hitTop) {
				shouldBounceVertical = true;
				if (isBender && isMovingUp())
					e.windForce.y += moveForce.y.velocity;
			}else if (result == hitBottom) {
				shouldBounceVertical = true;
				if (isBender && isMovingDown())
					e.windForce.y += moveForce.y.velocity;
			}else if (result == hitLeft) {
				shouldBounceHorizontal = true;
				if (isBender && isMovingLeft())
					e.windForce.x += moveForce.x.velocity;
			}else if (result == hitRight) {
				shouldBounceHorizontal = true;
				if (isBender && isMovingRight())
					e.windForce.x += moveForce.x.velocity;
			}
			
			//ignore should stops
			shouldStopDown = false;
			shouldStopLeft = false;
			shouldStopRight = false;
			shouldStopUp = false;
			
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