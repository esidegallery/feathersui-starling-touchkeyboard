package feathers.controls
{
	import feathers.controls.TextInput;
	import feathers.core.ITextEditor;
	import feathers.touchKeyboard.TouchKeyboard;

	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextInput extends TextInput
	{
		private var _touchKeyboard:TouchKeyboard;
		public function get touchKeyboard():TouchKeyboard
		{
			return _touchKeyboard;
		}
		public function set touchKeyboard(value:TouchKeyboard):void
		{
			if (_touchKeyboard)
			{
				_touchKeyboard.removeEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				_touchKeyboard.removeEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
			_touchKeyboard = value;
			if (_touchKeyboard)
			{
				_touchKeyboard.addEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				_touchKeyboard.addEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
		}

		public function TouchKeyboardTextInput()
		{
			_textEditorFactory =  function():ITextEditor
			{
				return new TouchKeyboardTextBlockTextEditor;
			}
			super();
		}

		private function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			if (textEditor is ITouchKeyboardTextInput)
			{
				(textEditor as ITouchKeyboardTextInput).touchKeyboard_keyDownHandler(event);
			}
		}

		private function touchKeyboard_removedFromStageHandler():void
		{
			clearFocus();
		}
	}
}