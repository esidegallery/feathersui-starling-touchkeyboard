package feathers.touchKeyboard
{
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.FeathersControl;

    /**
     * The most basic item renderer used to render gaps in keyboard rows.
     */
    public class GapRenderer extends FeathersControl implements IListItemRenderer
    {
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
            _data = value;
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

        override protected function initialize():void
        {
            visible = false;
            touchable = false;
            _isFocusEnabled = false;
            super.initialize();
        }
    }
}