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
		
		/**
		 * Returns the lesser of the two
		 * @param	n1
		 * @param	n2
		 * @return
		 */
		public static function least(n1:Number, n2:Number):Number {
			if (n1 <= n2)
				return n1;
			return n2;
		}
		
		public static function swap(a:Object, b:Object):void {
			var c:Object = a;
			a = b;
			b = c;
		}
		
		public static function isBender(e:MovableEntity):Boolean {
			return (e.type == WaterBender.collisionType || e.type == FireBender.collisionType || e.type == EarthBender.collisionType || e.type == AirBender.collisionType);
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