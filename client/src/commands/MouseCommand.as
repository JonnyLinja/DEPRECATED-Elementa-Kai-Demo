package commands {
	public class MouseCommand extends Command {
		//constants
		public static const BLANK:int = 4;
		public static const BEGIN:int = 5;
		public static const CANCEL:int = 6;
		public static const CLICK_HOLD_RELEASE:int = 7;
		
		//variables
		public var x:Number; //number type for speed purposes?
		public var y:Number; //number type for speed purposes?
		
		public function MouseCommand(player:Boolean, command:int, frame:uint, x:Number=0, y:Number=0) {
			super(player, command, frame);
			this.x = x;
			this.y = y;
		}
	}
}