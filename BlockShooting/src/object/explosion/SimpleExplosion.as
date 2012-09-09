package object.explosion
{
	import flash.media.Sound;
	
	import object.MovieClipObjectBase;
	import object.enemy.IFEnemy;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class SimpleExplosion extends ExplosionObjectBase
	{
		public function SimpleExplosion(se:Sound, textures:Vector.<Texture>, fps:Number = 12)
		{
			super(se, textures, fps);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			_se.play();
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
