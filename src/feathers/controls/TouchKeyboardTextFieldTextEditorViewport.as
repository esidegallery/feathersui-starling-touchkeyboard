package feathers.controls
{
	import feathers.controls.text.TextFieldTextEditorViewPort;

	import flash.ui.Keyboard;

	import starling.events.KeyboardEvent;

	public class TouchKeyboardTextFieldTextEditorViewport extends TextFieldTextEditorViewPort implements ITouchKeyboardTextInput
	{
		public function touchKeyboard_keyDownHandler(event:KeyboardEvent):void
		{
			if (event == null || textField == null)
			{
				return;
			}
			if (event.ctrlKey || event.altKey)
			{
				return;
			}

			var newIndex:int = -1;
			if (event.charCode > 0)
			{
				var char:String = String.fromCharCode(event.charCode);
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				char = "\n";
			}
			else if (event.keyCode == Keyboard.BACKSPACE)
			{
				if (textField.selectionBeginIndex != textField.selectionEndIndex)
				{
					// NOT RIGHT
					char = "";
					newIndex = Math.min(textField.selectionBeginIndex, textField.selectionEndIndex);
				}
				else if (textField.selectionBeginIndex > 0)
				{
					newIndex = textField.selectionBeginIndex - 1;
					var currentText:String = textField.text;
					text = currentText.substr(0, selectionBeginIndex - 1) + currentText.substr(selectionEndIndex);
				}
			}

			if (char != null)
			{
				textField.replaceText(textField.selectionBeginIndex, textField.selectionEndIndex, char);
			}
			if (newIndex >= 0)
			{
				validate();
				textField.setSelection(newIndex, newIndex);
			}
		}
	}
}