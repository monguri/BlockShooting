package object.enemy
{
	import starling.textures.Texture;
	import object.CollisionEvent;
	import starling.events.Event;
	
	public class TransparentBlock extends EnemyObjectBase
	{
		public function TransparentBlock(texture:Texture)
		{
			super(texture);
			_reboundBall = false;
		}
	}
}
