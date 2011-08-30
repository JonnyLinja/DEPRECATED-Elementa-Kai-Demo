package entities {
	import flash.geom.Point;
	import flashpunk.Rollbackable;
	import physics.ForceVector;
	import physics.ForceComponent;
	
	import flashpunk.Entity;
	import flashpunk.FP;
	import flashpunk.graphics.Spritemap;
	
	import general.Utils;
	import worlds.GameWorld;
	
	public class Bender extends MovableEntity {
		//animation constants
		public static const WALK_DOWN_ANIMATION:String = "walkdown";
		public static const WALK_UP_ANIMATION:String = "walkup";
		public static const WALK_LEFT_ANIMATION:String = "walkleft";
		public static const WALK_RIGHT_ANIMATION:String = "walkright";
		public static const LOOK_DOWN:int = 1;
		public static const LOOK_LEFT:int = 4;
		public static const LOOK_RIGHT:int = 7;
		public static const LOOK_UP:int = 10;
		
		//commands
		public var moveLeft:Boolean;
		public var moveRight:Boolean;
		public var moveUp:Boolean;
		public var moveDown:Boolean;
		
		//mouse
		public var mouseX:Number = 0;
		public var mouseY:Number = 0
		
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
		
		//overlap
		protected var preventBoulderOverlap:Boolean = true;
		
		public function Bender(x:Number = 0, y:Number = 0, image:Class = null, iWidth:uint= 0, iHeight:uint = 0) {
			//super
			super(x, y);
			
			//image
			if (image) {
				//sprite
				sprite_map = new Spritemap(image, iWidth, iHeight);
				
				//animations
				sprite_map.add(WALK_DOWN_ANIMATION, [0, 1, 2], 33, true);
				sprite_map.add(WALK_LEFT_ANIMATION, [3, 4, 5], 33, true);
				sprite_map.add(WALK_RIGHT_ANIMATION, [6, 7, 8], 33, true);
				sprite_map.add(WALK_UP_ANIMATION, [9, 10, 11], 33, true);
				sprite_map.play(WALK_DOWN_ANIMATION);
			}
		}
			
		override public function preUpdate():void {
			super.preUpdate();
			
			//collisions against benders
			if(type != AirBender.COLLISION_TYPE)
				checkCollide(AirBender.COLLISION_TYPE, true, didCollideWithBender);
			if (type != EarthBender.COLLISION_TYPE)
				checkCollide(EarthBender.COLLISION_TYPE, true, didCollideWithBender);
			if (type != FireBender.COLLISION_TYPE)
				checkCollide(FireBender.COLLISION_TYPE, true, didCollideWithBender);
			if (type != WaterBender.COLLISION_TYPE)
				checkCollide(WaterBender.COLLISION_TYPE, true, didCollideWithBender);
			
			//collisions against still boulders
			checkCollide(Boulder.COLLISION_TYPE_BOULDER_STILL, preventBoulderOverlap, didCollideWithStillBoulder);
		}
		
		override protected function resetShouldVariables():void {
			super.resetShouldVariables();
			
			shouldStopLeft = false;
			shouldStopRight = false;
			shouldStopUp = false;
			shouldStopDown = false;
		}
		
		protected function collideShouldStop(hitTestResult:int):void {
			if (hitTestResult == HIT_TOP)
				shouldStopUp = true;
			else if (hitTestResult == HIT_LEFT)
				shouldStopLeft = true;
			else if (hitTestResult == HIT_RIGHT)
				shouldStopRight = true;
			else if (hitTestResult == HIT_BOTTOM)
				shouldStopDown = true;
		}
		
		override protected function didCollideWithWall(e:Entity, hitTestResult:int, intersectSize:Point):void {
			collideShouldStop(hitTestResult);
		}
		
		protected function didCollideWithBender(e:Entity, hitTestResult:int, intersectSize:Point):void {
			collideShouldStop(hitTestResult);
		}
		
		protected function didCollideWithStillBoulder(e:Entity, hitTestResult:int, intersectSize:Point):void {
			collideShouldStop(hitTestResult);
		}
		
		override public function update():void {
			super.update();
			updateMovement();
			updateDirection();
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
		
		protected function updateDirection():void {
			//determine if walking
			if (sprite_map.currentAnim != "" && sprite_map.currentAnim != WALK_DOWN_ANIMATION && sprite_map.currentAnim != WALK_LEFT_ANIMATION && sprite_map.currentAnim != WALK_RIGHT_ANIMATION && sprite_map.currentAnim != WALK_UP_ANIMATION)
				return;
			
			//direction
			switch(Utils.direction(centerX, centerY, mouseX, mouseY)) {
				case 7:
				case 8:
				case 9:
					sprite_map.play(WALK_UP_ANIMATION);
					break;
				case 4:
					sprite_map.play(WALK_LEFT_ANIMATION);
					break;
				case 1:
				case 2:
				case 3:
					sprite_map.play(WALK_DOWN_ANIMATION);
					break;
				case 6:
					sprite_map.play(WALK_RIGHT_ANIMATION);
					break;
				default:
					break;
			}
			
			//walk or not
			if (moveForce.x.velocity == 0 && moveForce.y.velocity == 0)
				sprite_map.setAnimFrame(sprite_map.currentAnim, 1);
		}
		
		override public function rollback(orig:Rollbackable):void {
			super.rollback(orig);
			
			//cast
			var b:Bender = orig as Bender;
			
			//move booleans
			moveLeft = b.moveLeft;
			moveRight = b.moveRight;
			moveDown = b.moveDown;
			moveUp = b.moveUp;
			
			//movement forces
			leftForce.rollback(b.leftForce);
			rightForce.rollback(b.rightForce);
			upForce.rollback(b.upForce);
			downForce.rollback(b.downForce);
			
			//mouse
			mouseX = b.mouseX;
			mouseY = b.mouseY;
		}
	}
}