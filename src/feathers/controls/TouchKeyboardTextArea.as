package feathers.controls
{
	import feathers.core.IFocusDisplayObject;
	import feathers.core.ITextEditor;
	import feathers.touchKeyboard.TouchKeyboard;

	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchKeyboardTextArea extends TextArea implements IFocusDisplayObject, ITouchKeyboardInput
	{
		private var _touchKeyboard:TouchKeyboard;
		public function get touchKeyboard():TouchKeyboard
		{
			return _touchKeyboard;
		}
		public function set touchKeyboard(value:TouchKeyboard):void
		{
			if (_touchKeyboard != null)
			{
				_touchKeyboard.removeEventListener(TouchEvent.TOUCH, touchKeyboard_touchHandler);
				_touchKeyboard.removeEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				_touchKeyboard.removeEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
			_maintainTouchFocus = false;
			_touchKeyboard = value;
			if (_touchKeyboard != null)
			{
				_touchKeyboard.addEventListener(TouchEvent.TOUCH, touchKeyboard_touchHandler);
				_touchKeyboard.addEventListener(KeyboardEvent.KEY_DOWN, touchKeyboard_keyDownHandler);
				_touchKeyboard.addEventListener(Event.REMOVED_FROM_STAGE, touchKeyboard_removedFromStageHandler);
			}
		}

		protected var _maintainTouchFocus:Boolean;
		override public function get maintainTouchFocus():Boolean
		{
			return _maintainTouchFocus;
		}

		public function TouchKeyboardTextArea()
		{
			textEditorFactory = function():ITextEditor
			{
				return new TouchKeyboardTextFieldTextEditorViewport;
			};
		}

		override public function get textEditorFactory():Function
		{
			return super.textEditorFactory;
		}

		override public function set textEditorFactory(value:Function):void
		{
			super.textEditorFactory = value;
		}

		protected function touchKeyboard_touchHandler(event:TouchEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			var touch:Touch = event.getTouch(_touchKeyboard);
			if (touch == null)
			{
				return;
			}
			if (touch.phase == TouchPhase.BEGAN)
			{
				_maintainTouchFocus = true;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				_maintainTouchFocus = false;
			}
		}

		protected function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!hasFocus)
			{
				return;
			}
			if (textEditorViewPort is ITouchKeyboardTextEditor)
			{
				(textEditorViewPort as ITouchKeyboardTextEditor).touchKeyboard_keyDownHandler(event);
			}
		}

		protected function touchKeyboard_removedFromStageHandler():void
		{
			clearFocus();
		}
	}
}