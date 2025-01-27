package feathers.controls
{
	import feathers.controls.TextInput;
	import feathers.controls.text.TouchKeyboardTextBlockTextEditor;
	import feathers.core.ITextEditor;
	import feathers.touchKeyboard.ITouchKeyboardInput;

	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextInput extends TextInput implements ITouchKeyboardInput
	{
		public function TouchKeyboardTextInput()
		{
			_textEditorFactory = function():ITextEditor
			{
				return new TouchKeyboardTextBlockTextEditor;
			};
		}

		public function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			if (textEditor is ITouchKeyboardInput)
			{
				(textEditor as ITouchKeyboardInput).touchKeyboard_keyDownHandler(event);
			}
		}
	}
}