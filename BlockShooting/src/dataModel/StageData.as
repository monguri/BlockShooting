package dataModel
{
	import object.backGround.BackGround;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import object.enemy.EnemyManager;
	
	import starling.events.EventDispatcher;

	public class StageData extends EventDispatcher implements IFXmlData
	{
		private var _backGround:BackGround
		private var _enemyManager:EnemyManager;

		public function createFromXmlAsync(xmlFilePath:String):void
		{
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
			
			var backGroundElem:XML = xml.backGround;
			_backGround = new BackGround;
			_backGround.img = backGroundElem.@img;
			_backGround.speed = parseInt(backGroundElem.@speed);

			_enemyManager = new EnemyManager();
			_enemyManager.createFromXml(xml.enemies);

			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}

		public function get backGround():BackGround
		{
			return _backGround;
		}

		public function get enemyManager():EnemyManager
		{
			return _enemyManager;
		}
	}
}