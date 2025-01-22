package feathers.controls
{
	import starling.events.KeyboardEvent;

	public interface ITouchKeyboardTextEditor
	{
		/** ToucKeyboardTextInput will automatically call this method when it handles a KEY_DOWN event from TouchKeyboard. */
		function touchKeyboard_keyDownHandler(event:KeyboardEvent):void;
	}
}