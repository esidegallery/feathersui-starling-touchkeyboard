package feathers.controls
{
	import feathers.controls.TextInput;
	import feathers.core.ITextEditor;
	import feathers.touchKeyboard.TouchKeyboard;

	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchKeyboardTextInput extends TextInput implements ITouchKeyboardInput
	{
		private var _touchKeyboard:TouchKeyboard;
		public function get touchKeyboard():TouchKeyboard
		{
			return _touchKeyboard;
		}
		public function set touchKeyboard(value:TouchKeyboard):void
		{
			if (_touchKeyboard != null)
			{
				_touchKeyboard.removeEventListener(TouchEvent.TOUCH, touchKeyboard_touchHandler);
				_touchKeyboard.removeEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				_touchKeyboard.removeEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
			_maintainTouchFocus = false;
			_touchKeyboard = value;
			if (_touchKeyboard != null)
			{
				_touchKeyboard.addEventListener(TouchEvent.TOUCH, touchKeyboard_touchHandler);
				_touchKeyboard.addEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				_touchKeyboard.addEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
		}

		protected var _maintainTouchFocus:Boolean;
		override public function get maintainTouchFocus():Boolean
		{
			if (_maintainTouchFocus)
			{
				return true;
			}
			return super.maintainTouchFocus;
		}

		public function TouchKeyboardTextInput()
		{
			_textEditorFactory = function():ITextEditor
			{
				return new TouchKeyboardTextBlockTextEditor;
			};
		}

		protected function touchKeyboard_touchHandler(event:TouchEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			var touch:Touch = event.getTouch(_touchKeyboard);
			if (touch == null)
			{
				return;
			}
			if (touch.phase == TouchPhase.BEGAN)
			{
				_maintainTouchFocus = true;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				_maintainTouchFocus = false;
			}
		}

		protected function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			if (textEditor is ITouchKeyboardTextEditor)
			{
				(textEditor as ITouchKeyboardTextEditor).touchKeyboard_keyDownHandler(event);
			}
		}

		protected function touchKeyboard_removedFromStageHandler():void
		{
			clearFocus();
		}
	}
}