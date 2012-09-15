package object.enemy
{
	import common.Const;
	
	import object.CollisionEvent;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CollapseBlock extends EnemyObjectBase
	{
		private var GRAVITY:int = 3;
		private var i:Number = 0;

		public function CollapseBlock(texture:Texture)
		{
			super(texture);
			_isBarCollisionTarget = true;
		}
		
		override public function start():void
		{
			x = _initX;
			y = _initY;
		}

		override public function collisionHandler(event:CollisionEvent):void
		{
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			y += GRAVITY * i;
			i += 0.1;

			if (y - height > Const.SCREEN_HEIGHT)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				dispatchEvent(new Event(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE));
			}
		}
	}
}