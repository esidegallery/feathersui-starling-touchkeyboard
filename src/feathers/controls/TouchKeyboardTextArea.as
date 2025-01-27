package feathers.controls
{
	import feathers.controls.text.TouchKeyboardTextFieldTextEditorViewport;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.ITextEditor;
	import feathers.touchKeyboard.ITouchKeyboardInput;

	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextArea extends TextArea implements IFocusDisplayObject, ITouchKeyboardInput
	{
		public function TouchKeyboardTextArea()
		{
			textEditorFactory = function():ITextEditor
			{
				return new TouchKeyboardTextFieldTextEditorViewport;
			};
		}

		public function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			if (textEditorViewPort is ITouchKeyboardInput)
			{
				(textEditorViewPort as ITouchKeyboardInput).touchKeyboard_keyDownHandler(event);
			}
		}
	}
}