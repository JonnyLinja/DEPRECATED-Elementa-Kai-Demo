package entities {
	import net.flashpunk.RollbackableSpriteMap;
	import net.flashpunk.RollbackableEntity;
	import net.flashpunk.Rollbackable;
	
	public class SpriteMapEntity extends RollbackableEntity {
		//sprite map
		protected var _sprite_map:RollbackableSpriteMap;

		public function SpriteMapEntity(x:Number = 0, y:Number = 0) {
			//super
			super(x, y);
		}
		
		public function set sprite_map(map:RollbackableSpriteMap):void {
			//set map
			_sprite_map = map;
			
			//set graphic
			graphic = _sprite_map;
		}
		
		public function get sprite_map():RollbackableSpriteMap {
			return _sprite_map;
		}
		
		public function play(animationType:String):void {
			_sprite_map.play(animationType);
		}
		
		override public function rollback(orig:Rollbackable):void {
			//super
			super.rollback(orig);
			
			//cast
			var s:SpriteMapEntity = orig as SpriteMapEntity;
			
			//roll back
			_sprite_map.rollback(s._sprite_map);
		}
		
		override public function destroy():void {
			//super
			super.destroy();
			
			//sprites
			_sprite_map = null;
			graphic = null;
		}
	}
}