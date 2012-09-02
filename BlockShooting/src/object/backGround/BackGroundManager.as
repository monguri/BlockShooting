package object.backGround
{
	import asset.AssetsManager;
	
	import common.Const;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import object.CollisionEvent;
	import object.IFManager;
	import object.enemy.SimpleBlock;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class BackGroundManager extends DisplayObjectContainer implements IFManager
	{
		public function BackGroundManager()
		{
		}
		
		public function createFromXml(backGroundElem:XML):void
		{
			var texture:Texture = AssetsManager.getTexture(backGroundElem.@img);
			var speed:int = parseInt(backGroundElem.@speed);
			var backGround1:BackGround = new BackGround(texture);
			var backGround2:BackGround = new BackGround(texture);
			backGround1.vy = speed;
			backGround2.vy = speed;
			backGround1.y = 0;
			backGround2.y = -Const.SCREEN_HEIGHT + 100;
			addChild(backGround1);
			addChild(backGround2);
		}

		public function initialize():void
		{
		}
		
		public function finalize():void
		{
			var num:int = numChildren;
			
			// removeChild()によるインデックスのずれが起こらないよう、後ろから削除していく
			for (var i:int = num - 1; i >= 0; i--)
			{
				var backGround:BackGround = getChildAt(i) as BackGround;
				backGround.dispose();
				removeChild(backGround);
			}
			// starlingにはイベントリスナーも整理してくれる便利メソッドがある
			dispose();
		}

		public function start():void
		{
		}

		public function stop():void
		{
		}
	}
}