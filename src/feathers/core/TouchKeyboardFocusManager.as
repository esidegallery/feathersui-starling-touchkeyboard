package feathers.core
{
	import feathers.core.DefaultFocusManager;
	import feathers.core.IFocusDisplayObject;
	import feathers.touchKeyboard.ITouchKeyboardInput;
	import feathers.touchKeyboard.TouchKeyboard;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Ensures that <code>ITouchKeyboardInput</code> instances don't lose focus when touch keyboard is touched.
	 * Also modifies functionality so that invisible IFocusDisplayObjects are not counted as valid focus objects.
	 */
	public class TouchKeyboardFocusManager extends DefaultFocusManager
	{
		public function TouchKeyboardFocusManager(root:DisplayObjectContainer)
		{
			super(root);
		}

		override protected function isValidFocus(child:IFocusDisplayObject):Boolean
		{
			if (child == null || !child.visible)
			{
				return false;
			}
			var parent:DisplayObjectContainer = child.parent;
			while (parent != null)
			{
				if (!parent.visible)
				{
					return false;
				}
				parent = parent.parent;
			}
			return super.isValidFocus(child);
		}

		override protected function topLevelContainer_touchHandler(event:TouchEvent):void
		{
			if (focus is ITouchKeyboardInput)
			{
				var touch:Touch = event.getTouch(_root, TouchPhase.BEGAN);
				if (touch != null)
				{
					var target:DisplayObject = touch.target;
					while (target != null)
					{
						if (target is TouchKeyboard)
						{
							// Prevent focus being lost from the text input:
							return;
						}
						target = target.parent;
					}
				}
			}
			super.topLevelContainer_touchHandler(event);
		}
	}
}