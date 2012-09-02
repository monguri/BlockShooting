package object.bullet
{
	import common.Const;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class SimpleBullet extends BulletObjectBase
	{
		public function SimpleBullet(texture:Texture)
		{
			super(texture);
			pivotX = width / 2;
			pivotY = height / 2;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			y += _speed;
			if (y > Const.SCREEN_HEIGHT + height) {
				dispatchEvent(new Event(BulletObjectBase.EVENT_TYPE_SELF_DISPOSE));
			}
		}
	}
}