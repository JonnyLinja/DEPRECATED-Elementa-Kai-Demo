package commands {
	public class Command {
		//constants
		public static const W:int = 0;
		public static const A:int = 1;
		public static const S:int = 2;
		public static const D:int = 3;
		
		//vars
		public var player:Boolean;
		public var type:int;
		public var frame:uint;
		
		//linked list
		public var next:Command=null;
		public var prev:Command=null;
		
		public function Command(player:Boolean, command:int, frame:uint) {
			this.player = player;
			this.type = command;
			this.frame = frame;
		}
	}
}