package scene
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class GameClear extends DisplayObjectContainer implements IFScene
	{
		/** タイトル文字列 */
		private static const TITLE_STRING:String = "Game Clear";
		/** タイトルサブ文字列 */
		private static const SUB_TITLE_STRING:String = "Congratulation!";

		public function GameClear(data:Object = null)
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			initialize();
		}
		
		public function initialize():void
		{
			var title:TextField = new TextField(320, 80, TITLE_STRING);
			title.x = 160;
			title.y = 480;
			title.color = 0xffffff;
			title.fontSize = 80;
			title.autoScale = true;
			addChild(title);
			
			var subTitle:TextField = new TextField(240, 60, SUB_TITLE_STRING);
			subTitle.x = 200;
			subTitle.y = 600;
			subTitle.color = 0xffffff;
			subTitle.fontSize = 60;
			subTitle.autoScale = true;
			addChild(subTitle);
			
			stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		public function finalize():void
		{
			stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (touch != null)
			{
				var event:SceneEvent = new SceneEvent(SceneEvent.NEXT_SCENE, RootStarling.SCENE_PLAY, 1); //初期レベル1
				dispatchEvent(event);
			}
		}
		
	}
}
