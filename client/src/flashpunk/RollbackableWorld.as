package flashpunk {
	import flashpunk.utils.Draw;
	
	public class RollbackableWorld extends World implements Rollbackable {
		
		public function RollbackableWorld() {
			
		}
		
		/**
		 * Modified to run preupdates first
		 */
		override public function update():void {
			// preupdate checks
			var e:RollbackableEntity = _updateFirst as RollbackableEntity;
			while (e) {
				if (e.active)
					e.preUpdate();
				e = e._updateNext as RollbackableEntity;
			}
			
			super.update();
		}
		
		override public function render():void {
			FP.screen.swap();
			Draw.resetTarget();
			FP.screen.refresh();
			super.render();
			FP.screen.redraw();
		}
		
		/**
		 * Modified to also call destroy master list
		 */
		override public function removeAll():void {
			super.removeAll();
			destroyMasterList();
		}
		
		/**
		 * Meant to be called on ending the world. Destroys the entire Master list.
		 * Does not use updateLists because there's no need to -> done at the end of World
		 */
		public function destroyMasterList():void {
			//declare variables
			var e:RollbackableEntity = _firstEntity as RollbackableEntity;
			var n:RollbackableEntity = null;
			
			//loop destroy
			while (e) {
				n = e._next as RollbackableEntity;
				e._next = null;
				e._world = null;
				e.removed();
				e = n;
			}
		}
		
		/**
		 * Modified to accomodate doubly linked recycle list
		 */
		override public function create(classType:Class, addToWorld:Boolean = true):Entity {
			var e:RollbackableEntity = _recycled[classType] as RollbackableEntity;
			if (e) {
				if(e._recycleNext)
					(e._recycleNext as RollbackableEntity)._recyclePrev = null;
			}
			return super.create(classType, addToWorld);
		}
		
		/**
		 * Returns the unrecycled Entity.
		 * @param	e				The Entity to unrecycle.
		 * @param	addToWorld		Add it to the World immediately.
		 * @return	The Entity object.
		 */
		public function unrecycle(e:RollbackableEntity, addToWorld:Boolean = true):Entity {
			//connect the surrounding elements
			if(e._recycleNext)
				(e._recycleNext as RollbackableEntity)._recyclePrev = e._recyclePrev;
			if(e._recyclePrev)
				(e._recyclePrev as RollbackableEntity)._recycleNext = e._recycleNext;
			
			//move head
			if (e == _recycled[e._class])
				_recycled[e._class] = e._recycleNext;
			
			//make connects null
			e._recyclePrev = null;
			e._recycleNext = null;
			
			if (addToWorld) return add(e);
				return e;
		}
		
		/**
		 * Original function was static for some reason
		 * Made a non static variation
		 * Modified to set recycle next to null as well
		 */
		public function clearRecycled(classType:Class):void {
			var e:RollbackableEntity = _recycled[classType],
				n:RollbackableEntity;
			while (e) {
				n = e._recycleNext as RollbackableEntity;
				e._recycleNext = null;
				e._recyclePrev = null;
				e = n;
			}
			delete _recycled[classType];
		}
		
		/**
		 * Modified to add to master list and add unrecycled entities
		 */
		override public function updateLists():void {
			var e:RollbackableEntity;
			
			// remove entities
			if (_remove.length)
			{
				for each (e in _remove)
				{
					if (!e._world)
					{
						if(_add.indexOf(e) >= 0)
							_add.splice(_add.indexOf(e), 1);
						
						continue;
					}
					if (e._world !== this)
						continue;
					
					e.removed();
					e._world = null;
					
					removeUpdate(e);
					removeRender(e);
					if (e._type) removeType(e);
					if (e._name) unregisterName(e);
					if (e.autoClear && e._tween) e.clearTweens();
				}
				_remove.length = 0;
			}
			
			// add entities
			if (_add.length)
			{
				for each (e in _add)
				{
					//add to master list
					if (!e._created)
					{
						e._created = true;
						addToMasterList(e);
					}
					
					//add brand new Entity to recycled list
					if (e._world)
					{
						e._world = null;
						e._recycleNext = null;
						_recycle[_recycle.length] = e;
						continue;
					}
					
					//add to update and render
					addUpdate(e);
					addRender(e);
					if (e._type) addType(e);
					if (e._name) registerName(e);
					
					e._world = this;
					e.added();
				}
				_add.length = 0;
			}
			
			// recycle entities
			if (_recycle.length)
			{
				for each (e in _recycle)
				{
					if (e._world || e._recycleNext)
						continue;
					
					e._recycleNext = _recycled[e._class];
					if(e._recycleNext)
						(e._recycleNext as RollbackableEntity)._recyclePrev = e;
					_recycled[e._class] = e;
				}
				_recycle.length = 0;
			}
			
			// sort the depth list
			if (_layerSort)
			{
				if (_layerList.length > 1) FP.sort(_layerList, true);
				_layerSort = false;
			}
		}
		
		/**
		 * Initializes the sync point
		 * Called after the preloaded Entities have been added
		 */
		public function beginSync():void {
			_syncPoint = _lastEntity;
		}
		
		/**
		 * Ensures master lists are the same
		 * Adds unrecycled entities from w to this world
		 * @param	w
		 */
		public function synchronize(w:RollbackableWorld):void {
			//default sync point
			if (!w._syncPoint)
				return;
			
			//increment to next
			w._syncPoint = w._syncPoint._next;
			
			//loop
			while (w._syncPoint) {
				//add unrecycled
				var e:Entity = new w._syncPoint._class;
				e._world = this; //force it to be added as recycled
				add(e);
				
				//increment
				w._syncPoint = w._syncPoint._next;
			}
			
			//update
			updateLists();
			
			//set sync points
			_syncPoint = _lastEntity;
			w._syncPoint = w._lastEntity;
		}
		
		/**
		 * Rolls back primitive values of current World's Entities to the old World's Entities
		 * Assumes both worlds have already been synchronized
		 * @param	w	World to be rolled back to
		 */
		public function rollback(orig:Rollbackable):void {
			//declare vars
			var w:RollbackableWorld = orig as RollbackableWorld;
			var thisCurrentEntity:RollbackableEntity = _firstEntity;
			var oldCurrentEntity:RollbackableEntity = w._firstEntity;
			
			//loop through all entities to be rolled back to
			while(oldCurrentEntity) {
				//rollback
				if (oldCurrentEntity._world && !thisCurrentEntity._world) {
					//unrecycle entity and rollback
					unrecycle(thisCurrentEntity);
					thisCurrentEntity.rollback(oldCurrentEntity);
				}else if (!oldCurrentEntity._world && thisCurrentEntity._world) {
					//recycle entity
					recycle(thisCurrentEntity);
				}else if(oldCurrentEntity._world && thisCurrentEntity._world) {
					//just rollback
					thisCurrentEntity.rollback(oldCurrentEntity);
				}
				
				//increment
				thisCurrentEntity = thisCurrentEntity._next;
				oldCurrentEntity = oldCurrentEntity._next;
			}
			
			//update lists
			updateLists();
			w.updateLists();
		}
		
		/** @private Adds Entity to the master list. */
		private function addToMasterList(e:RollbackableEntity):void {
			// add to master list
			if (_lastEntity) {
				//not first entry into list
				_lastEntity._next = e;
				_lastEntity = e;
			}else {
				//first entry
				_firstEntity = e;
				_lastEntity = e;
			}
			
			//cleanup
			e._next = null;
		}
		
		/**
		 * Directly copied from World.as so I don't have to change the type
		 */
		private function addUpdate(e:Entity):void
		{
			// add to update list
			if (_updateFirst)
			{
				_updateFirst._updatePrev = e;
				e._updateNext = _updateFirst;
			}
			else e._updateNext = null;
			e._updatePrev = null;
			_updateFirst = e;
			_count ++;
			if (!_classCount[e._class]) _classCount[e._class] = 0;
			_classCount[e._class] ++;
		}
		
		/**
		 * Directly copied from World.as so I don't have to change the type
		 */
		private function removeUpdate(e:Entity):void {
			// remove from the update list
			if (_updateFirst == e) _updateFirst = e._updateNext;
			if (e._updateNext) e._updateNext._updatePrev = e._updatePrev;
			if (e._updatePrev) e._updatePrev._updateNext = e._updateNext;
			e._updateNext = e._updatePrev = null;
			
			_count --;
			_classCount[e._class] --;
		}
		
		// Rollback information.
		 /** @private */ private var _firstEntity:RollbackableEntity;
		 /** @private */ private var _lastEntity:RollbackableEntity;
		 /** @private */ private var _syncPoint:RollbackableEntity;
	}
}