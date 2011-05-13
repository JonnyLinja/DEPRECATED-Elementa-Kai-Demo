package physics {
	public class ForceComponent {
		public var maxVelocity:Number=0;
		public var velocity:Number=0;
		public var acceleration:Number=0;
		public var deceleration:Number=0;
		
		public function ForceComponent() {
		}
		
		public function applyAcceleration():void {
			velocity += acceleration;
			applyMax();
		}
		
		public function applyDeceleration():void {
			//determine if necessary
			if (velocity == 0)
				return;
			
			//determine positive/negative
			var positive:Boolean = (velocity > 0);
			
			//update velocity
			velocity += deceleration;
			
			//determine if far enough
			if((positive && velocity <= 0) || (!positive && velocity > 0))
				velocity = 0;
		}
		
		public function applyMax():void {
			//determine if necessary
			if (maxVelocity <= 0 || velocity == 0)
				return;
			
			//set to max velocity if over
			if (Math.abs(velocity) > maxVelocity) {
				if (velocity < 0)
					//negative
					velocity = -maxVelocity;
				else
					//positive
					velocity = maxVelocity;
			}
		}
		
		public function rollback(oldForceComponent:ForceComponent):void {
			//rollback values
			velocity = oldForceComponent.velocity;
			acceleration = oldForceComponent.acceleration;
			deceleration = oldForceComponent.deceleration;
			maxVelocity = oldForceComponent.maxVelocity;
		}
	}
}