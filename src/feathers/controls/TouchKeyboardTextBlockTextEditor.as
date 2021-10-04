package feathers.controls
{
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.touchKeyboard.KeyRenderer;
	import feathers.touchKeyboard.TouchKeyboard;

	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	public class TouchKeyboardTextBlockTextEditor extends TextBlockTextEditor implements ITouchKeyboardTextEditor
	{
		public function touchKeyboard_keyboardEventHandler(event:KeyboardEvent):void
		{
			if (event == null || event.type != KeyboardEvent.KEY_DOWN)
			{
				return;
			}
			stage_keyDownHandler(event);
			if (event.ctrlKey || event.altKey)
			{
				return;
			}
			if (event.charCode > 0)
			{
				var char:String = String.fromCharCode(event.charCode);
				nativeFocus_textInputHandler(new TextEvent(TextEvent.TEXT_INPUT, false, true, char));
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				nativeFocus_textInputHandler(new TextEvent(TextEvent.TEXT_INPUT, false, true, "\n"));
			}
		}

		override protected function stage_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.stage, TouchPhase.BEGAN);
			if (!touch)
			{
				// Only interested in BEGAN:
				return;
			}
			var point:Point = touch.getLocation(this.stage, Pool.getPoint());
			var hitTestResult:DisplayObject = stage.hitTest(point);
			Pool.putPoint(point);
			if (hitTestResult is KeyRenderer || hitTestResult is TouchKeyboard)
			{
				// If the touch is on a TouchKeyboard or one of its KeyRenderers, maintain focus:
				stage.starling.nativeStage.focus = this._nativeFocus;
				return;
			}
			super.stage_touchHandler(event);
		}
	}
}