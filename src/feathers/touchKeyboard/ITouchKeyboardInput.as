package feathers.touchKeyboard
{
	import starling.events.KeyboardEvent;

	public interface ITouchKeyboardInput
	{
		function get touchKeyboardLayoutID():String;
		function touchKeyboard_keyDownHandler(event:KeyboardEvent):void;
	}
}