package entities {
	import physics.ForceVector;
	import physics.ForceComponent;
	
	import flashpunk.Entity;
	import flashpunk.FP;
	
	import general.Utils;
	
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
		
		//should
		public var shouldStopLeft:Boolean;
		public var shouldStopRight:Boolean;
		public var shouldStopUp:Boolean;
		public var shouldStopDown:Boolean;
		
		public function Bender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
		}
		
		override protected function resetShouldVariables():void {
			super.resetShouldVariables();
			
			shouldMoveX = 0;
			shouldMoveY = 0;
			shouldStopLeft = false;
			shouldStopRight = false;
			shouldStopUp = false;
			shouldStopDown = false;
		}
		
		override protected function resolveShouldVariables():void {
			super.resolveShouldVariables();
			
			//stop at edges
			if (shouldStopLeft) {
				leftForce.velocity = 0;
				if (windForce.x < 0)
					windForce.x = 0;
			}
			if (shouldStopRight) {
				rightForce.velocity = 0;
				if (windForce.x > 0)
					windForce.x = 0;
			}
			if (shouldStopUp) {
				upForce.velocity = 0;
				if (windForce.y < 0)
					windForce.y = 0;
			}
			if (shouldStopDown) {
				downForce.velocity = 0;
				if (windForce.y > 0)
					windForce.y = 0;
			}
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
			//collisions against benders
			checkCollideBender(AirBender.collisionType);
			checkCollideBender(FireBender.collisionType);
			checkCollideBender(EarthBender.collisionType);
			checkCollideBender(WaterBender.collisionType);
		}
		
		override protected function checkOffScreenLeft(clamp:Boolean = true):Boolean {
			if(clamp) {
				shouldStopLeft = super.checkOffScreenLeft(clamp);
				return shouldStopLeft;
			}
			return super.checkOffScreenLeft(clamp);
		}
		
		override protected function checkOffScreenRight(clamp:Boolean = true):Boolean {
			if(clamp) {
				shouldStopRight = super.checkOffScreenRight(clamp);
				return shouldStopRight;
			}
			return super.checkOffScreenRight(clamp);
		}
		
		override protected function checkOffScreenTop(clamp:Boolean = true):Boolean {
			if(clamp) {
				shouldStopUp = super.checkOffScreenTop(clamp);
				return shouldStopUp;
			}
			return super.checkOffScreenTop(clamp);
		}
		
		override protected function checkOffScreenBottom(clamp:Boolean=true):Boolean {
			if(clamp) {
				shouldStopDown = super.checkOffScreenBottom(clamp);
				return shouldStopDown;
			}
			return super.checkOffScreenBottom(clamp);
		}
		
		protected function checkCollideBender(benderCollisionType:String):void {
			//should check
			if (type == benderCollisionType)
				return;
			
			//declare variables
			var collisionList:Vector.<Entity> = new Vector.<Entity>();
			
			//populate vector
			collideInto(benderCollisionType, x, y, collisionList);
			
			//loop through vector
			for each (var e:MovableEntity in collisionList) {
				checkExcludeCollide(e, 25, 32);
			}
		}
		
		override public function update():void {
			super.update();
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
			super.rollback(oldEntity);
			
			//declare
			var temp:Bender = oldEntity as Bender;
			
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