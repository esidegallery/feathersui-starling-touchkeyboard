package feathers.utils.touch
{
	import feathers.core.IToggle;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/** 
	 * Extends TapToSelect to extend its functionality, allowing selection
	 * and deselection to occur on more specific touch events.
	 */
	public class TouchToSelect extends TapToSelect
	{
		/** Whether selection occurs on the down state rather than when triggered. */
		public var selectOnDown:Boolean = true;
		/** 
		 * Whether deselection occurs on the down state rather than when triggered.<br>
		 * Applicable only when <code>tapToDeselect = true</code>.
		 */
		private var _deselectOnDown:Boolean = false;

		public function get deselectOnDown():Boolean
		{
			return _deselectOnDown;
		}

		public function set deselectOnDown(value:Boolean):void
		{
			_deselectOnDown = value;
		}

		protected var _ignoreNextDeselect:Boolean;

		public function TouchToSelect(target:IToggle = null, selectOnDown:Boolean = true, tapToDeselect:Boolean = false, deselectOnDown:Boolean = false)
		{
			this.selectOnDown = selectOnDown;
			_tapToDeselect = tapToDeselect;
			this.deselectOnDown = deselectOnDown;

			super(target);
		}

		override protected function target_touchHandler(event:TouchEvent):void
		{
			if (!_isEnabled)
			{
				_touchPointID = -1;
				return;
			}

			if ((!selectOnDown || _tapToDeselect && !deselectOnDown) && _touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(DisplayObject(_target), TouchPhase.ENDED);
				if (!touch)
				{
					return;
				}
				var stage:Stage = _target.stage;
				if (stage !== null)
				{
					var point:Point = Pool.getPoint();
					touch.getLocation(stage, point);
					if (_target is DisplayObjectContainer)
					{
						var isInBounds:Boolean = DisplayObjectContainer(_target).contains(stage.hitTest(point));
					}
					else
					{
						isInBounds = _target === stage.hitTest(point);
					}
					Pool.putPoint(point);

					if (isInBounds)
					{
						if (_tapToDeselect && !deselectOnDown && _target.isSelected && !_ignoreNextDeselect)
						{
							_target.isSelected = false;
						}
						else if (!selectOnDown && !_target.isSelected)
						{
							_target.isSelected = true;
						}
					}
				}

				_ignoreNextDeselect = false;
				_touchPointID = -1;
			}
			else if (selectOnDown || _tapToDeselect && deselectOnDown)
			{
				touch = event.getTouch(DisplayObject(_target), TouchPhase.BEGAN);
				if (!touch)
				{
					return;
				}

				if (_customHitTest !== null)
				{
					point = Pool.getPoint();
					touch.getLocation(DisplayObject(_target), point);
					isInBounds = _customHitTest(point);
					Pool.putPoint(point);
					if (!isInBounds)
					{
						return;
					}

					if (selectOnDown && !_target.isSelected)
					{
						_target.isSelected = true;
						if (_tapToDeselect && !deselectOnDown)
						{
							// Prevent target from deselecting at the end of this touch:
							_ignoreNextDeselect = true;
						}
					}
					else if (_tapToDeselect && deselectOnDown && _target.isSelected)
					{
						_target.isSelected = false;	
					}
				}

				if (!selectOnDown || _tapToDeselect && !deselectOnDown)
				{
					_touchPointID = touch.id;
				}
			}
		}
	}	
}