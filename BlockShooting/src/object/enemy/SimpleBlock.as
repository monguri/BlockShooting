package object.enemy
{
	import object.CollisionEvent;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class SimpleBlock extends EnemyObjectBase implements IFEnemy
	{
		public function SimpleBlock(texture:Texture)
		{
			super(texture);
		}
		
		override public function collisionHandler(event:CollisionEvent):void
		{
			dispatchEvent(new Event(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE));
		}
	}
}