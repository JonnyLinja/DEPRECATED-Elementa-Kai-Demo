package {
	import flashpunk.Engine;
	import flashpunk.FP;
	
	import worlds.LoginWorld;
	
	import general.Utils;

	public class Avatar extends Engine {
		public function Avatar() {
			super(640, 480, 60, false);
			FP.world = new LoginWorld;
		}
	}
}