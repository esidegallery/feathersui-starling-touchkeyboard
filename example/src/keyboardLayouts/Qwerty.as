package keyboardLayouts
{
	import feathers.layout.HorizontalAlign;
	import feathers.touchKeyboard.data.GapData;
	import feathers.touchKeyboard.data.IRenderableData;
	import feathers.touchKeyboard.data.KeyData;
	import feathers.touchKeyboard.data.KeyboardLayoutData;
	import feathers.touchKeyboard.data.RowData;
	import feathers.touchKeyboard.data.TouchKeyboardKeyCode;

	import flash.ui.Keyboard;

	import starling.textures.Texture;

	public class Qwerty extends KeyboardLayoutData
	{
		public static const ID:String = "qwerty";

		public function Qwerty(backspaceIcon:Texture = null, backspaceDownIcon:Texture = null, 
							   shiftIcon:Texture = null, shiftDownIcon:Texture = null, shiftSelectedIcon:Texture = null,
							   returnIcon:Texture = null, returnDownIcon:Texture = null,
							   closeKeyboardIcon:Texture = null, closeKeyboardDownIcon:Texture = null)
		{
			super(ID, new <RowData>[
				new RowData(new <IRenderableData>[
					KeyData.createCharacterKey("Q".charCodeAt(), true),
					KeyData.createCharacterKey("W".charCodeAt(), true),
					KeyData.createCharacterKey("E".charCodeAt(), true),
					KeyData.createCharacterKey("R".charCodeAt(), true),
					KeyData.createCharacterKey("T".charCodeAt(), true),
					KeyData.createCharacterKey("Y".charCodeAt(), true),
					KeyData.createCharacterKey("U".charCodeAt(), true),
					KeyData.createCharacterKey("I".charCodeAt(), true),
					KeyData.createCharacterKey("O".charCodeAt(), true),
					KeyData.createCharacterKey("P".charCodeAt(), true),
					KeyData.createNonCharacterKey(null, Keyboard.BACKSPACE, 1.25, true, backspaceIcon, backspaceDownIcon)
				]),
				new RowData(new <IRenderableData>[
					new GapData(0, true),
					KeyData.createCharacterKey("A".charCodeAt(), true),
					KeyData.createCharacterKey("S".charCodeAt(), true),
					KeyData.createCharacterKey("D".charCodeAt(), true),
					KeyData.createCharacterKey("F".charCodeAt(), true),
					KeyData.createCharacterKey("G".charCodeAt(), true),
					KeyData.createCharacterKey("H".charCodeAt(), true),
					KeyData.createCharacterKey("J".charCodeAt(), true),
					KeyData.createCharacterKey("K".charCodeAt(), true),
					KeyData.createCharacterKey("L".charCodeAt(), true),
					KeyData.createNonCharacterKey(null, Keyboard.ENTER, 1.75, false, returnIcon, returnDownIcon)
				], 1, HorizontalAlign.RIGHT),
				new RowData(new <IRenderableData>[
					KeyData.createToggleKey(null, Keyboard.SHIFT, 1, false, shiftIcon, shiftDownIcon, shiftSelectedIcon),
					new GapData(),
					KeyData.createCharacterKey("Z".charCodeAt(), true),
					KeyData.createCharacterKey("X".charCodeAt(), true),
					KeyData.createCharacterKey("C".charCodeAt(), true),
					KeyData.createCharacterKey("V".charCodeAt(), true),
					KeyData.createCharacterKey("B".charCodeAt(), true),
					KeyData.createCharacterKey("N".charCodeAt(), true),
					KeyData.createCharacterKey("M".charCodeAt(), true),
					KeyData.createCharacterKey(",".charCodeAt(), false, ":".charCodeAt()),
					new GapData(),
					KeyData.createToggleKey(null, Keyboard.SHIFT, 1.5, true, shiftIcon, shiftDownIcon, shiftSelectedIcon)
				]),
				new RowData(new <IRenderableData>[
					KeyData.createSwitchLayoutKey("&123", Numerical.ID, 1.5),
					KeyData.createCharacterKey("-".charCodeAt(), false, "_".charCodeAt()),
					KeyData.createSpaceBar(5, true),
					KeyData.createCharacterKey(".".charCodeAt(), false, "@".charCodeAt()),
					KeyData.createCharacterKey("?".charCodeAt(), false, "!".charCodeAt()),
					KeyData.createNonCharacterKey(null, TouchKeyboardKeyCode.CLOSE_KEYBOARD, 1.5, false, closeKeyboardIcon, closeKeyboardDownIcon)
				])
			]);
		}
	}
}