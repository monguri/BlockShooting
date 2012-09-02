package
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import scene.GameClear;
	import scene.GameOver;
	import scene.IFScene;
	import scene.Play;
	import scene.SceneEvent;
	import scene.StageClear;
	import scene.Title;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	
	/**
	 * 全ゲームの根元の処理を行うクラス
	 * @author monguri
	 * 
	 */
	public class RootStarling extends Sprite
	{
		/** シーンを格納したマップ */
		private var _scenes:Object = new Object();
		/** 現在のシーン */
		private var _currentScene:IFScene;

		// シーン名文字列
		public static const SCENE_TITLE:String = "title";
		public static const SCENE_PLAY:String = "play";
		public static const SCENE_STAGE_CLEAR:String = "stageClear";
		public static const SCENE_GAME_OVER:String = "gameOver";
		public static const SCENE_GAME_CLEAR:String = "gameClear";
		
		public function RootStarling()
		{
			_scenes[SCENE_TITLE] = getQualifiedClassName(Title);
			_scenes[SCENE_PLAY] = getQualifiedClassName(Play);
			_scenes[SCENE_STAGE_CLEAR] = getQualifiedClassName(StageClear);
			_scenes[SCENE_GAME_OVER] = getQualifiedClassName(GameOver);
			_scenes[SCENE_GAME_CLEAR] = getQualifiedClassName(GameClear);
			
			addEventListener(SceneEvent.NEXT_SCENE, nextSceneHandler);
			var title:Title = new Title();
			addChild(title);
			_currentScene = title;
			
			// FPSとメモリ消費量の表示
			Starling.current.showStats = true;
		}
		
		private function nextSceneHandler(e:SceneEvent):void
		{
			_currentScene.finalize();
			removeChild(_currentScene as DisplayObjectContainer);
			
			var next:String = _scenes[e.nextScene];
			var sceneClass:Class = getDefinitionByName(next) as Class;
			_currentScene = new sceneClass(e.data);
			this.addChild(_currentScene as DisplayObjectContainer);
		}
	}
}