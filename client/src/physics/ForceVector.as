package physics {
	import flashpunk.Rollbackable;
	
	import general.Utils;
	
	public class ForceVector implements Rollbackable {
		public var max:Number; //max distance
		public var x:ForceComponent = new ForceComponent();
		public var y:ForceComponent = new ForceComponent();
		
		public function ForceVector() {
			
		}
		
		public function calculateAccelerationBasedOnVelocity(magnitude:Number):void {
			//determine if necessary
			if (x.velocity == 0 && y.velocity == 0)
				return;
			
			//calculate ratio
			var ratio:Number = magnitude / Formulas.magnitude(x.velocity, y.velocity);
			
			//apply ratio
			x.acceleration = x.velocity * ratio;
			y.acceleration = y.velocity * ratio;
		}
		
		public function calculateDecelerationBasedOnVelocity(magnitude:Number):void {
			//determine if necessary
			if (x.velocity == 0 && y.velocity == 0)
				return;
			
			//calculate ratio
			var ratio:Number = magnitude / Formulas.magnitude(x.velocity, y.velocity);
			
			//apply ratio
			x.deceleration = -x.velocity * ratio;
			y.deceleration = -y.velocity * ratio;
		}
		
		public function applyAcceleration():void {
			x.applyAcceleration();
			y.applyAcceleration();
			applyMax();
		}
		
		public function applyDecceleration():void {
			x.applyDeceleration();
			y.applyDeceleration();
			applyMax();
		}
		
		public function applyMax():void {
			//determine if has max
			if (max <= 0)
				return;
			
			//store magnitude
			var magnitude:Number = Formulas.magnitude(x.velocity, y.velocity);
			
			//determine if necessary
			if (magnitude <= max)
				return;
			
			//calculate ratio
			var ratio:Number = max / magnitude;
			//Utils.log("mag " + magnitude + " / max " + max + " = ratio " + ratio);
			
			//apply ratio
			x.velocity *= ratio;
			y.velocity *= ratio;
		}
		
		public function rollback(orig:Rollbackable):void {
			//declare variables
			var f:ForceVector = orig as ForceVector;
			
			//rollback components
			x.rollback(f.x);
			y.rollback(f.y);
		}
	}
}