package feathers.controls.text
{
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.touchKeyboard.ITouchKeyboardInput;

	import flash.events.TextEvent;
	import flash.ui.Keyboard;

	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextBlockTextEditor extends TextBlockTextEditor implements ITouchKeyboardInput
	{
		public function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			stage_keyDownHandler(event);

			if (!_isEnabled || !_isEditable ||
					event.ctrlKey || event.altKey || event.isDefaultPrevented() ||
					touchPointID >= 0)
			{
				return;
			}

			if (event.charCode > 0)
			{
				var char:String = String.fromCharCode(event.charCode);
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				char = "\n";
			}
			if (char)
			{
				nativeFocus_textInputHandler(new TextEvent(TextEvent.TEXT_INPUT, false, true, char));
			}
		}
	}
}