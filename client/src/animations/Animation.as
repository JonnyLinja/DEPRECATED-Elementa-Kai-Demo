package animations {
	public class Animation {
		public var name:String;
		public var frames:Array;
		public var speed:int;
		public var loop:Boolean;
		
		public function Animation(name:String, frames:Array, speed:int, loop:Boolean) {
			this.name = name;
			this.frames = frames;
			this.speed = speed;
			this.loop = loop;
		}
	}
}