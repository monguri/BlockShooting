package dataModel
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import object.boss.BossManager;
	
	import starling.events.EventDispatcher;

	public class StageBossData extends EventDispatcher implements IFXmlData
	{
		private var _bossManager:BossManager;

		// URLLoaderを使って読み取る時の処理
		public function createFromXmlAsync(xmlFilePath:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			var request:URLRequest = new URLRequest(xmlFilePath);
			urlLoader.load(request);
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			parseXml(urlLoader.data);
		}
		
		private function parseXml(xmlText:String):void
		{
			var xml:XML = new XML(xmlText);
			
			_bossManager = new BossManager();
			_bossManager.createFromXml(xml.bosses);
	
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}

		public function get bossManager():BossManager
		{
			return _bossManager;
		}
	}
}