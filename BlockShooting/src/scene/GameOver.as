package scene
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	
	public class GameOver extends DisplayObjectContainer implements IFScene
	{
		/** ゲームオーバー文字列 */
		private static const GAME_OVER_STRING:String = "Game Over";
		private var _timer:Timer = new Timer(2000, 1);

		public function GameOver(data:Object)
		{
			super();
			initialize();
		}
		
		public function initialize():void
		{
			var title:TextField = new TextField(320, 80, GAME_OVER_STRING);
			title.x = 160;
			title.y = 480;
			title.color = 0xffffff;
			title.fontSize = 80;
			title.autoScale = true;
			addChild(title);
			
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			_timer.start();
		}
		
		private function timerCompleteHandler(event:TimerEvent):void
		{
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			var e:SceneEvent = new SceneEvent(SceneEvent.NEXT_SCENE, RootStarling.SCENE_TITLE);
			dispatchEvent(e);
		}
		
		public function finalize():void
		{
			_timer = null;
		}
	}
}
