package feathers.controls
{
	import feathers.core.ITextEditor;
	import feathers.touchKeyboard.TouchKeyboard;

	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextArea extends TextArea
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
				// _touchKeyboard.removeEventListener(TouchEvent.TOUCH, touchKeyboard_touchHandler);
				_touchKeyboard.removeEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				// _touchKeyboard.removeEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
			// _maintainTouchFocus = false;
			_touchKeyboard = value;
			if (_touchKeyboard)
			{
				// _touchKeyboard.addEventListener(TouchEvent.TOUCH, touchKeyboard_touchHandler);
				_touchKeyboard.addEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				// _touchKeyboard.addEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
		}

		public function TouchKeyboardTextArea()
		{
			_textEditorFactory = function():ITextEditor
			{
				return new TouchKeyboardTextFieldTextEditorViewport;
			};
		}

		protected function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			if (textEditorViewPort is ITouchKeyboardTextInput)
			{
				(textEditorViewPort as ITouchKeyboardTextInput).touchKeyboard_keyDownHandler(event);
			}
		}
	}
}