package feathers.touchKeyboard
{
	import starling.events.KeyboardEvent;

	public interface ITouchKeyboardInput
	{
		function touchKeyboard_keyDownHandler(event:KeyboardEvent):void;
	}
}