package feathers.touchKeyboard.data
{
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

	import mx.utils.StringUtil;

	import starling.textures.Texture;

	public class KeyData implements IRenderableData
	{
		public static function createCharacterKey(charCode:uint,
				caseSensitive:Boolean = false,
				upperCaseCharCode:uint = 0,
				widthInUnits:Number = 1,
				flexibleWidth:Boolean = false,
				iconTexture:Texture = null,
				downIconTexture:Texture = null,
				styleName:String = null,
				factoryID:String = null):KeyData
		{
			var kd:KeyData = new KeyData;
			kd.charCode = charCode;
			kd.caseSensitive = caseSensitive;
			kd.upperCaseCharCode = upperCaseCharCode;
			kd.widthInUnits = widthInUnits;
			kd.flexibleWidth = flexibleWidth;
			kd.iconTexture = iconTexture;
			kd.downIconTexture = downIconTexture;
			kd.styleName = styleName;
			kd.factoryID = factoryID;
			return kd;
		}

		public static function createNonCharacterKey(label:String,
				keyCode:uint,
				widthInUnits:Number,
				flexibleWidth:Boolean = false,
				iconTexture:Texture = null,
				downIconTexture:Texture = null,
				styleName:String = "touch-keyboard-alternate-key-style",
				factoryID:String = "touch-keyboard-alternate-key-id"):KeyData
		{
			var kd:KeyData = new KeyData;
			kd.customLabel = label;
			kd.keyCode = keyCode;
			kd.widthInUnits = widthInUnits;
			kd.flexibleWidth = flexibleWidth;
			kd.iconTexture = iconTexture;
			kd.downIconTexture = downIconTexture;
			kd.styleName = styleName;
			kd.factoryID = factoryID;
			return kd;
		}

		public static function createSpaceBar(widthInUnits:Number = 5,
				flexibleWidth:Boolean = false,
				label:String = null,
				iconTexture:Texture = null,
				downIconTexture:Texture = null,
				customStyleName:String = "touch-keyboard-space-bar-style",
				factoryID:String = null):KeyData
		{
			var kd:KeyData = new KeyData;
			kd.widthInUnits = widthInUnits;
			kd.flexibleWidth = flexibleWidth;
			kd.customLabel = label;
			kd.iconTexture = iconTexture;
			kd.downIconTexture = downIconTexture;
			kd.styleName = customStyleName;
			kd.factoryID = factoryID;
			kd.charCode = " ".charCodeAt();
			kd.keyCode = Keyboard.SPACE;
			return kd;
		}

		public static function createToggleKey(label:String,
				keyCode:uint,
				widthInUnits:Number = 1,
				flexibleWidth:Boolean = false,
				iconTexture:Texture = null,
				downIconTexture:Texture = null,
				selectedIconTexture:Texture = null,
				customStyleName:String = "touch-keyboard-alternate-key-style",
				factoryID:String = "touch-keyboard-alternate-key-id"):KeyData
		{
			var kd:KeyData = new KeyData;
			kd.customLabel = label;
			kd.keyCode = keyCode;
			kd.widthInUnits = widthInUnits;
			kd.flexibleWidth = flexibleWidth;
			kd.iconTexture = iconTexture;
			kd.downIconTexture = downIconTexture;
			kd.selectedIconTexture = selectedIconTexture;
			kd.styleName = customStyleName;
			kd.factoryID = factoryID;
			kd.isToggle = true;
			return kd;
		}

		public static function createSwitchLayoutKey(label:String,
				layoutID:String,
				widthInUnits:Number = 1.5,
				flexibleWidth:Boolean = false,
				iconTexture:Texture = null,
				downIconTexture:Texture = null,
				selectedIconTexture:Texture = null,
				customStyleName:String = "touch-keyboard-alternate-key-style",
				factoryID:String = "touch-keyboard-alternate-key-id"):KeyData
		{
			var kd:KeyData = new KeyData;
			kd.customLabel = label;
			kd.widthInUnits = widthInUnits;
			kd.flexibleWidth = flexibleWidth;
			kd.iconTexture = iconTexture;
			kd.downIconTexture = downIconTexture;
			kd.selectedIconTexture = selectedIconTexture;
			kd.styleName = customStyleName;
			kd.factoryID = factoryID;
			kd.keyCode = TouchKeyboardKeyCode.SWITCH_LAYOUT;
			kd.additionalData = layoutID;
			return kd;
		}

		public var charCode:uint;

		public var keyCode:uint;

		public var caseSensitive:Boolean;

		public var customLabel:String;

		public var upperCaseCharCode:uint;

		public var variantCharCodes:Vector.<uint>;

		public var styleName:String;

		public var isToggle:Boolean;

		public var iconTexture:Texture;
		public var downIconTexture:Texture;
		public var selectedIconTexture:Texture;

		public var keyLocation:int = KeyLocation.STANDARD;

		public var additionalData:Object;

		protected var _factoryID:String;
		public function get factoryID():String
		{
			return _factoryID;
		}
		public function set factoryID(value:String):void
		{
			_factoryID = value;
		}

		protected var _widthInUnits:Number;
		public function get widthInUnits():Number
		{
			return _widthInUnits;
		}
		public function set widthInUnits(value:Number):void
		{
			_widthInUnits = value;
		}

		protected var _flexibleWidth:Boolean;
		public function get flexibleWidth():Boolean
		{
			return _flexibleWidth;
		}
		public function set flexibleWidth(value:Boolean):void
		{
			_flexibleWidth = value;
		}

		public function toString():String
		{
			return StringUtil.substitute("[KeyData(charCode={0}, widthInUnits={1}, isFlexible={2})]", charCode, _widthInUnits, _flexibleWidth);
		}
	}
}