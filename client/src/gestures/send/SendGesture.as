package gestures.send {
	public interface SendGesture {
		/**
		 * @param	ratio		# of frames
		 */
		function update(x:Number, y:Number, mouse:Boolean, ratio:int = 1):void;
	}
}