package object.backGround
{
	import common.Const;
	
	import object.ImageObjectBase;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class BackGround extends ImageObjectBase
	{
		public function BackGround(texture:Texture)
		{
			super(texture);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			y += vy;
			if (y > Const.SCREEN_HEIGHT)
			{
				y = -Const.SCREEN_HEIGHT + 100;
			}
		}
	}
}