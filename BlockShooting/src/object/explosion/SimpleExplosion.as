package object.explosion
{
	import object.MovieClipObjectBase;
	import object.enemy.IFEnemy;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class SimpleExplosion extends ExplosionObjectBase
	{
		public function SimpleExplosion(textures:Vector.<Texture>, fps:Number = 12)
		{
			super(textures, fps);
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
	}
}
