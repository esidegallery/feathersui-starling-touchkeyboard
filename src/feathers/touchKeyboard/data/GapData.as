package feathers.touchKeyboard.data
{
	import feathers.touchKeyboard.TouchKeyboard;

	import mx.utils.StringUtil;

	public class GapData implements IRenderableData
	{
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

		public function get factoryID():String
		{
			return TouchKeyboard.FACTORY_ID_GAP;
		}
		public function set factoryID(value:String):void
		{
			throw new Error("GapData factory ID cannot be changed");
		}

		public function GapData(widthInUnits:Number = 0, flexible:Boolean = false)
		{
			_widthInUnits = widthInUnits;
			_flexibleWidth = flexible;
		}

		public function toString():String
		{
			return StringUtil.substitute("[GapData(widthInUnits={0}, isFlexible={1})]", _widthInUnits, _flexibleWidth);
		}
	}
}
