package object
{
	public interface IFManager
	{
		function createFromXml(xml:XML):void;
		function initialize():void;
		function finalize():void;
		function start():void;
		function stop():void;
	}
}
