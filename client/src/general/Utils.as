package general {
	import entities.MovableEntity;
	import entities.AirBender;
	import entities.EarthBender;
	import entities.FireBender;
	import entities.WaterBender;
	
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;

	public class Utils {
		/**
		 * Deals with floating point precision desyncs
		 * @param	number
		 * @param	factor
		 * @return
		 */
		public static function toFixed(number:Number, factor:int):Number {
			return (Math.round(number * factor)/factor);
		}
		
		/**
		 * Sends message to JavaScript
		 * @param	data
		 */
		public static function log(data:String):void {
			//temporary - for logging purposes
			ExternalInterface.call("log", data.toString());
		}
		
		public static function swap(a:Object, b:Object):void {
			var c:Object = a;
			a = b;
			b = c;
		}
		
		public static function isBender(e:MovableEntity):Boolean {
			return (e.type == WaterBender.COLLISION_TYPE || e.type == FireBender.COLLISION_TYPE || e.type == EarthBender.COLLISION_TYPE || e.type == AirBender.COLLISION_TYPE);
		}
		
		public static function negative(n:Number):Number {
			if (n < 0)
				return n;
			return -n;
		}
		
		public function Utils() {
			
		}
	}

}