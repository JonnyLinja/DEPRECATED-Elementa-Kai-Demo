package gestures {
	import flash.geom.Point;
	import general.Utils;
	
	public class ClickDragDragVerticalGesture implements Gesture {
		//constants
		private static const STAGE_BEGIN:int = 0;
		private static const STAGE_INIT_DIRECTION:int = 1;
		private static const STAGE_FIRST_DIST:int = 2;
		private static const STAGE_SECOND_DIST:int = 3;
		private static const STAGE_DONE:int = 4;
		private static const MIN:Number = 100;
		
		//stage
		private var stage:int = 0;
		
		//direction
		private var up:Boolean = false;
		
		//distance
		private var upDistance:Number = 0;
		private var downDistance:Number = 0;
		
		//points
		public var startPoint:Point;
		private var lastPoint:Point;
		
		public function ClickDragDragVerticalGesture() {
		}
		
		/**
		 * Poorly written
		 * Done this way since it was easy
		 * Might want to come back and make it better later
		 */
		public function check(p:Point, mouseDown:Boolean = false):Boolean {
			//mouseup, kill stage
			if (!mouseDown) {
				//can check for success
				if (stage == STAGE_SECOND_DIST) {
					//Utils.log("early mouse release");
					if (successGesture())
						return true;
				}
				
				//reset
				reset();
				return false;
			}
			
			//start the entire check
			if (stage == STAGE_BEGIN) {
				startPoint = p;
				lastPoint = p;
				stage++;
				//Utils.log("begin gesture");
				return false;
			}
			
			//first time after begin check
			if (stage == STAGE_INIT_DIRECTION) {
				//determine if can use
				if (p.y == startPoint.y)
					return false;
				
				//store point
				lastPoint = p;
				
				//determine direction and add distance
				if (p.y < startPoint.y) {
					up = true;
					upDistance += startPoint.y - p.y;
					//Utils.log("up " + upDistance);
				}else {
					up = false;
					downDistance += p.y - startPoint.y;
					//Utils.log("down " + downDistance);
				}
				
				//finish
				stage++;
				return false;
			}
			
			//same initial direction
			if (stage == STAGE_FIRST_DIST) {
				//determine direction and add distance
				if (up) {
					if(p.y <= lastPoint.y) {
						upDistance += lastPoint.y - p.y;
						//Utils.log("stage1 dist " + upDistance);
					}else
						stage++;
				}else {
					if(p.y >= lastPoint.y) {
						downDistance += p.y - lastPoint.y;
						//Utils.log("stage1 dist " + downDistance);
					}else
						stage++;
				}
				
				//store point
				lastPoint = p;
				
				//finish
				return false;
			}
			
			//change direction
			if (stage == STAGE_SECOND_DIST) {
				//determine direction and add distance
				if (!up) {
					if(p.y <= lastPoint.y) {
						upDistance += lastPoint.y - p.y;
					//	Utils.log("stage2 dist " + upDistance);
					}else {
						stage++;
						if (successGesture())
							return true;
					}
				}else {
					if(p.y >= lastPoint.y) {
						downDistance += p.y - lastPoint.y;
					//	Utils.log("stage2 dist " + downDistance);
					}else {
						stage++;
						if (successGesture())
							return true;
					}
				}
				
				//store point
				lastPoint = p;
			}
			
			return false;
		}
		
		private function successGesture():Boolean {
			var result:Boolean = (Math.min(upDistance, downDistance) >= MIN);
			//Utils.log("success check " + result);
			return result;
		}
		
		public function reset():void {
			startPoint = null;
			lastPoint = null;
			upDistance = 0;
			downDistance = 0;
			stage = STAGE_BEGIN;
		}
		
		public function rollback(g:ClickDragDragVerticalGesture):void {
			stage = g.stage;
			up = g.up;
			upDistance = g.upDistance;
			downDistance = g.downDistance;
			
			//start point
			if (startPoint && !g.startPoint)
				startPoint = null;
			else if (!startPoint && g.startPoint)
				startPoint = new Point(g.startPoint.x, g.startPoint.y);
			else if(startPoint && g.startPoint) {
				startPoint.x = g.startPoint.x;
				startPoint.y = g.startPoint.y;
			}
			
			//last point
			if (lastPoint && !g.lastPoint)
				lastPoint = null;
			else if (!lastPoint && g.lastPoint)
				lastPoint = new Point(g.lastPoint.x, g.lastPoint.y);
			else if(lastPoint && g.lastPoint){
				lastPoint.x = g.lastPoint.x;
				lastPoint.y = g.lastPoint.y;
			}
		}
	}
}