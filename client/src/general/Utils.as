package general {
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;

	public class Utils {
		public static function toFixed(number:Number, factor:int):Number {
			return (Math.round(number * factor)/factor);
		}
		
		public static function toByteArray(value:int):ByteArray {
			var result:ByteArray = new ByteArray();
			result.writeByte(value);
			return result;
		}
		
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
		
		public function Utils() {
			
		}
	}

}