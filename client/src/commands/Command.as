package commands {
	public class Command {
		//may want to consider splitting this into multiple classes
		//more concerned with cpu than memory - not sure which is better
		
		//constants
		public static const UPDATE:int = 0;
		public static const W:int = 1;
		public static const A:int = 2;
		public static const S:int = 3;
		public static const D:int = 4;
		public static const MOUSE_DRAG:int = 5;
		public static const MOUSE_TOGGLE:int = 6;
		
		//vars
		public var player:Boolean;
		public var type:int;
		public var frame:uint;
		public var x:Number; //number type for speed purposes?
		public var y:Number; //number type for speed purposes?
		public var usesPoint:Boolean;
		
		//linked list
		public var next:Command;
		public var prev:Command;
		
		/**
		 * Constructor
		 * Instantiates variables
		 * @param	player
		 * @param	command
		 * @param	frame
		 * @param	x
		 * @param	y
		 */
		public function Command(player:Boolean, command:int, frame:uint, usesPoint:Boolean=false, x:Number=0, y:Number=0) {
			this.player = player;
			this.type = command;
			this.frame = frame;
			this.usesPoint = usesPoint;
			this.x = x;
			this.y = y;
		}
	}
}