package entities {
	import net.flashpunk.Rollbackable;
	import net.flashpunk.FP;
	
	import entities.SpriteMapEntity;
	
	import physics.ForceVector;
	import physics.WindForce;
	
	public class MovableEntity extends SpriteMapEntity {
		//forces
		public var moveForce:ForceVector = new ForceVector();
		public var windForce:WindForce = new WindForce();
		
		public function MovableEntity(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
		}
		
		public function isMovingUp():Boolean {
			return (moveForce.y.velocity < 0);
		}
		
		public function isMovingDown():Boolean {
			return (moveForce.y.velocity > 0);
		}
		
		public function isMovingLeft():Boolean {
			return (moveForce.x.velocity < 0);
		}
		
		public function isMovingRight():Boolean {
			return (moveForce.x.velocity > 0);
		}
		
		public function isOffScreenHorizontal():Boolean {
			if (x < 0)
				return true;
			if (x + width > FP.width)
				return true;
			return false;
		}
		
		public function isOffScreenVertical():Boolean {
			if (y < 0)
				return true;
			if (y + height > FP.height)
				return true;
			return false;
		}
		
		override public function update():void {
			super.update();
			
			//windforce
			windForce.applyDecel();
			x += windForce.x;
			y += windForce.y;
		}
		
		override public function rollback(orig:Rollbackable):void {
			super.rollback(orig);
			
			//declare
			var e:MovableEntity = orig as MovableEntity;
			
			//rollback forces
			moveForce.rollback(e.moveForce);
			windForce.rollback(e.windForce);
		}
		
		override public function destroy():void {
			//super
			super.destroy();
			
			//move force
			moveForce.destroy();
			moveForce = null;
			
			//wind force
			windForce.destroy();
			windForce = null;
		}
	}
}