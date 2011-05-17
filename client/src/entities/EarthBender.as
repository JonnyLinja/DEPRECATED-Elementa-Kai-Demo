package entities {
	import flash.geom.Point;
	
	import flashpunk.graphics.Spritemap;
	import flashpunk.FP;
	import flashpunk.Entity;
	
	import general.Utils;
	
	public class EarthBender extends Bender {
		//collision
		public static const COLLISION_TYPE:String = "earthbender";
		
		//speed
		private const MAX:Number = 6;
		
		//size
		private const W:uint = 23;
		private const H:uint = 32;
		
		//should
		public var shouldHalveSpeed:Boolean = false;
		
		//sprite
		[Embed(source = '../../images/earthbender.PNG')]
		private static const image:Class; 
		private var sprite_map:Spritemap = new Spritemap(image, W, H);
		
		public function EarthBender(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
			
			//sprite
			graphic = sprite_map;
			
			//size
			width = W;
			height = H;
			
			//collision type
			type = EarthBender.COLLISION_TYPE;
			
			//max
			moveForce.max = MAX;
			
			//overlap
			preventBoulderOverlap = false;
			
			//temp animation test
			sprite_map.add("walkdown", [0, 1, 2], 20, true);
			sprite_map.play("walkdown");
		}
		
		override protected function resetShouldVariables():void {
			super.resetShouldVariables();
			shouldHalveSpeed = false;
		}
		
		override protected function didCollideWithStillBoulder(e:Entity, hitTestResult:int, intersectSize:Point):void {
			//declare variables
			var isHorizontal:Boolean;
			var toMove:Number;
			
			//add proper sides
			if (hitTestResult == HIT_TOP) {
				isHorizontal = false;
				toMove = -intersectSize.y;
			}else if (hitTestResult == HIT_BOTTOM) {
				isHorizontal = false;
				toMove = intersectSize.y;
			}else if (hitTestResult == HIT_LEFT) {
				isHorizontal = true;
				toMove = -intersectSize.x;
			}else if (hitTestResult == HIT_RIGHT) {
				isHorizontal = true;
				toMove = intersectSize.x;
			}
			
			//recursive call
			if (!shoveBoulder(e as Boulder, hitTestResult, toMove, isHorizontal)) {
				collideShouldStop(hitTestResult);
				
				//prevent overlap
				hitTest(e, true, intersectSize);
			}else
				shouldHalveSpeed = true;
		}
		
		protected function shoveBoulder(boulder:Boulder, hitTestResult:int, toMove:Number, isHorizontal:Boolean):Boolean {
			//if need to go through this
			if (boulder.shoved)
				return true;
			
			//off screen check, prevent shove
			if ((isHorizontal && boulder.isOffScreenHorizontal()) || (!isHorizontal && boulder.isOffScreenVertical())) {
				boulder.shoved = false;
				return false;
			}
			
			//set shoved
			boulder.shoved = true;
			
			//declare variables
			var list:Vector.<Boulder> = new Vector.<Boulder>;
			
			//get list
			boulder.collideInto(Boulder.COLLISION_TYPE_BOULDER_STILL, boulder.x, boulder.y, list);
			
			//loop through list recursively
			for each (var boulder2:Boulder in list) {
				if (!boulder2.shoved) {
					if (hitTestResult != boulder.hitTest(boulder2))
						continue;
					if (!shoveBoulder(boulder2, hitTestResult, toMove, isHorizontal)) {
						boulder.shoved = false;
						return false;
					}
				}
			}
			
			//move boulders
			if(isHorizontal)
				boulder.shouldMoveX += toMove;
			else
				boulder.shouldMoveY += toMove;
			
			//reset
			//boulder.shoved = false;
			
			return true;
		}
		
		override protected function updateMovement():void {
			//horizontal
			if (moveLeft && !moveRight)
				moveForce.x.velocity = -MAX;
			else if (moveRight && !moveLeft)
				moveForce.x.velocity = MAX;
			else
				moveForce.x.velocity = 0;
			
			//vertical
			if (moveUp && !moveDown)
				moveForce.y.velocity = -MAX;
			else if (moveDown && !moveUp)
				moveForce.y.velocity = MAX;
			else
				moveForce.y.velocity = 0;
			
			//max
			moveForce.applyMax();
			
			//halve speed
			if (shouldHalveSpeed) {
				moveForce.x.velocity /= 2;
				moveForce.y.velocity /= 2;
			}
			
			//total
			x += moveForce.x.velocity;
			y += moveForce.y.velocity;
		}
	}
}