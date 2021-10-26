package feathers.touchKeyboard
{
	import feathers.controls.List;
	import feathers.controls.ScrollInteractionMode;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.ToggleButton;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.IListCollection;
	import feathers.data.VectorCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.ILayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;
	import feathers.touchKeyboard.data.IRenderableData;
	import feathers.touchKeyboard.data.KeyData;
	import feathers.touchKeyboard.data.KeyboardLayoutData;
	import feathers.touchKeyboard.data.RowData;
	import feathers.touchKeyboard.data.TouchKeyboardKeyCode;
	import feathers.touchKeyboard.events.TouchKeyboardEventType;

	import flash.geom.Point;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	[Event(name="modifierChange", type="starling.events.Event")]
	[Event(name="layoutChange", type="starling.events.Event")]

	public class TouchKeyboard extends List
	{
		public static const FACTORY_ID_GAP:String = "touch-keyboard-gap-id";
		public static const FACTORY_ID_ALTERNATE_KEY:String = "touch-keyboard-alternate-key-id";

		public static const STYLE_NAME_ALTERNATE_KEY:String = "touch-keyboard-alternate-key-style";
		public static const STYLE_NAME_SPACE_BAR:String = "touch-keyboard-space-bar-style";
		public static const STYLE_NAME_BACKSPACE_KEY:String = "touch-keyboard-backspace-key-style";
		public static const STYLE_NAME_RETURN_KEY:String = "touch-keyboard-return-key-style";
		public static const STYLE_NAME_SHIFT_KEY:String = "touch-keyboard-shift-key-style";
		public static const STYLE_NAME_CAPS_LOCK_KEY:String = "touch-keyboard-caps-lock-key-style";
		public static const STYLE_NAME_TAB_KEY:String = "touch-keyboard-tab-key-style";
		public static const STYLE_NAME_LEFT_ARROW_KEY:String = "touch-keyboard-left-arrow-key-style";
		public static const STYLE_NAME_UP_ARROW_KEY:String = "touch-keyboard-up-arrow-key-style";
		public static const STYLE_NAME_RIGHT_ARROW_KEY:String = "touch-keyboard-right-arrow-key-style";
		public static const STYLE_NAME_DOWN_ARROW_KEY:String = "touch-keyboard-down-arrow-key-style";
		public static const STYLE_NAME_HIDE_KEYBOARD_KEY:String = "touch-keyboard-hide-keyboard-key-style";
		
		protected static const INVALIDATION_FLAG_MODIFIERS:String = "modifiers";

		public static var globalStyleProvider:IStyleProvider;

		private var _isDisposing:Boolean;
		
		override protected function get defaultStyleProvider():IStyleProvider
		{
            return TouchKeyboard.globalStyleProvider;
		}

		private var _snapToPixels:Boolean = true;
		public function get snapToPixels():Boolean
		{
			return _snapToPixels;
		}
		public function set snapToPixels(value:Boolean):void
		{
			if (_snapToPixels == value)
			{
				return;
			}
			_snapToPixels = value;
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/** @private */
		private var _horizontalGapInUnits:Number = 0.1;
		/**
		 * The horizontal gap between keys in key size units.
		 */
		public function get horizontalGapInUnits():Number
		{
			return _horizontalGapInUnits;
		}
		/** @private */
		public function set horizontalGapInUnits(value:Number):void
		{
			if (_horizontalGapInUnits == value)
			{
				return;
			}
			_horizontalGapInUnits = value;
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/** @private */
		private var _verticalGapInUnits:Number = 0.1;
		/**
		 * The vertical gap between rows in key size units.
		 */
		public function get verticalGapInUnits():Number
		{
			return _verticalGapInUnits;
		}
		/** @private */
		public function set verticalGapInUnits(value:Number):void
		{
			if (_verticalGapInUnits == value)
			{
				return;
			}
			_verticalGapInUnits = value;
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/** @private */
		private var _minimumKeyUnitSize:Number = 50;
		/**
		 * The minimum size of a key unit. All rows, keys and gaps are sized based on a key unit size.
		 */
		public function get minimumKeyUnitSize():Number
		{
			return _minimumKeyUnitSize;
		}
		/** @private */
		public function set minimumKeyUnitSize(value:Number):void
		{
			if (_minimumKeyUnitSize == value)
			{
				return;
			}
			_minimumKeyUnitSize = value;
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		/** @private */
		private var _maximumKeyUnitSize:Number = NaN;
		/**
		 * The maximum size of a key unit. All rows, keys and gaps are sized based on a key unit size.
		 */
		public function get maximumKeyUnitSize():Number
		{
			return _maximumKeyUnitSize;
		}
		/** @private */
		public function set maximumKeyUnitSize(value:Number):void
		{
			if (_maximumKeyUnitSize == value)
			{
				return;
			}
			_maximumKeyUnitSize = value;
			invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		private var _shift:Boolean;
		public function get shift():Boolean
		{
			return _shift;
		}
		public function set shift(value:Boolean):void
		{
			if (_shift == value)
			{
				return;
			}
			_shift = value;
			if (_shift)
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SHIFT, KeyLocation.STANDARD);
			}
			else
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SHIFT, KeyLocation.STANDARD);
			}
			invalidate(INVALIDATION_FLAG_MODIFIERS);
		}

		private var _alt:Boolean;
		public function get alt():Boolean
		{
			return _alt;
		}
		public function set alt(value:Boolean):void
		{
			if (_alt == value)
			{
				return;
			}
			_alt = value;
			if (_alt)
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.ALTERNATE, KeyLocation.STANDARD);
			}
			else
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.ALTERNATE, KeyLocation.STANDARD);
			}
			invalidate(INVALIDATION_FLAG_MODIFIERS);
		}
		
		private var _ctrl:Boolean;
		public function get ctrl():Boolean
		{
			return _ctrl;
		}
		public function set ctrl(value:Boolean):void
		{
			if (_ctrl == value)
			{
				return;
			}
			_ctrl = value;
			if (_ctrl)
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.CONTROL, KeyLocation.STANDARD);
			}
			else
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.CONTROL, KeyLocation.STANDARD);
			}
			invalidate(INVALIDATION_FLAG_MODIFIERS);
		}
		
		private var _command:Boolean;
		public function get command():Boolean
		{
			return _command;
		}
		public function set command(value:Boolean):void
		{
			if (_command == value)
			{
				return;
			}
			_command = value;
			if (_command)
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.COMMAND, KeyLocation.STANDARD);
			}
			else
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.COMMAND, KeyLocation.STANDARD);
			}
			invalidate(INVALIDATION_FLAG_MODIFIERS);
		}

		private var _capsLock:Boolean;
		public function get capsLock():Boolean
		{
			return _capsLock;
		}
		public function set capsLock(value:Boolean):void
		{
			if (_capsLock == value)
			{
				return;
			}
			_capsLock = value;
			if (_capsLock)
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.CAPS_LOCK, KeyLocation.STANDARD);
			}
			else
			{
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.CAPS_LOCK, KeyLocation.STANDARD);
			}
			invalidate(INVALIDATION_FLAG_MODIFIERS);
		}

		protected var _layouts:Vector.<KeyboardLayoutData>;
		public function get layouts():Vector.<KeyboardLayoutData>
		{
			return _layouts;
		}
		public function set layouts(value:Vector.<KeyboardLayoutData>):void
		{
			if (_layouts === value)
			{
				return;
			}
			_layouts = value;
			if (_layouts && _layouts.length)
			{
				selectedLayoutIndex = 0;
			}
			else
			{
				_selectedLayoutIndex = -1;
				super.dataProvider = null;
			}
		}

		protected var _selectedLayoutIndex:int = -1;
		public function get selectedLayoutIndex():int
		{
			return _selectedLayoutIndex;
		}
		public function set selectedLayoutIndex(value:int):void
		{
			if (_selectedLayoutIndex == value)
			{
				return;
			}
			_selectedLayoutIndex = value;
			super.dataProvider = new VectorCollection(_layouts[_selectedLayoutIndex].rows);
		}

		public function get selectedLayoutID():String
		{
			if (_selectedLayoutIndex == -1)
			{
				return null;
			}
			return _layouts[_selectedLayoutIndex].id;
		}
		public function set selectedLayoutID(value:String):void
		{
			if (_layouts == null || _layouts.length == 0)
			{
				return;
			}
			for (var i:int = 0, l:int = layouts.length; i < l; i++)
			{
				if (layouts[i].id == value)
				{
					selectedLayoutIndex = i;
					return;
				}
			}
			selectedLayoutIndex = 0;
		}

		private var _keyRendererType:Class = KeyRenderer;
		public function get keyRendererType():Class
		{
			return _keyRendererType;
		}
		public function set keyRendererType(value:Class):void
		{
			if (_keyRendererType == value)
			{
				return;
			}

			_keyRendererType = value;
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _keyRendererFactory:Function;
		public function get keyRendererFactory():Function
		{
			return _keyRendererFactory;
		}
		public function set keyRendererFactory(value:Function):void
		{
			if (_keyRendererFactory === value)
			{
				return;
			}

			_keyRendererFactory = value;
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		public function setKeyRendererFactoryWithID(id:String, factory:Function):void
		{
			if (id === null)
			{
				keyRendererFactory = factory;
				return;
			}
			if (_keyRendererFactories === null)
			{
				_keyRendererFactories = {};
			}
			if (factory !== null)
			{
				_keyRendererFactories[id] = factory;
			}
			else
			{
				delete _keyRendererFactories[id];
			}
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _keyRendererFactories:Object = {
			"touch-keyboard-gap-id": function():IListItemRenderer
            {
                return new GapRenderer;
            }
		};

		protected var _rowRenderers:Dictionary;
		protected var _keyRenderers:Dictionary;

		override public function set dataProvider(value:IListCollection):void
		{
			if (_isDisposing && value === null) // This is reset by the superclass on dispose:
			{
				super.dataProvider = null;
				return;
			}
			throw new Error("TouchKeyboard.dataProvider cannot be set directly, use layouts property instead")
		}

		override public function set layout(value:ILayout):void
		{
			if (_isDisposing && value === null) // This is reset by the superclass on dispose:
			{
				super.dataProvider = null;
				return;
			}
			throw new Error("TouchKeyboard layout cannot be changed");
		}

		override public function set itemRendererFactory(value:Function):void
		{
			throw new Error("TouchKeyboard renderer cannot be changed");
		}

		override public function set itemRendererType(value:Class):void
		{
			throw new Error("TouchKeyboard renderer cannot be changed");
		}

		override public function setItemRendererFactoryWithID(id:String, factory:Function):void
		{
			throw new Error("TouchKeyboard renderer cannot be changed");
		}

		protected var _actualKeyUnitSize:Number;

		override protected function initialize():void
		{
			_rowRenderers = new Dictionary(true);
			_keyRenderers = new Dictionary(true);

			_isSelectable = false;
			_isFocusEnabled = false;
			_isChildFocusEnabled = false;
			_interactionMode = ScrollInteractionMode.MOUSE;
			_verticalScrollPolicy = ScrollPolicy.OFF;
			_horizontalScrollPolicy = ScrollPolicy.OFF;

			var vl:VerticalLayout = new VerticalLayout;
			vl.useVirtualLayout = false;
			vl.hasVariableItemDimensions = true;
			vl.horizontalAlign = HorizontalAlign.CENTER;
			_layout = vl;

			_itemRendererType = RowRenderer;

			addEventListener(FeathersEventType.RENDERER_ADD, rowRendererAddHandler);
			addEventListener(FeathersEventType.RENDERER_REMOVE, rowRendererRemoveHandler);

			super.initialize();
		}

		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var modifiersInvalid:Boolean = isInvalid(INVALIDATION_FLAG_MODIFIERS);

			if (modifiersInvalid)
			{
				for (var renderer:Object in _keyRenderers)
				{
					if (!(renderer is IKeyRenderer))
					{
						continue;
					}

					// Trigger label update:
					(renderer as FeathersControl).invalidate(INVALIDATION_FLAG_DATA);
					
					// Auto-select all modifier keys:
					switch ((renderer as IKeyRenderer).keyData.keyCode)
					{
						case Keyboard.SHIFT:
						{
							if (renderer.isSelected != _shift)
							{
								renderer.isSelected = _shift;
							}
							break;
						}
						case Keyboard.CAPS_LOCK:
						{
							if (renderer.isSelected != _capsLock)
							{
								renderer.isSelected = _capsLock;
							}
							break;
						}
						case Keyboard.ALTERNATE:
						{
							if (renderer.isSelected != _alt)
							{
								renderer.isSelected = _alt;
							}
							break;
						}
						case Keyboard.CONTROL:
						{
							if (renderer.isSelected != _ctrl)
							{
								renderer.isSelected = _ctrl;
							}
							break;
						}
						case Keyboard.COMMAND:
						{
							if (renderer.isSelected != _command)
							{
								renderer.isSelected = _command;
							}
							break;
						}
					}
				}
			}

			super.draw();

			if (sizeInvalid || layoutInvalid)
			{
				updateRendererMinTouchSizes();
			}
		}

		override protected function refreshViewPort(measure:Boolean):void
		{
			super.refreshViewPort(measure);

			// measure = dataInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || stateInvalid || layoutInvalid
			if (!measure)
			{
				return;
			}

			_actualKeyUnitSize = _minimumKeyUnitSize;

			var gap:Number = _verticalGapInUnits * _actualKeyUnitSize;
			(layout as VerticalLayout).gap = _snapToPixels ? Math.round(gap) : gap;

			// Find the widest row size:
			var widestRowSize:Number = 0;
			for (var i:int = 0, l:int = _dataProvider ? _dataProvider.length : 0; i < l; i++)
			{
				var rowData:RowData = _dataProvider.getItemAt(i) as RowData;
				var rowWidth:Number = 0;
				if (rowData)
				{
					rowWidth = (rowData.items.length - 1) * _horizontalGapInUnits;
					for each (var renderable:IRenderableData in rowData.items)
					{
						rowWidth += renderable.widthInUnits;
					}
				}
				if (rowWidth > widestRowSize)
				{
					widestRowSize = rowWidth;
				}
			}
			for (var renderer:Object in _rowRenderers)
			{
				updateRowRenderer(renderer as RowRenderer, widestRowSize * _actualKeyUnitSize);
			}
			for (renderer in _keyRenderers)
			{
				sizeKeyRenderer(renderer as IListItemRenderer);
			}
		}

		/** We want the HitTest to either return a KeyRenderer, this or nowt. */
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
			var result:DisplayObject = super.hitTest(localPoint);
			if (result is KeyRenderer)
			{
				return result;
			}
			return this._hitArea.containsPoint(localPoint) ? this : null;
		}

		/** Updates the renderer properties & layout. */
		protected function updateRowRenderer(renderer:RowRenderer, rowWidth:Number):void
		{
			if (!renderer)
			{
				return;
			}

			renderer.itemRendererType = _keyRendererType;
			renderer.itemRendererFactory = _keyRendererFactory;
			renderer.itemRendererFactories = _keyRendererFactories;

			if (_actualKeyUnitSize !== _actualKeyUnitSize) // isNaN
			{
				return;
			}

			var rowData:RowData = renderer.data as RowData;
			var rendererHeight:Number = rowData.heightInUnits * _actualKeyUnitSize;
			var gap:Number = _horizontalGapInUnits * _actualKeyUnitSize;
			renderer.height = _snapToPixels ? Math.round(rendererHeight) : rendererHeight;
			(renderer.layout as HorizontalLayout).gap = _snapToPixels ? Math.round(gap) : gap;
			renderer.width = rowWidth;
		}
		
		protected function sizeKeyRenderer(renderer:IListItemRenderer):void
		{
			if (!renderer || !_actualKeyUnitSize)
			{
				return;
			}

			var renderableData:IRenderableData = renderer.data as IRenderableData;
			if (!renderableData)
			{
				return;
				// throw new Error("Key renderer data must implement IRenderableData");
			}
			var rendererLayoutData:HorizontalLayoutData = (renderer as FeathersControl).layoutData as HorizontalLayoutData;
			var rendererWidth:Number = renderableData.widthInUnits * _actualKeyUnitSize;
			if (snapToPixels)
			{
				rendererWidth = Math.round(rendererWidth);
			}
			if (renderableData.flexibleWidth)
			{
				renderer.minWidth = rendererWidth;
				renderer.maxWidth = Number.POSITIVE_INFINITY;
				renderer.width = NaN;
				rendererLayoutData.percentWidth = 100 * Math.max(renderableData.widthInUnits, 1);
			}
			else
			{
				renderer.minWidth = NaN;
				renderer.maxWidth = Number.POSITIVE_INFINITY;
				renderer.width = rendererWidth;
				rendererLayoutData.percentWidth = NaN;
			}
		}

		private function updateRendererMinTouchSizes():void
		{
			if (_actualKeyUnitSize !== _actualKeyUnitSize) // isNaN
			{
				return;
			}
			for (var renderer:Object in _rowRenderers)
			{
				if (!(renderer is RowRenderer))
				{
					continue;
				}
				renderer.minTouchHeight = renderer.height + _verticalGapInUnits * _actualKeyUnitSize;
			}
			for (renderer in _keyRenderers)
			{
				if (!(renderer is FeathersControl) || !(renderer is IListItemRenderer) || !(renderer.data is IRenderableData))
				{
					continue;
				}
				renderer.minTouchWidth = renderer.width + _horizontalGapInUnits * _actualKeyUnitSize;
				renderer.minTouchHeight = renderer.height + _verticalGapInUnits * _actualKeyUnitSize;
			}
		}

		protected function dispatchKeyboardEvent(type:String, charCode:uint, keyCode:uint, keyLocation:int):void
		{
			dispatchEvent(new KeyboardEvent(type, charCode, keyCode, keyLocation, _ctrl, _alt, _shift));
		}

		protected function rowRendererAddHandler(event:Event, renderer:RowRenderer):void
		{
			_rowRenderers[renderer] = true;
			renderer.addEventListener(FeathersEventType.RENDERER_ADD, keyRendererAddHandler);
			renderer.addEventListener(FeathersEventType.RENDERER_REMOVE, keyRendererRemoveHandler);
			renderer.initializeNow();
			updateRowRenderer(renderer, NaN);
		}

		protected function rowRendererRemoveHandler(event:Event, renderer:RowRenderer):void
		{
			delete _rowRenderers[renderer];
			renderer.removeEventListener(FeathersEventType.RENDERER_ADD, keyRendererAddHandler);
			renderer.removeEventListener(FeathersEventType.RENDERER_REMOVE, keyRendererRemoveHandler);
		}

		protected function keyRendererAddHandler(event:Event, renderer:IListItemRenderer):void
		{
			if (!(renderer is FeathersControl))
			{
				throw new Error("Key renderers must extend FeathersControl");

			}
			if (!(renderer is IKeyRenderer) && !(renderer is GapRenderer))
			{
				throw new Error("Key renderers must implement IKeyRenderer");
			}

			_keyRenderers[renderer] = true;
			renderer.owner = this;

			var keyRenderer:FeathersControl = renderer as FeathersControl;
			keyRenderer.layoutData = new HorizontalLayoutData;
			if (!(renderer is GapRenderer))
			{
				keyRenderer.isQuickHitAreaEnabled = true;
				renderer.addEventListener(Event.TRIGGERED, key_triggeredHandler);
				renderer.addEventListener(FeathersEventType.LONG_PRESS, key_longPressHandler);
				renderer.addEventListener(Event.CHANGE, key_changeHandler);
			}

			renderer.initializeNow();
			sizeKeyRenderer(renderer);
		}

		protected function keyRendererRemoveHandler(event:Event, renderer:IListItemRenderer):void
		{
			if (renderer is ToggleButton)
			{
				renderer.removeEventListener(Event.TRIGGERED, key_triggeredHandler);
				renderer.removeEventListener(FeathersEventType.LONG_PRESS, key_longPressHandler);
				renderer.removeEventListener(Event.CHANGE, key_changeHandler);
			}
			delete _keyRenderers[renderer];
		}

		protected function key_triggeredHandler(event:Event):void
		{
			var key:ToggleButton = event.currentTarget as ToggleButton;
			var keyData:KeyData = (event.currentTarget as IListItemRenderer).data as KeyData;
			var charCode:uint = _shift && keyData.upperCaseCharCode ? keyData.upperCaseCharCode : keyData.charCode;
			if (charCode && keyData.caseSensitive)
			{
				var charString:String = String.fromCharCode(charCode);
				charCode = String(capsLock != shift ? charString.toLocaleUpperCase() : charString.toLocaleLowerCase()).charCodeAt();
			}

			var keyCode:uint = keyData.keyCode;
			if (keyCode == TouchKeyboardKeyCode.CLOSE_KEYBOARD)
			{
				dispatchEventWith(TouchKeyboardEventType.CLOSE_REQUESTED);
			}
			else if (keyCode == TouchKeyboardKeyCode.SWITCH_LAYOUT)
			{
				selectedLayoutID = String(keyData.additionalData);
			}
			else if (charCode > 0 || keyCode > 0)
			{
				// To simulate a physical key press, we dispatch a KEY_DOWN and KEY_UP event in succession:
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, charCode, keyCode, KeyLocation.STANDARD);
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, charCode, keyCode, KeyLocation.STANDARD);
			}

			// Reset all (non-locked) modifiers:
			if (_shift || _alt || _ctrl || _command)
			{
				switch (keyData.keyCode)
				{
					case Keyboard.ALTERNATE:
					case Keyboard.COMMAND:
					case Keyboard.CONTROL:
					case Keyboard.SHIFT:
					case TouchKeyboardKeyCode.CLOSE_KEYBOARD:
					{
						break;
					}
					default:
					{
						shift = false;
						alt = false;
						ctrl = false;
						command = false;
					}
				}
			}
		}

		protected function key_longPressHandler(event:Event):void
		{
			var key:ToggleButton = event.currentTarget as ToggleButton;
			var keyData:KeyData = (event.currentTarget as IListItemRenderer).data as KeyData;
			if (keyData.variantCharCodes && keyData.variantCharCodes.length)
			{
				trace("show variants");
			}
		}

		protected function key_changeHandler(event:Event):void
		{
			var key:ToggleButton = event.currentTarget as ToggleButton;
			var keyData:KeyData = (event.currentTarget as IListItemRenderer).data as KeyData;
			if (keyData.isToggle)
			{
				switch (keyData.keyCode)
				{
					case Keyboard.CAPS_LOCK:
					{
						capsLock = key.isSelected;
						break;
					}
					case Keyboard.SHIFT:
					{
						shift = key.isSelected;
						break;
					}
					case Keyboard.CONTROL:
					{
						ctrl = key.isSelected;
						break;
					}
					case Keyboard.ALTERNATE:
					{
						alt = key.isSelected;
						break;
					}
					case Keyboard.COMMAND:
					{
						command = key.isSelected;
						break;
					}
				}
			}
			else if (key.isSelected)
			{
				key.removeEventListener(Event.CHANGE, key_changeHandler);
				key.isSelected = false;
				key.addEventListener(Event.CHANGE, key_changeHandler);
			}
		}

		override public function dispose():void
		{
			_isDisposing = true;
			super.dispose();
		}
	}
}