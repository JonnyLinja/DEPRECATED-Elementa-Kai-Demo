package entities {
	import flashpunk.RollbackableEntity;
	import flashpunk.graphics.Spritemap;
	import flashpunk.Rollbackable;
	
	public class SpriteMapEntity extends RollbackableEntity {
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
		
		override public function rollback(orig:Rollbackable):void {
			super.rollback(orig);
			
			//declare
			var e:SpriteMapEntity = orig as SpriteMapEntity;
			
			//animation frame
			if (e.sprite_map.currentAnim) {
				sprite_map.play(e.sprite_map.currentAnim);
				sprite_map.index = e.sprite_map.index;
			}else
				sprite_map.frame = e.sprite_map.frame;
		}
	}
}