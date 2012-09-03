package object.boss
{
	import asset.AssetsManager;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import object.CollisionEvent;
	import object.IFManager;
	import object.MovieClipObjectBase;
	import object.bullet.BulletObjectBase;
	import object.bullet.SimpleBullet;
	import object.enemy.EnemyObjectBase;
	import object.explosion.ExplosionObjectBase;
	import object.explosion.SimpleExplosion;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	// BossのクラスはEnemyと共通のものを使う
	public class BossManager extends DisplayObjectContainer implements IFManager
	{
		/** ボスモード突入イベント識別子 */
		public static const ENTER_BOSS_MODE:String = "enterEnemyMode";
		
		private var _bossLayer:Sprite;
		private var _bulletLayer:Sprite;
		private var _explosionLayer:Sprite;

		public function BossManager()
		{
			_bossLayer = new Sprite();
			_bulletLayer = new Sprite();
			_explosionLayer = new Sprite();
			addChild(_bossLayer);
			addChild(_bulletLayer);
			addChild(_explosionLayer);
			// 全く直接名でアクセスされることのないクラスはClassファイルが作られず
			// getDefinitionByNameが失敗する。よってClassファイルを作成する機会を作る。
			var bossClassDict:Object = new Object();
			bossClassDict["SimpleBoss"] = getQualifiedClassName(SimpleBoss);
			bossClassDict["SimpleBullet"] = getQualifiedClassName(SimpleBullet);
			bossClassDict["SimpleExplosion"] = getQualifiedClassName(SimpleExplosion);
		}
		
		// xmlからクラスを生成する。
		public function createFromXml(xml:XML):void
		{
			var bossElemList:XMLList = xml.boss;
			var bulletElems:XMLList = xml..bullet;

			var texture:Texture;
			var textureAtlas:Vector.<Texture>;
			var objClass:Class;
			var boss:EnemyObjectBase;
			var bullet:BulletObjectBase;
			var explosion:ExplosionObjectBase;
			var bossBullets:XMLList;
			var bossExplosions:XMLList;
			for each (var bossElem:XML in bossElemList)
			{
				texture = AssetsManager.getTexture(bossElem.@img);
				objClass = getDefinitionByName(bossElem.@className) as Class;
				boss = new objClass(texture);
				boss.life = parseInt(bossElem.@life);
				boss.bulletInterval = parseInt(bossElem.@bulletInterval);
				boss.initX = parseInt(bossElem.@initX);
				boss.initY = parseInt(bossElem.@initY);
				boss.initVx = parseInt(bossElem.@initVx);
				//ボスはすぐstageに登場させる
				boss.bulletLayer = _bulletLayer;
				boss.explosionLayer = _explosionLayer;
				_bossLayer.addChild(boss);
			
				// 弾と爆発エフェクトはテクスチャ名、Classだけ取得して保持しておき、必要なときに適宜生成する
				bossBullets = bossElem.bullet;
				for each (var bossBullet:XML in bossBullets)
				{
					texture = AssetsManager.getTexture(bossBullet.@img);
					boss.bulletSpeed = parseInt(bossBullet.@speed);
					boss.bulletTexture = bossBullet.@img;
					boss.bulletClass = getDefinitionByName(bossBullet.@className) as Class;
				}

				bossExplosions = bossElem.explosion;
				var bossExplosion:XML = bossExplosions[0];
				boss.explosionTexture = bossExplosion.@img;
				boss.explosionClass= getDefinitionByName(bossExplosion.@className) as Class;
			}
		}

		public function initialize():void
		{
			var numChildren:int = _bossLayer.numChildren;
			var boss:EnemyObjectBase;
			for (var i:uint = 0; i < numChildren; i++)
			{
				boss = _bossLayer.getChildAt(i) as EnemyObjectBase;
				boss.addEventListener(CollisionEvent.COLLISION, boss.collisionHandler);
				boss.addEventListener(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE, selfDisposeHandler);
			}
		}

		public function finalize():void
		{
			var num:int = _bossLayer.numChildren;
			var boss:EnemyObjectBase;
			for (var i:int = num - 1; i >= 0; i--)
			{
				boss = _bossLayer.getChildAt(i) as EnemyObjectBase;
				boss.dispose();
			}
			removeChild(_bossLayer);
			_bossLayer = null;

			num = _bulletLayer.numChildren;
			var bullet:BulletObjectBase;
			for (var j:int = num - 1; j >= 0; j--)
			{
				bullet = _bulletLayer.getChildAt(j) as BulletObjectBase;
				bullet.dispose();
			}
			removeChild(_bulletLayer);
			_bulletLayer = null;

			// starlingにはイベントリスナーも整理してくれる便利メソッドがある
			this.dispose();
		}

		private function selfDisposeHandler(event:Event):void
		{
			var boss:EnemyObjectBase = event.currentTarget as EnemyObjectBase;
			boss.stop();
			boss.removeEventListener(CollisionEvent.COLLISION, boss.collisionHandler);
			boss.removeEventListener(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE, selfDisposeHandler);
			_bossLayer.removeChild(boss);
		}
		
		public function start():void
		{
			var num:int = _bossLayer.numChildren;
			var boss:EnemyObjectBase;
			for (var i:uint = 0; i < num; i++)
			{
				boss = _bossLayer.getChildAt(i) as EnemyObjectBase;
				boss.start();
			}
		}

		public function stop():void
		{
			var num:int = _bossLayer.numChildren;
			var boss:EnemyObjectBase;
			for (var i:uint = 0; i < num; i++)
			{
				boss = _bossLayer.getChildAt(i) as EnemyObjectBase;
				boss.stop();
			}
		}

		public function get bossLayer():Sprite
		{
			return _bossLayer;
		}

		public function get bulletLayer():Sprite
		{
			return _bulletLayer;
		}
	}
}