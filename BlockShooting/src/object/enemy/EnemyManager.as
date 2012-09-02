package object.enemy
{
	import asset.AssetsManager;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import object.CollisionEvent;
	import object.IFManager;
	import object.enemy.SimpleBlock;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class EnemyManager extends DisplayObjectContainer implements IFManager
	{
		public function EnemyManager()
		{
			// 全く直接名でアクセスされることのないクラスはClassファイルが作られず
			// getDefinitionByNameが失敗する。よってClassファイルを作成する機会を作る。
			var enemyClassDict:Object = new Object();
			enemyClassDict["SimpleBlock"] = getQualifiedClassName(SimpleBlock);
		}
		
		public function createFromXml(xml:XML):void
		{
			var enemyElemList:XMLList = xml.enemy;

			var texture:Texture;
			var enemyClass:Class;
			var enemy:EnemyObjectBase;
			for each (var enemyElem:XML in enemyElemList)
			{
				texture = AssetsManager.getTexture(enemyElem.@img);
				enemyClass = getDefinitionByName(enemyElem.@className) as Class;
				enemy = new enemyClass(texture);
				enemy.x = parseInt(enemyElem.@x);
				enemy.y = parseInt(enemyElem.@y);
				enemy.life = parseInt(enemyElem.@life);
				addChild(enemy);
			}
		}

		public function initialize():void
		{
			var numChildren:int = numChildren;
			var enemy:EnemyObjectBase;
			for (var i:uint = 0; i < numChildren; i++)
			{
				enemy = getChildAt(i) as EnemyObjectBase;
				enemy.addEventListener(CollisionEvent.COLLISION, enemy.collisionHandler);
				enemy.addEventListener(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE, selfDisposeHandler);
			}
		}
		
		public function finalize():void
		{
			var enemy:EnemyObjectBase;
			var num:int = numChildren;
			
			// removeChild()によるインデックスのずれが起こらないよう、後ろから削除していく
			for (var i:int = num - 1; i >= 0; i--)
			{
				enemy = getChildAt(i) as EnemyObjectBase;
				enemy.dispose();
				removeChild(enemy);
			}
			// starlingにはイベントリスナーも整理してくれる便利メソッドがある
			dispose();
		}

		private function selfDisposeHandler(event:Event):void
		{
			var enemy:EnemyObjectBase = event.currentTarget as EnemyObjectBase;
			enemy.removeEventListener(CollisionEvent.COLLISION, enemy.collisionHandler);
			enemy.removeEventListener(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE, selfDisposeHandler);
			removeChild(enemy);
		}
		
		public function start():void
		{
			var numChildren:int = numChildren;
			var enemy:EnemyObjectBase;
			for (var i:uint; i < numChildren; i++)
			{
				enemy = getChildAt(i) as EnemyObjectBase;
				enemy.start();
			}
		}

		public function stop():void
		{
			var numChildren:int = numChildren;
			var enemy:EnemyObjectBase;
			for (var i:uint; i < numChildren; i++)
			{
				enemy = getChildAt(i) as EnemyObjectBase;
				enemy.stop();
			}
		}
	}
}