package feathers.touchKeyboard
{
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.controls.List;
	import feathers.controls.ToggleButton;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.skins.IStyleProvider;
	import feathers.skins.ImageSkin;
	import feathers.touchKeyboard.data.KeyData;
	import feathers.utils.touch.TouchToSelect;

	import flash.geom.Point;

	import starling.display.DisplayObject;

	public class KeyRenderer extends BaseDefaultItemRenderer implements IKeyRenderer
	{
		public static var globalStyleProvider:IStyleProvider;
		
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if (KeyRenderer.globalStyleProvider)
			{
				return KeyRenderer.globalStyleProvider;
			}
			if (ToggleButton.globalStyleProvider)
			{
				return ToggleButton.globalStyleProvider;
			}
			return Button.globalStyleProvider;
		}

		protected var _index:int = -1;
        public function get index():int
        {
            return _index;
        }
        public function set index(value:int):void
        {
            _index = value;
        }

        public function get owner():List
        {
            return List(_owner);
        }
        public function set owner(value:List):void
        {
            _owner = value;
        }

		public function get keyData():KeyData
		{
			return _data as KeyData;
		}

		override public function hitTest(localPoint:Point):DisplayObject
		{
			if(!this.visible || !this.touchable)
			{
				return null;
			}
			if(this.mask && !this.hitTestMask(localPoint))
			{
				return null;
			}
			return this._hitArea.containsPoint(localPoint) ? this : null;
		}

		override protected function initialize():void
		{
			_itemHasIcon = false;
			_useStateDelayTimer = false;
			_isFocusEnabled = false;
			_isChildFocusEnabled = false;

			tapToSelect = new TouchToSelect(this, true, true);

			labelFunction = function(data:KeyData):String
			{
				var touchKeyboard:TouchKeyboard = _owner as TouchKeyboard;
				var shift:Boolean = touchKeyboard && touchKeyboard.shift;
				var caps:Boolean = touchKeyboard && touchKeyboard.capsLock != touchKeyboard.shift;

				if (shift && data.upperCaseCharCode > 0)
				{
					return String.fromCharCode(data.upperCaseCharCode);
				}
				if (data.customLabel !== null)
				{
					if (data.caseSensitive)
					{
						return caps ? data.customLabel.toLocaleUpperCase() : data.customLabel.toLocaleLowerCase();
					}
					return data.customLabel;
				}
				if (data.charCode > 0)
				{
					var char:String = String.fromCharCode(data.charCode);
					if (data.caseSensitive)
					{
						return caps ? char.toLocaleUpperCase() : char.toLocaleLowerCase();
					}
					return char;
				}
				if (shift && data.upperCaseCharCode > 0)
				{
					return String.fromCharCode(data.upperCaseCharCode);
				}
				return null;
			};

			super.initialize();
		}

		override protected function commitData():void
		{
			setInvalidationFlag(INVALIDATION_FLAG_LAYOUT);

			var keyData:KeyData = data as KeyData;

			var hasIcons:Boolean = keyData && (keyData.iconTexture !== null || keyData.downIconTexture !== null || keyData.selectedIconTexture !== null);

			// Clear the icon (ignoring restriction) so that the style-provider can set it:
			ignoreNextStyleRestriction();
			defaultIcon = null;

			if (keyData)
			{
				styleName = keyData.styleName || "";
				isToggle = keyData.isToggle;

				isLongPressEnabled = keyData.variantCharCodes && keyData.variantCharCodes.length > 0;
			}

			// Override the icon if any of the icon-related properties have been set:
			if (hasIcons)
			{
				ignoreNextStyleRestriction();
				var iconSkin:ImageSkin = new ImageSkin(keyData.iconTexture);
				iconSkin.setTextureForState(ButtonState.DOWN, keyData.downIconTexture);
				iconSkin.setTextureForState(ButtonState.DOWN_AND_SELECTED, keyData.downIconTexture);
				iconSkin.selectedTexture = keyData.selectedIconTexture;
				defaultIcon = iconSkin;
			}

			super.commitData();
		}

		override public function dispose():void
		{
			owner = null;
			super.dispose();
		}
	}
}