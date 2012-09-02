package scene
{
	import starling.events.Event;
	
	public class SceneEvent extends Event
	{
		/** 次のシーンに移動するイベント */
		public static const NEXT_SCENE:String = "nextScene";
		
		private var _nextScene:String;
		private var _data:Object;

		public function SceneEvent(type:String, nextScene:String, data:Object = null)
		{
			super(type, true);
			_nextScene = nextScene;
			_data = data;
		}

		public function get nextScene():String
		{
			return _nextScene;
		}

		public function set nextScene(value:String):void
		{
			_nextScene = value;
		}

		/** 付加的情報 */
		public function get data():Object
		{
			return _data;
		}


	}
}