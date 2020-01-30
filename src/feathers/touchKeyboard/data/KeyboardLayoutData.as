package feathers.touchKeyboard.data
{
	public class KeyboardLayoutData
	{
		public var id:String;
		public var rows:Vector.<RowData>;

		public function KeyboardLayoutData(id:String, rows:Vector.<RowData>)
		{
			this.id = id;
			this.rows = rows;
		}
	}
}