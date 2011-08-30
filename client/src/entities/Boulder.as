package entities {
	import flashpunk.graphics.Spritemap;
	import flashpunk.Entity;
	import flashpunk.Rollbackable;
	import flash.geom.Point;
	
	import general.Utils;
	
	public class Boulder extends MovableEntity {
		//collision
		//public static const COLLISION_TYPE_BOULDER_CREATING:String = "boulder creating";
		public static const COLLISION_TYPE_BOULDER_STILL:String = "boulder still";
		public static const COLLISION_TYPE_BOULDER_MOVING:String = "boulder moving";
		
		//speed
		private const MAX:Number = 40;
		private const ACCEL:Number = .4;
		
		//size
		private const W:uint = 40;
		private const H:uint = 34;
		
		//collision helper
		public var shoved:Boolean = false;
		
		//thrown
		private var throwing:Boolean = false;
		
		//should
		private var shouldBecomeStationary:Boolean = false;
		
		//sprite
		[Embed(source = '../../images/boulder.PNG')]
		private static const image:Class;
		
		public function Boulder(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			sprite_map = new Spritemap(image, W, H);
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = Boulder.COLLISION_TYPE_BOULDER_STILL;
			
			//max
			moveForce.max = MAX;
			
			//overlap
			preventWallOverlap = false;
			
			//image
			sprite_map.setFrame(2, 0);
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
			//if stationary, don't check
			if (!throwing)
				return;
			
			//collisions that cancel throw
			if (collide(EarthBender.COLLISION_TYPE, x, y) != null)
				shouldBecomeStationary = true;
			
			checkCollide(AirBender.COLLISION_TYPE, false, didCollideWithObject);
			checkCollide(FireBender.COLLISION_TYPE, false, didCollideWithObject);
			checkCollide(WaterBender.COLLISION_TYPE, false, didCollideWithObject);
			checkCollide(Boulder.COLLISION_TYPE_BOULDER_MOVING, false, didCollideWithObject);
			checkCollide(Boulder.COLLISION_TYPE_BOULDER_STILL, false, didCollideWithObject);
		}
		
		override protected function didCollideWithWall(e:Entity, hitTestResult:int, intersectSize:Point):void {
			if (throwing)
				didCollideWithObject(e, hitTestResult, intersectSize);
		}
		
		protected function didCollideWithObject(e:Entity, hitTestResult:int, intersectSize:Point):void {
			if (hitTestResult == HIT_TOP && moveForce.y.velocity < 0 || hitTestResult == HIT_BOTTOM && moveForce.y.velocity > 0 || hitTestResult == HIT_LEFT && moveForce.x.velocity < 0 || hitTestResult == HIT_RIGHT && moveForce.x.velocity > 0)
				shouldBecomeStationary = true;
		}
		
		override protected function resolveShouldVariables():void {
			super.resolveShouldVariables();
			
			//become stationary
			if (throwing && shouldBecomeStationary) {
				//Utils.log("reset boulder to stationary");
				type = Boulder.COLLISION_TYPE_BOULDER_STILL;
				shouldBecomeStationary = false;
				throwing = false;
			}
		}
		
		override public function update():void {
			super.update();
			
			//reset shoved
			shoved = false;
			
			//throw movement
			if (throwing) {
				moveForce.applyAcceleration();
				x += moveForce.x.velocity;
				y += moveForce.y.velocity;
			}
		}
		
		public function throwBoulder(x:Number, y:Number):void {
			//just in case check
			if (throwing)
				return;
			
			//set type
			type = Boulder.COLLISION_TYPE_BOULDER_MOVING;
			
			//set throwing
			throwing = true;
			
			//set overlap
			preventWallOverlap = true;
			
			//calculate the acceleration vector
			moveForce.x.velocity = x - centerX;
			moveForce.y.velocity = y - centerY;
			moveForce.calculateAccelerationBasedOnVelocity(ACCEL);
			
			//reset initial velocity
			moveForce.x.velocity = 0;
			moveForce.y.velocity = 0;
			
			//Utils.log("successfully thrown boulder");
		}
		
		override public function rollback(orig:Rollbackable):void {
			super.rollback(orig);
			
			//cast
			var b:Boulder = orig as Boulder;
			
			//should
			throwing = b.throwing;
			shouldBecomeStationary = b.shouldBecomeStationary;
		}
	}
}