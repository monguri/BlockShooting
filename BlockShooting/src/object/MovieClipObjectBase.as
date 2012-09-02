package object
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class MovieClipObjectBase extends MovieClip
	{
		protected var _vx:Number;
		protected var _vy:Number;

		public function MovieClipObjectBase(texture:Vector.<Texture>, fps:Number=12)
		{
			super(texture, fps);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private function addedToStageHandler(e:Event):void
		{
			// stageにaddChildされるたびに再生開始する
			Starling.juggler.add(this);
		}
		
		private function removedFromStageHandler(e:Event):void
		{
			// stageにaddChildされるたびに再生開始する
			Starling.juggler.remove(this);
		}
		
		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_vx = value;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_vy = value;
		}
	}
}