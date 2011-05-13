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
		
		/**
		 * Bounce effect
		 * @param	e
		 * @param	ratioX
		 * @param	ratioY
		 * @return
		 */
		override public function excludeCollide(e:MovableEntity, ratioX:int, ratioY:int):int {
			//declare variables
			var result:int = super.excludeCollide(e, ratioX, ratioY);
			
			//change velocities if moving in proper direction
			if (result == hitTop) {
				if (Math.abs(downForce.velocity) < Math.abs(upForce.velocity))
					bounceVertical();
			}else if(result == hitBottom) {
				if (Math.abs(upForce.velocity) < Math.abs(downForce.velocity))
					bounceVertical();
			}else if (result == hitLeft) {
				if (Math.abs(rightForce.velocity) < Math.abs(leftForce.velocity))
					bounceHorizontal();
			}else if (result == hitRight) {
				if (Math.abs(leftForce.velocity) < Math.abs(rightForce.velocity))
					bounceHorizontal();
			}
			
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