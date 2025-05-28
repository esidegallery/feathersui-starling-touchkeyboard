package feathers.controls.text
{
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.touchKeyboard.ITouchKeyboardInput;
	import feathers.utils.text.TextInputRestrict;

	import flash.ui.Keyboard;

	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextFieldTextEditorViewport extends TextFieldTextEditorViewPort implements ITouchKeyboardInput
	{
		protected var textInputRestrict:TextInputRestrict;

		override public function set restrict(value:String):void
		{
			super.restrict = value;
			if (textInputRestrict == null)
			{
				textInputRestrict = new TextInputRestrict;
			}
			textInputRestrict.restrict = value;
		}

		public function get touchKeyboardLayoutID():String
		{
			// Not implemented in TextEditors.
			return null;
		}

		public function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (!_isEnabled || !_isEditable ||
					event.ctrlKey || event.altKey || event.isDefaultPrevented() ||
					textField == null)
			{
				return;
			}

			var newIndex:int = -1;
			var charCode:uint = event.charCode;
			var currentValue:String = text;
			if (event.keyCode == Keyboard.DELETE)
			{
				if (textField.selectionBeginIndex != textField.selectionEndIndex)
				{
					deleteSelectedText();
				}
				else if (textField.selectionEndIndex < currentValue.length)
				{
					text = currentValue.substr(0, textField.selectionBeginIndex) + currentValue.substr(textField.selectionEndIndex + 1);
				}
			}
			else if (event.keyCode == Keyboard.BACKSPACE)
			{
				if (textField.selectionBeginIndex != textField.selectionEndIndex)
				{
					deleteSelectedText();
				}
				else if (textField.selectionBeginIndex > 0)
				{
					newIndex = textField.selectionBeginIndex - 1;
					text = currentValue.substr(0, textField.selectionBeginIndex - 1) + currentValue.substr(textField.selectionEndIndex);

				}
			}
			else if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.NUMPAD_ENTER)
			{
				replaceSelectedText("\n");
			}
			else if (charCode > 0 && (textInputRestrict == null || textInputRestrict.isCharacterAllowed(charCode)))
			{
				replaceSelectedText(String.fromCharCode(event.charCode));
			}

			if (newIndex >= 0)
			{
				validate();
				selectRange(newIndex, newIndex);
			}
		}

		protected function deleteSelectedText():void
		{
			var currentValue:String = text;
			text = currentValue.substr(0, textField.selectionBeginIndex) + currentValue.substr(textField.selectionEndIndex);
			validate();
			selectRange(textField.selectionBeginIndex, textField.selectionBeginIndex);
		}

		protected function replaceSelectedText(withText:String):void
		{
			var currentValue:String = text;
			var newText:String = currentValue.substr(0, textField.selectionBeginIndex) + withText + currentValue.substr(textField.selectionEndIndex);
			if (_maxChars > 0 && newText.length > _maxChars)
			{
				return;
			}
			text = newText;
			validate();
			var selectionIndex:int = textField.selectionBeginIndex + withText.length;
			selectRange(selectionIndex, selectionIndex);
		}
	}
}