package entities {
	import physics.ForceVector;
	import physics.ForceComponent;
	
	import flashpunk.Entity;
	
	public class Bender extends MovableEntity {
		//commands
		public var moveLeft:Boolean;
		public var moveRight:Boolean;
		public var moveUp:Boolean;
		public var moveDown:Boolean;
		
		//forces
		public var leftForce:ForceComponent = new ForceComponent();
		public var rightForce:ForceComponent = new ForceComponent();
		public var upForce:ForceComponent = new ForceComponent();
		public var downForce:ForceComponent = new ForceComponent();
		
		public function Bender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
		}
		
		override public function preUpdate():void {
			
		}
		
		override public function update():void {
			updateMovement();
		}
		
		protected function updateMovement():void {
			//left
			if (moveLeft)
				leftForce.applyAcceleration();
			else
				leftForce.applyDeceleration();
			
			//right
			if (moveRight)
				rightForce.applyAcceleration();
			else
				rightForce.applyDeceleration();
			
			//up
			if (moveUp)
				upForce.applyAcceleration();
			else
				upForce.applyDeceleration();
			
			//down
			if (moveDown)
				downForce.applyAcceleration();
			else
				downForce.applyDeceleration();
			
			//move force
			moveForce.x.velocity = leftForce.velocity + rightForce.velocity;
			moveForce.y.velocity = upForce.velocity + downForce.velocity;
			moveForce.applyMax();
			
			//total
			x += moveForce.x.velocity;
			y += moveForce.y.velocity;
		}
		
		override public function rollback(oldEntity:Entity):void {
			//declare
			var temp:Bender = oldEntity as Bender;
			
			//position
			x = temp.x;
			y = temp.y;
			
			//move booleans
			moveLeft = temp.moveLeft;
			moveRight = temp.moveRight;
			moveDown = temp.moveDown;
			moveUp = temp.moveUp;
			
			//movement forces
			leftForce.rollback(temp.leftForce);
			rightForce.rollback(temp.rightForce);
			upForce.rollback(temp.upForce);
			downForce.rollback(temp.downForce);
			
			//wind force
		}
	}
}