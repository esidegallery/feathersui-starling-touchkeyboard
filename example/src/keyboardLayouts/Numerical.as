package keyboardLayouts
{
	import feathers.touchKeyboard.data.IRenderableData;
	import feathers.touchKeyboard.data.KeyData;
	import feathers.touchKeyboard.data.KeyboardLayoutData;
	import feathers.touchKeyboard.data.RowData;
	import feathers.touchKeyboard.data.TouchKeyboardKeyCode;

	import flash.ui.Keyboard;

	import starling.textures.Texture;

	public class Numerical extends KeyboardLayoutData
	{
		public static const ID:String = "numerical";

		public function Numerical(backspaceIcon:Texture = null, backspaceDownIcon:Texture = null,
				returnIcon:Texture = null, returnDownIcon:Texture = null,
				closeKeyboardIcon:Texture = null, closeKeyboardDownIcon:Texture = null)
		{
			super(ID, new <RowData>[
						new RowData(new <IRenderableData>[
								KeyData.createCharacterKey("1".charCodeAt()),
								KeyData.createCharacterKey("2".charCodeAt()),
								KeyData.createCharacterKey("3".charCodeAt())
							]),
						new RowData(new <IRenderableData>[
								KeyData.createCharacterKey("4".charCodeAt()),
								KeyData.createCharacterKey("5".charCodeAt()),
								KeyData.createCharacterKey("6".charCodeAt())
							]),
						new RowData(new <IRenderableData>[
								KeyData.createCharacterKey("7".charCodeAt()),
								KeyData.createCharacterKey("8".charCodeAt()),
								KeyData.createCharacterKey("9".charCodeAt()),
							]),
						new RowData(new <IRenderableData>[
								KeyData.createNonCharacterKey(null, Keyboard.BACKSPACE, 1, true, backspaceIcon, backspaceDownIcon),
								KeyData.createCharacterKey("0".charCodeAt()),
								KeyData.createNonCharacterKey(null, TouchKeyboardKeyCode.CLOSE_KEYBOARD, 1, true, closeKeyboardIcon, closeKeyboardDownIcon)
							])
					]);
		}
	}
}