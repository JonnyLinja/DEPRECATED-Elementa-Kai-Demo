package gestures.receive {
	public interface ReceiveGesture {
		/**
		 * @param	ratio		# of frames
		 */
		function update(x:Number, y:Number, mouse:Boolean, flick:Boolean, ratio:int = 1):void;
	}
}