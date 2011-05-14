package physics {
	public class WindForce {
		private static const decel:Number = .1;
		protected var vector:ForceVector = new ForceVector();
		
		public function WindForce() {
			
		}
		
		private function recalculate():void {
			vector.calculateDecelerationBasedOnVelocity(WindForce.decel);
		}
		
		public function get x():Number {
			return vector.x.velocity;
		}
		
		public function set x(x:Number):void {
			vector.x.velocity = x;
			recalculate();
		}
		
		public function get y():Number {
			return vector.y.velocity;
		}
		
		public function set y(y:Number):void {
			vector.y.velocity = y;
			recalculate();
		}
		
		public function setVelocity(x:Number, y:Number):void {
			vector.x.velocity = x;
			vector.y.velocity = y;
			recalculate();
		}
		
		public function addVelocity(x:Number, y:Number):void {
			vector.x.velocity += x;
			vector.y.velocity += y;
			recalculate();
		}
		
		public function applyDecel():void {
			vector.x.applyDeceleration();
			vector.y.applyDeceleration();
		}
		
		public function rollback(oldWindForce:WindForce):void {
			vector.rollback(oldWindForce.vector);
		}
	}
}