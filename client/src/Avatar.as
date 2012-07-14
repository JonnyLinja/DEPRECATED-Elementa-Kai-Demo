package {
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	import worlds.PlayerIOQuickStartWorld;
	
	import general.Utils;

	public class Avatar extends Engine {
		public function Avatar() {
			super(640, 480, 60, false);
			FP.world = new PlayerIOQuickStartWorld;
		}
	}
}