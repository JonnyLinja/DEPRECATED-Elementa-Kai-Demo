package entities {
	import flashpunk.Entity;
	import flashpunk.graphics.Spritemap;
	
	public class SpriteMapEntity extends Entity {
		protected var _sprite_map:Spritemap; //since I'll be using sprite maps for everything, easier to put it here than redefining each time
		
		public function SpriteMapEntity(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
		}
		
		public function set sprite_map(map:Spritemap):void {
			//set map
			_sprite_map = map;
			
			//set graphic
			graphic = _sprite_map;
		}
		
		public function get sprite_map():Spritemap {
			return _sprite_map;
		}
		
		public function play(animationType:String):void {
			_sprite_map.play(animationType);
		}
	}
}