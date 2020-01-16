package feathers.touchKeyboard.data
{
	import feathers.layout.HorizontalAlign;

	public class RowData
	{
		public var items:Vector.<IRenderableData>;
		public var heightInUnits:Number;
		// public var horizontalAlign:String;

		public function RowData(items:Vector.<IRenderableData>, heightInUnits:Number = 1, horizontalAlign:String = HorizontalAlign.CENTER)
		{
			this.items = items;
			this.heightInUnits = heightInUnits;
			// this.horizontalAlign = horizontalAlign;
		}
	}
}