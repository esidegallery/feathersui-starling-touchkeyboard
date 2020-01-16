package feathers.touchKeyboard.data
{
	public interface IRenderableData
	{
		/** Used to determine and customise the item renderer to be created. */
		function get factoryID():String;
		/** @private */
		function set factoryID(value:String):void;

		/** 
		 * The width of the renderer in key size units. This will be multiplied by the calculated key unit size to determine the actual width.
		 * If <code>isFlexible = true</code>, this (combined with <code>widthInGapUnits</code>) will dictate the minimum width.
		 * The height of the key is dictated by its row.
		 */
		function get widthInUnits():Number;
		/** @private */
		function set widthInUnits(value:Number):void;

		/** Whether the width of the renderer will expand to fill the entire row. */
		function get flexibleWidth():Boolean;
		/** @private */
		function set flexibleWidth(value:Boolean):void;
	}
}