package feathers.touchKeyboard
{
    import feathers.controls.List;
    import feathers.controls.ScrollInteractionMode;
    import feathers.controls.ScrollPolicy;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.VectorCollection;
    import feathers.layout.HorizontalAlign;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalAlign;
    import feathers.skins.IStyleProvider;
    import feathers.touchKeyboard.data.IRenderableData;
    import feathers.touchKeyboard.data.RowData;

    public class RowRenderer extends List implements IListItemRenderer
    {
        public static var globalStyleProvider:IStyleProvider;
		
		override protected function get defaultStyleProvider():IStyleProvider
		{
            return RowRenderer.globalStyleProvider;
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

        protected var _owner:List;
        public function get owner():List
        {
            return _owner;
        }
        public function set owner(value:List):void
        {
            _owner = value;
        }

        protected var _data:Object;
        public function get data():Object
        {
            return _data;
        }
        public function set data(value:Object):void
        {
            if (_data == value)
            {
                return;
            }

            _data = value;
			
			if (_data is RowData)
            {
                dataProvider = new VectorCollection((_data as RowData).items);
            }
            else
            {
                dataProvider = null;
            }
        }

        protected var _factoryID:String;
        public function get factoryID():String
        {
            return _factoryID;
        }
        public function set factoryID(value:String):void
        {
            _factoryID = value;
        }

        public function get isSelected():Boolean
        {
            return false;
        }
        public function set isSelected(value:Boolean):void
        {
			// Not selectable.
        }

        internal function set itemRendererFactories(value:Object):void
        {
            _itemRendererFactories = value;
        }

		override protected function initialize():void
		{
            _factoryIDFunction = function(item:Object):String
            {
                if (item is IRenderableData)
                {
                    return (item as IRenderableData).factoryID;
                }
                return null;
            }
            
            _clipContent = false;
            _isFocusEnabled = false;
            _isChildFocusEnabled = false;

            _interactionMode = ScrollInteractionMode.MOUSE;
            _allowMultipleSelection = true;

			_horizontalScrollPolicy = ScrollPolicy.OFF;
			_verticalScrollPolicy = ScrollPolicy.OFF;

			var hl:HorizontalLayout = new HorizontalLayout;
			hl.useVirtualLayout = false;
			hl.hasVariableItemDimensions = true;
			hl.horizontalAlign = HorizontalAlign.CENTER;
			hl.verticalAlign = VerticalAlign.JUSTIFY;
			_layout = hl;

			super.initialize();
		}
    }
}
