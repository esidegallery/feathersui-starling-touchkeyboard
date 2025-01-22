package keyboardLayouts
{
	import feathers.touchKeyboard.data.GapData;
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
				shiftIcon:Texture = null, shiftDownIcon:Texture = null, shiftSelectedIcon:Texture = null,
				returnIcon:Texture = null, returnDownIcon:Texture = null,
				closeKeyboardIcon:Texture = null, closeKeyboardDownIcon:Texture = null)
		{
			super(ID, new <RowData>[
						new RowData(new <IRenderableData>[
								KeyData.createCharacterKey("1".charCodeAt(), false, "[".charCodeAt()),
								KeyData.createCharacterKey("2".charCodeAt(), false, "]".charCodeAt()),
								KeyData.createCharacterKey("3".charCodeAt(), false, "{".charCodeAt()),
								KeyData.createCharacterKey("4".charCodeAt(), false, "}".charCodeAt()),
								KeyData.createCharacterKey("5".charCodeAt(), false, "#".charCodeAt()),
								KeyData.createCharacterKey("6".charCodeAt(), false, "%".charCodeAt()),
								KeyData.createCharacterKey("7".charCodeAt(), false, "^".charCodeAt()),
								KeyData.createCharacterKey("8".charCodeAt(), false, "*".charCodeAt()),
								KeyData.createCharacterKey("9".charCodeAt(), false, "+".charCodeAt()),
								KeyData.createCharacterKey("0".charCodeAt(), false, "=".charCodeAt()),
								KeyData.createNonCharacterKey(null, Keyboard.BACKSPACE, 1.25, true, backspaceIcon, backspaceDownIcon)
							]),
						new RowData(new <IRenderableData>[
								new GapData(0, true),
								KeyData.createCharacterKey("/".charCodeAt(), false, "\\".charCodeAt()),
								KeyData.createCharacterKey(":".charCodeAt(), false, "|".charCodeAt()),
								KeyData.createCharacterKey(";".charCodeAt(), false, "~".charCodeAt()),
								KeyData.createCharacterKey("(".charCodeAt(), false, "<".charCodeAt()),
								KeyData.createCharacterKey(")".charCodeAt(), false, ">".charCodeAt()),
								KeyData.createCharacterKey("£".charCodeAt(), false, "$".charCodeAt()),
								KeyData.createCharacterKey("&".charCodeAt(), false, "€".charCodeAt()),
								KeyData.createCharacterKey("@".charCodeAt(), false, "¥".charCodeAt()),
								KeyData.createNonCharacterKey(null, Keyboard.ENTER, 2.1, false, returnIcon, returnDownIcon)
							]),
						new RowData(new <IRenderableData>[
								KeyData.createToggleKey(null, Keyboard.SHIFT, 1, true, shiftIcon, shiftDownIcon, shiftSelectedIcon),
								KeyData.createCharacterKey("-".charCodeAt()),
								KeyData.createCharacterKey("_".charCodeAt()),
								KeyData.createCharacterKey("?".charCodeAt()),
								KeyData.createCharacterKey("!".charCodeAt()),
								KeyData.createCharacterKey("'".charCodeAt()),
								KeyData.createCharacterKey("\"".charCodeAt()),
								KeyData.createCharacterKey(",".charCodeAt()),
								KeyData.createCharacterKey(".".charCodeAt()),
								KeyData.createToggleKey(null, Keyboard.SHIFT, 1, false, shiftIcon, shiftDownIcon, shiftSelectedIcon)
							]),
						new RowData(new <IRenderableData>[
								KeyData.createSwitchLayoutKey("ABC", Qwerty.ID, 1.75),
								new GapData,
								KeyData.createSpaceBar(5, true),
								new GapData,
								KeyData.createNonCharacterKey(null, TouchKeyboardKeyCode.CLOSE_KEYBOARD, 1.75, false, closeKeyboardIcon, closeKeyboardDownIcon)
							])
					]);
		}
	}
}