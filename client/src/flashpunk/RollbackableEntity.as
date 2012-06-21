package flashpunk {
	import flash.geom.Point;
	
	public class RollbackableEntity extends Entity implements Rollbackable {
		/**
		 * Collision did not occur
		 */
		public const HIT_NONE:int = 0;
		
		/**
		 * Collided along the top side
		 */
		public const HIT_TOP:int = 1;
		
		/**
		 * Collided along the bottom side
		 */
		public const HIT_BOTTOM:int = 2;
		
		/**
		 * Collided along the left side
		 */
		public const HIT_LEFT:int = 3;
		
		/**
		 * Collided along the right side
		 */
		public const HIT_RIGHT:int = 4;
		
		/**
		 * How far the Entity should move along the X axis next update
		 */
		public var shouldMoveX:Number;
		
		/**
		 * How far the Entity should move along the Y axis next update
		 */
		public var shouldMoveY:Number;
		
		public function RollbackableEntity(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		
		/**
		 * Called before update.
		 * Used for checks that don't affect position.
		 * Calls resetShouldVariables.
		 */
		public function preUpdate():void 
		{
			resetShouldVariables();
		}
		
		/**
		 * Resets should variables.
		 * Called at start of preUpdate.
		 */
		protected function resetShouldVariables():void {
			shouldMoveX = 0;
			shouldMoveY = 0;
		}
		
		/**
		 * Updates the Entity.
		 * Used for anything that does affect position.
		 * Calls resolveShouldVariables.
		 */
		override public function update():void 
		{
			resolveShouldVariables();
		}
		
		/**
		 * Resolves should variables.
		 * Called at start of update.
		 */
		protected function resolveShouldVariables():void {
			x += shouldMoveX;
			y += shouldMoveY;
		}
		
		/**
		 * Checks for collisions against a type
		 * Calls callback with entity and the hitTest
		 * @param	type
		 * @param	callback
		 * @param	preventOverlap
		 */
		public function checkCollide(type:String, preventOverlap:Boolean = false, callback:Function = null):void {
			//needs callback
			if (callback == null)
				return;
			
			//declare variables
			var collisionList:Vector.<Entity> = new Vector.<Entity>();
			var intersect:Point = null;
			
			//populate vector
			collideInto(type, x, y, collisionList);
			
			//loop through vector
			for each (var e:Entity in collisionList) {
				intersect = getIntersectRect(e);
				callback(e, hitTest(e, preventOverlap, intersect), intersect);
			}
		}
		
		/**
		 * Returns which side was hit
		 * Assumes that the two Entites DO ALREADY COLLIDE
		 * Sets shouldMoveX and shouldMoveY if preventOverlap is true
		 * @param	e
		 * @param	preventOverlap
		 * @return
		 */
		public function hitTest(e:Entity, preventOverlap:Boolean=false, intersect:Point=null):int {
			if (!intersect)
				intersect = getIntersectRect(e);
			//ratio - may not need, might be able to fudge with 1-1 ratio
			//right now set to use bigger of the two
			//could set to use smaller no problem
			
			var ratioX:int;
			var ratioY:int;
			if (width * height > e.width * e.height) {
				ratioX = width;
				ratioY = height;
			}else {
				ratioX = e.width;
				ratioY = e.height;
			}
			
			//var ratioX:int = 1;
			//var ratioY:int = 1;
			
			//Didn't divide by 2, but still seems to work? wtf? It should move too far away...but it's fine
			//Leaving it for now!
			
			//exclude
			if ((intersect.x / ratioY) <= (intersect.y / ratioX)) {
				//horizontal
				if (x < e.x) {
					//left
					if(preventOverlap)
						shouldMoveX -= intersect.x;
					return HIT_RIGHT;
				}else {
					//right
					if(preventOverlap)
						shouldMoveX += intersect.x;
					return HIT_LEFT;
				}
			}else {
				//vertical
				if (y < e.y) {
					//up
					if(preventOverlap)
						shouldMoveY -= intersect.y;
					return HIT_BOTTOM;
				}else {
					//down
					if(preventOverlap)
						shouldMoveY += intersect.y;
					return HIT_TOP;
				}
			}
		}
		
		/**
		 * Returns point with the size of the intersecting collision rectangle
		 * @param	e
		 * @return
		 */
		protected function getIntersectRect(e:Entity):Point {
			//declare variables
			var intersectionWidth:Number = 0;
			var intersectionHeight:Number = 0;
			
			//horizontal
			if (x < e.x)
				intersectionWidth = Math.abs(x + width - e.x);
			else if (e.x != x)
				intersectionWidth = Math.abs(e.x + e.width - x);
			else
				intersectionWidth = Math.min(width, e.width);
			
			//vertical
			if (y < e.y)
				intersectionHeight = Math.abs(y + height - e.y);
			else if (e.y != y)
				intersectionHeight = Math.abs(e.y + e.height - y);
			else
				intersectionHeight = Math.min(height, e.height);
			
			//return point
			return new Point(intersectionWidth, intersectionHeight);
		}
		
		/**
		 * Rolls back primitive values of current Entity to oldEntity
		 * @param	oldEntity	entity to be rolled back to
		 */
		public function rollback(orig:Rollbackable):void {
			//declare variables
			var e:Entity = orig as Entity;
			
			//position
			x = e.x;
			y = e.y;
			
			//visibility
			visible = e.visible;
			
			//type
			type = e.type;
		}
		
		/** @private */ internal var _created:Boolean; //to determine if should add to the master list
		/** @private */ internal var _next:RollbackableEntity; //master list
		/** @private */ internal var _recyclePrev:RollbackableEntity; //doubly linked recycle
	}
}