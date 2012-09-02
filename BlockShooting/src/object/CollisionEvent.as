package object
{
	import starling.events.Event;
	
	public class CollisionEvent extends Event
	{
		public static const COLLISION:String = "collision";

		/** 何でものせたいデータをのせる */
		private var _data:Object;

		public function CollisionEvent(type:String, data:Object=null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			_data = data;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}