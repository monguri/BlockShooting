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
	}
}