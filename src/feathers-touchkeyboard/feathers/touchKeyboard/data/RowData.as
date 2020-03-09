package feathers.touchKeyboard.data
{
	public class RowData
	{
		public var items:Vector.<IRenderableData>;
		public var heightInUnits:Number;

		public function RowData(items:Vector.<IRenderableData>, heightInUnits:Number = 1)
		{
			this.items = items;
			this.heightInUnits = heightInUnits;
		}
	}
}