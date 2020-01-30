package feathers.touchKeyboard
{
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.IFeathersControl;
	import feathers.core.IToggle;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.touchKeyboard.data.KeyData;

	[Event(name="triggered",type="starling.events.Event")]
	[Event(name="change",type="starling.events.Event")]
	[Event(name="longPress",type="starling.events.Event")]
	
	public interface IKeyRenderer extends IFeathersControl, ILayoutDisplayObject, IListItemRenderer, IToggle
	{
		function get isToggle():Boolean;
		function set isToggle(value:Boolean):void;

		function get keyData():KeyData;
	}
}