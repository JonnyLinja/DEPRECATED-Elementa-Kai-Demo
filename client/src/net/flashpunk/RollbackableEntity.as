package net.flashpunk {
	import flash.geom.Point;
	
	import net.flashpunk.Destroyable;
	import net.flashpunk.Entity;
	import net.flashpunk.RollbackableSfx;
	import net.flashpunk.RollbackableWorld;
	import net.flashpunk.namespace.RollbackNamespace;
	
	use namespace RollbackNamespace;
	
	public class RollbackableEntity extends Entity implements Rollbackable, Destroyable {
		/**
		 * Boolean indicating if entity exists in true or perceived world
		 */
		RollbackNamespace var _isTrueEntity:Boolean=false;
		
		public function RollbackableEntity(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		
		public function get isTrueEntity():Boolean {
			return _isTrueEntity;
		}
		
		/**
		 * Adds sounds to be played/rolled back as needed
		 * @param	s
		 */
		public function addSound(s:RollbackableSfx):void {
			//connect
			if (_firstSfx)
				s.next = _firstSfx;
			
			//set it as head
			_firstSfx = s;
			
			//set frame getter
			s.getStartFrame = getFrame;
		}
		
		//frame getter
		private function getFrame():Number {
			return (world as RollbackableWorld).frame;
		}
		
		override public function render():void {
			//super
			super.render();
			
			//deciare variables
			var w:RollbackableWorld = world as RollbackableWorld;
			
			//sounds
			var current:RollbackableSfx = _firstSfx;
			while (current) {
				//play, note frame-1 is to offset frame increment in update
				current.render(w.frame-1, w.frameRate);
				
				//increment
				current = current.next;
			}
		}
		
		/**
		 * Rolls back primitive values of current Entity to oldEntity
		 * @param	oldEntity	entity to be rolled back to
		 */
		public function rollback(orig:Rollbackable):void {
			//declare variables
			var e:RollbackableEntity = orig as RollbackableEntity;
			
			//priority
			_updatePriority = e._updatePriority;
			_typePriority = e._typePriority;
			
			//position
			x = e.x;
			y = e.y;
			
			//visibility
			visible = e.visible;
			
			//active
			active = e.active;
			
			//type
			type = e.type;
			
			//sounds
			var current:RollbackableSfx = _firstSfx;
			var eCurrent:RollbackableSfx = e._firstSfx;
			while (current && eCurrent) {
				//rollback
				current.rollback(eCurrent);
				
				//increment
				current = current.next;
				eCurrent = eCurrent.next;
			}
		}
		
		/**
		 * Destroys the Sfx linked list
		 */
		private function destroySfx():void {
			trace("destroying sfx"); //temp debug
			
			//declare variables
			var s:RollbackableSfx = _firstSfx;
			var n:RollbackableSfx = null;
			
			//loop destroy
			while (s) {
				n = s.next;
				s.next = null;
				s.getStartFrame = null;
				s = n;
			}
			
			//destroy holders
			_firstSfx = null;
		}
		
		/**
		 * Release all references
		 */
		public function destroy():void {
			trace("destroy called"); //temp debug
			destroySfx();
		}
		
		/**
		 * temp debug
		 * @return
		 */
		override public function toString():String {
			return this.getClass() + "\t" + (this.world != null) + "\t" + x + ", " + y;
		}
		
		/** @private */ private var _firstSfx:RollbackableSfx = null;
		/** @private */ internal var _updatePriority:int = 0; //to ensure that perceived and true worlds update entities in the same order
		/** @private */ internal var _typePriority:int = 0; //to ensure that perceived and true worlds check collisions in the same order
		/** @private */ internal var _created:Boolean; //to determine if should add to the master list
		/** @private */ internal var _next:RollbackableEntity; //master list
		/** @private */ internal var _recyclePrev:RollbackableEntity; //doubly linked recycle
	}
}