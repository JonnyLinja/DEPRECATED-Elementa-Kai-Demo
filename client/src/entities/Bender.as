package entities {
	import net.flashpunk.Rollbackable;
	import net.flashpunk.RollbackableSpriteMap;
	
	import entities.MovableEntity;
	
	import general.Utils;
	
	import physics.ForceComponent;
	
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
		public var mouseY:Number = 0;
		
		//hp
		public var hp:Number = 10;
		
		//forces
		public var leftForce:ForceComponent = new ForceComponent();
		public var rightForce:ForceComponent = new ForceComponent();
		public var upForce:ForceComponent = new ForceComponent();
		public var downForce:ForceComponent = new ForceComponent();
		
		public function Bender(x:Number, y:Number, image:Class = null, iWidth:uint= 0, iHeight:uint = 0) {
			//super
			super(x, y);
			
			//image
			if (image) {
				//sprite
				sprite_map = new RollbackableSpriteMap(image, iWidth, iHeight);
				
				//animations
				sprite_map.add(WALK_DOWN_ANIMATION, [0, 1, 2], 33, true);
				sprite_map.add(WALK_LEFT_ANIMATION, [3, 4, 5], 33, true);
				sprite_map.add(WALK_RIGHT_ANIMATION, [6, 7, 8], 33, true);
				sprite_map.add(WALK_UP_ANIMATION, [9, 10, 11], 33, true);
				sprite_map.play(WALK_DOWN_ANIMATION);
			}
		}
		
		override public function update():void {
			//super
			super.update();
			
			//movement
			updateMovement();
			
			//direction
			updateDirection();
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
		
		override public function destroy():void {
			//super
			super.destroy();
			
			//destroy
			leftForce = null;
			rightForce = null;
			upForce = null;
			downForce = null;
		}
	}
}