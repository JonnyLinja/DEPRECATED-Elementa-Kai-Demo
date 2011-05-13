package physics {
	import flashpunk.FP;
	
	public class Formulas {
		public function Formulas() {
			
		}
		
		/*
		public static function velocity(v0:Number, a:Number):Number {
			return v0 + (a * FP.elapsed);
		}
		
		public static function distance(v0:Number, vf:Number):Number {
			return (v0 + vf) * FP.elapsed / 2;
		}
		*/
		
		public static function magnitude(x:Number, y:Number):Number {
			return Math.sqrt((x*x) + (y*y));
		}
	}
}