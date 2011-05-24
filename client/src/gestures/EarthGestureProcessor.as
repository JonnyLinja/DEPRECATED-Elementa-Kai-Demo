package gestures {
	import commands.Command;
	import commands.MouseCommand;
	
	//needs to accomodate canceling of gestures into another
	
	public class EarthGestureProcessor extends GestureProcessor {
		//booleans
		private var begin:Boolean = false;
		private var canCheckGestures:Boolean = true;
		
		//gestures
		private var clickHoldReleaseGesture:ClickHoldReleaseGesture = new ClickHoldReleaseGesture;
		
		public function EarthGestureProcessor(isP1:Boolean) {
			super(isP1);
		}
		
		override public function update(frame:uint, x:Number, y:Number, mouseDown:Boolean, ratio:int = 1):void {
			//super
			super.update(frame, x, y, mouseDown, ratio);
			
			//reset command
			currentCommand = null;
			
			//can check
			if (!canCheckGestures) {
				if (!mouseDown)
					canCheckGestures = true;
				else
					return;
			}
			
			if (!begin) {
				if(mouseDown) {
					//set variables
					begin = true;
					
					//set command
					currentCommand = new MouseCommand(isP1, MouseCommand.BEGIN, frame, x, y);
					
					//update gestures
					clickHoldReleaseGesture.update(x, y, mouseDown, ratio);
				}
			}else {
				//update
				clickHoldReleaseGesture.update(x, y, mouseDown, ratio);
				
				//check
				if (clickHoldReleaseGesture.check() == Gesture.SUCCESS) {
					//set command
					currentCommand = new MouseCommand(isP1, MouseCommand.CLICK_HOLD_RELEASE, frame, x, y);
					
					//reset gesture
					clickHoldReleaseGesture.reset();
					
					//reset begin
					begin = false;
					canCheckGestures = false;
				}else if (clickHoldReleaseGesture.check() == Gesture.FAILURE) {
					//set command
					currentCommand = new MouseCommand(isP1, MouseCommand.CANCEL, frame, x, y);
					
					//reset gesture
					clickHoldReleaseGesture.reset();
					
					//reset begin
					begin = false;
					canCheckGestures = false;
				}
			}
		}
	}
}