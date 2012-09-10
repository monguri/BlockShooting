package object.bar
{
	import asset.AssetsManager;
	
	import common.Const;
	
	import object.ImageObjectBase;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import object.CollisionEvent;
	import flash.media.Sound;
	
	public class Bar extends ImageObjectBase
	{
		/** ボールの反射音のSE */
		public static const SHOT_SE:String = "ShotSE";

		public function Bar()
		{
			var texture:Texture = AssetsManager.getTexture("BarBitmap");
			super(texture);
			x = Const.SCREEN_WIDTH >> 1;
			y = Const.BAR_Y;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function start():void
		{
			addEventListener(CollisionEvent.COLLISION, collisionHandler);
		}
		
		public function stop():void
		{
			removeEventListener(CollisionEvent.COLLISION, collisionHandler);
		}

		private function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		internal function touchHandler(e:TouchEvent):void
		{
			// タッチしているポイントのx方向移動量だけバーも移動する
			// TODO:これは自由に動かせすぎるから後で変えよう
			var touch:Touch = e.getTouch(stage, TouchPhase.MOVED);
			if (touch != null)
			{
				x = x + touch.globalX - touch.previousGlobalX;
				
				// 衝突時にバーの速度情報をボールに与えるために速度を記録する
				vx = touch.globalX - touch.previousGlobalX;
			}
			
			touch = e.getTouch(this.stage, TouchPhase.ENDED);
			if (touch != null)
			{
				// タッチをやめたら速度情報をリセットしておく
				vx = 0;
			}
		}

		private function collisionHandler(e:CollisionEvent):void
		{
			var se:Sound = AssetsManager.getSound(SHOT_SE);
			se.play();
		}
	}
}