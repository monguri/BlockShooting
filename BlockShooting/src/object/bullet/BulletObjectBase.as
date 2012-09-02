package object.bullet
{
	import object.CollisionEvent;
	import object.ImageObjectBase;
	import object.enemy.IFEnemy;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class BulletObjectBase extends ImageObjectBase implements IFBullet
	{
		protected var _speed:int;
		
		public static const EVENT_TYPE_SELF_DISPOSE:String = "selfDispose";

		public function BulletObjectBase(texture:Texture)
		{
			super(texture);
			addEventListener(CollisionEvent.COLLISION, collisionHandler);
		}
		
		public function collisionHandler(e:CollisionEvent):void
		{
			dispatchEvent(new Event(BulletObjectBase.EVENT_TYPE_SELF_DISPOSE));
		}
		
		public function start():void
		{
			
		}
		
		public function stop():void
		{
			
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}
	}
}