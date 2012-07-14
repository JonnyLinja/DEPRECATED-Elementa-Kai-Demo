package physics {
	import net.flashpunk.Rollbackable;
	
	public class ForceComponent implements Rollbackable {
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
		
		public function rollback(orig:Rollbackable):void {
			//declare variables
			var f:ForceComponent = orig as ForceComponent;
			
			//rollback values
			velocity = f.velocity;
			acceleration = f.acceleration;
			deceleration = f.deceleration;
			maxVelocity = f.maxVelocity;
		}
	}
}