package feathers.controls
{
	import feathers.touchKeyboard.TouchKeyboard;

	public interface ITouchKeyboardInput
	{
		function get touchKeyboard():TouchKeyboard;
		function set touchKeyboard(value:TouchKeyboard):void;
	}
}