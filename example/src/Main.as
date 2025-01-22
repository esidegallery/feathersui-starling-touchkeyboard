package
{
	import feathers.controls.ButtonState;
	import feathers.controls.LayoutGroup;
	import feathers.controls.TouchKeyboardTextInput;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.Application;
	import feathers.core.ITextRenderer;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.ImageSkin;
	import feathers.text.BitmapFontTextFormat;
	import feathers.themes.TopcoatLightMobileTheme;
	import feathers.touchKeyboard.KeyRenderer;
	import feathers.touchKeyboard.TouchKeyboard;
	import feathers.touchKeyboard.data.KeyboardLayoutData;
	import feathers.touchKeyboard.events.TouchKeyboardEventType;

	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;

	import keyboardLayouts.Numerical;
	import keyboardLayouts.Qwerty;

	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Color;

	public class Main extends Application
	{
		[Embed("assets/theme.png")]
		private static const ATLAS_BITMAP:Class;
		
		[Embed("assets/theme.xml", mimeType="application/octet-stream")]
		private static const ATLAS_XML:Class;

		[Embed(source="assets/OpenSans-Regular.fnt", mimeType="application/octet-stream")]
		public static const FONT_XML:Class;
		
		protected var atlas:TextureAtlas;

		protected var font:BitmapFont;
	
		protected var textInputGroup:LayoutGroup;
		protected var textInput:TouchKeyboardTextInput;
		protected var touchKeyboard:TouchKeyboard;
		protected var touchKeyboardTweenID:int;

		private var _showKeyboard:Boolean;
		public function get showKeyboard():Boolean
		{
			return _showKeyboard;
		}
		public function set showKeyboard(value:Boolean):void
		{
			if (_showKeyboard != value)
			{
				_showKeyboard = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		public function Main()
		{
			new TopcoatLightMobileTheme;
			Starling.current.showStats = true;
			super();
		}

		override protected function initialize():void
		{
			layout = new AnchorLayout;

			var atlasTexture:Texture = Texture.fromEmbeddedAsset(ATLAS_BITMAP);
			var atlasXML:XML = XML(new ATLAS_XML);
			atlas = new TextureAtlas(atlasTexture, atlasXML);

			var fontTexture:Texture = atlas.getTexture("OpenSans-Regular");
			var fontXML:XML = XML(new FONT_XML);
			font = new BitmapFont(fontTexture, fontXML);

			textInputGroup = new LayoutGroup;
			textInputGroup.layout = new AnchorLayout;
			textInputGroup.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			addChild(textInputGroup);

			textInput = new TouchKeyboardTextInput;
			textInput.setSize(500, 64);
			textInput.fontStyles = new TextFormat("_sans", 40, Color.BLACK, Align.LEFT);

			textInput.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			textInputGroup.addChild(textInput);

			textInput.addEventListener(FeathersEventType.FOCUS_IN, function():void
			{
				showKeyboard = true;
			});
			textInput.addEventListener(FeathersEventType.FOCUS_OUT, function():void
			{
				showKeyboard = false;
			});

			super.initialize();
		}

		override protected function draw():void
		{
			_ignoreChildChangesButSetFlags = true;

			var stateInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			if (stateInvalid)
			{
				commitState();
			}

			super.draw();
		}

		private function commitState():void
		{
			if (touchKeyboardTweenID > 0)
			{
				Starling.juggler.removeByID(touchKeyboardTweenID);
				touchKeyboardTweenID = 0;
			}
			if (_showKeyboard)
			{
				createTouchKeyboard();
				touchKeyboard.addEventListener(FeathersEventType.CREATION_COMPLETE, function():void
				{
					setTimeout(openTouchKeyboard, 100);
				});
				touchKeyboard.validate();
			}
			else
			{	
				closeTouchKeyboard();
			}
		}

		protected function createTouchKeyboard():void
		{
			if (touchKeyboard != null)
			{
				return;
			}

			touchKeyboard = new TouchKeyboard;

			var keyLabelFactory:Function = function():ITextRenderer
			{
				var bftr:BitmapFontTextRenderer = new BitmapFontTextRenderer;
				bftr.useSeparateBatch = false;
				bftr.textFormat = new BitmapFontTextFormat(font, 28, Color.WHITE, TextFormatAlign.CENTER);
				return bftr;
			};

			touchKeyboard.keyRendererFactory = function():IListItemRenderer
			{
				var renderer:KeyRenderer = new KeyRenderer;

				renderer.labelFactory = keyLabelFactory;

				var skin:ImageSkin = new ImageSkin(atlas.getTexture("light-key"));
				skin.setTextureForState(ButtonState.DOWN, atlas.getTexture("dark-key"));
				skin.scale9Grid = new Rectangle(8, 8, 1, 1);
				skin.pixelSnapping = true;
				renderer.defaultSkin = skin;

				return renderer;
			}

			touchKeyboard.setKeyRendererFactoryWithID(TouchKeyboard.FACTORY_ID_ALTERNATE_KEY, function():IListItemRenderer
			{
				var renderer:KeyRenderer = new KeyRenderer;

				var skin:ImageSkin = new ImageSkin(atlas.getTexture("dark-key"));
				skin.selectedTexture = atlas.getTexture("light-key");
				skin.setTextureForState(ButtonState.DOWN, atlas.getTexture("down-key"));
				skin.setTextureForState(ButtonState.DOWN_AND_SELECTED, atlas.getTexture("down-key"));
				skin.scale9Grid = new Rectangle(8, 8, 1, 1);
				skin.pixelSnapping = true;
				renderer.defaultSkin = skin;

				renderer.labelFactory = keyLabelFactory;

				return renderer;
			});

			touchKeyboard.backgroundSkin = new Image(atlas.getTexture("background"));
			touchKeyboard.minimumKeyUnitSize = 75;

			touchKeyboard.layouts = new <KeyboardLayoutData>[
				new Qwerty(
					atlas.getTexture("backspace"), atlas.getTexture("backspace-down"), 
					atlas.getTexture("shift"), atlas.getTexture("shift-down"), atlas.getTexture("shift-down"), 
					atlas.getTexture("return"), null,
					atlas.getTexture("close-keyboard")
				),
				new Numerical(
					atlas.getTexture("backspace"), atlas.getTexture("backspace-down"), 
					atlas.getTexture("shift"), atlas.getTexture("shift-down"), atlas.getTexture("shift-down"), 
					atlas.getTexture("return"), null,
					atlas.getTexture("close-keyboard")
				),
			];

			textInput.touchKeyboard = touchKeyboard;

			touchKeyboard.addEventListener(TouchKeyboardEventType.CLOSE_REQUESTED, closeTouchKeyboard);
			touchKeyboard.layoutData = new AnchorLayoutData(this.height, 0, NaN, 0);
			touchKeyboard.paddingLeft = 50;
			touchKeyboard.paddingRight = 50;
			touchKeyboard.paddingTop = 20;
			touchKeyboard.paddingBottom = 20;
			(textInputGroup.layoutData as AnchorLayoutData).bottomAnchorDisplayObject = touchKeyboard;
			addChild(touchKeyboard);
		}

		protected function destroyTouchKeyboard():void
		{
			if (touchKeyboard != null)
			{
				touchKeyboard.removeFromParent(true);
				touchKeyboard = null;
				textInput.touchKeyboard = null;
				(textInputGroup.layoutData as AnchorLayoutData).bottomAnchorDisplayObject = null;
			}
		}

		protected function openTouchKeyboard():void
		{
			var ald:AnchorLayoutData = touchKeyboard.layoutData as AnchorLayoutData;
			var topTo:Number = height - touchKeyboard.height;
			if (ald.top > topTo)
			{
				Starling.juggler.tween(ald, 0.4, {
					top: topTo,
					transition: Transitions.EASE_OUT
				});
			}
		}

		protected function closeTouchKeyboard():void
		{
			if (touchKeyboard)
			{
				var ald:AnchorLayoutData = touchKeyboard.layoutData as AnchorLayoutData;
				Starling.juggler.tween(ald, 0.4, {
					top: this.height,
					transition: Transitions.EASE_OUT,
					onComplete: function():void
					{
						destroyTouchKeyboard();
					}
				});
			}
		}
	}
}