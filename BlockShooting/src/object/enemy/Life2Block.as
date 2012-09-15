package object.enemy
{
	import asset.AssetsManager;
	
	import object.CollisionEvent;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Life2Block extends EnemyObjectBase
	{
		public function Life2Block(texture:Texture)
		{
			super(texture);
		}

		override public function collisionHandler(event:CollisionEvent):void
		{
			_life = _life - 1;
			if (_life == 1)
			{
				// ライフが1減った時のテクスチャをハードコーディングで決めておく
				// TODO:もっといい作りを考える
				texture = AssetsManager.getTexture("Block2Life");
			}
			else if (_life < 1)
			{
				dispatchEvent(new Event(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE));
			}
		}
	}
}