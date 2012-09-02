package scene
{
	import asset.AssetsManager;
	
	import common.Const;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import object.CollisionEvent;
	import object.ImageObjectBase;
	import object.backGround.BackGround;
	import object.backGround.BackGroundManager;
	import object.ball.Ball;
	import object.bar.Bar;
	import object.boss.BossManager;
	import object.bullet.BulletObjectBase;
	import object.enemy.EnemyManager;
	import object.enemy.EnemyObjectBase;
	import object.lifeCounter.LifeCounter;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Play extends DisplayObjectContainer implements IFScene
	{
		private var _objectLayer:Sprite;

		private var _ball:Ball;
		private var _bar:Bar;
		private var _backGroundManager:BackGroundManager;
		private var _bossManager:BossManager;
		private var _enemyManager:EnemyManager;
		private var _lifeCounter:LifeCounter;

		private var _stage:uint = 0;
		private var _life:uint;
		/** 初期残機数 */
		private static const INITIAL_LIFE:uint = 3;
		/** 面数 */
		private static const NUM_STAGE:uint = 2;

		public function Play(stage:Object)
		{
			super();
			_stage = stage as uint;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			initialize();
		}
		
		public function initialize():void
		{
			var backGroundLayer:Sprite = new Sprite();
			_objectLayer = new Sprite();
			var uiLayer:Sprite = new Sprite();

			addChild(backGroundLayer);
			addChild(_objectLayer);
			addChild(uiLayer);
	
			_bar = new Bar();
			_ball = new Ball();
			_lifeCounter = new LifeCounter();
			
			_objectLayer.addChild(_bar);
			_objectLayer.addChild(_ball);
			uiLayer.addChild(_lifeCounter);

			setLife(INITIAL_LIFE);
//			var stageData:StageData = new StageData();
//			stageData.createFromXmlAsync("assets/stage1.xml");
//			stageData.addEventListener(Event.COMPLETE, createStageDataCompleteHandler);

			var stageData:XML = AssetsManager.getXml("Stage" + _stage + "Xml");
			_backGroundManager = new BackGroundManager();
			_backGroundManager.createFromXml(stageData.backGround[0]);
			_backGroundManager.initialize();

			backGroundLayer.addChild(_backGroundManager);

			_enemyManager = new EnemyManager();
			_enemyManager.createFromXml(stageData.enemies[0]);
			_enemyManager.initialize();
			
			_objectLayer.addChild(_enemyManager);
			
			addEventListener(LifeCounter.LIFE_LOST, lifeLostHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);

			_backGroundManager.start();
			_bar.start();
			_ball.start();
			_enemyManager.start();
			
			// デバッグのため
//			enterBossMode();
		}
		
//		private function createStageDataCompleteHandler(event:Event):void
//		{
//			var stageData:StageData = event.currentTarget as StageData;
//			stageData.removeEventListener(Event.COMPLETE, createStageDataCompleteHandler);
//			_backGround = stageData.backGround;
//			_enemyManager = stageData.enemyManager;
//			
//			_enemyManager.initialize();
//			
//			addEventListener(LifeCounter.LIFE_LOST, lifeLostHandler);
//			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
//
//			_backGround.start();
//			_bar.start();
//			_ball.start();
//			_enemyManager.start();
//			_bossManager.start();
//		}
		
		public function finalize():void
		{
			removeEventListener(Event.ENTER_FRAME, bossModeEnterFrameHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			removeEventListener(LifeCounter.LIFE_LOST, lifeLostHandler);

			_ball.stop();
			_ball = null;
			
			_bar.stop();
			_bar = null;

			if (_backGroundManager != null)
			{
				_backGroundManager.stop();
				_backGroundManager.finalize();
				_backGroundManager = null;
			}

			if (_bossManager != null)
			{
				_bossManager.stop();
				_bossManager.finalize();
				_bossManager = null;
			}
			
			if (_enemyManager != null)
			{
				_enemyManager.stop();
				_enemyManager.finalize();
				_enemyManager = null;
			}
		}
		
		private function enterBossMode():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

			// ボスモードに入ったらブロックはすべて削除
			if (_enemyManager != null)
			{
				_enemyManager.stop();
				_enemyManager.finalize();
				_enemyManager = null;
			}
			
			var xml:XML = AssetsManager.getXml("Stage" + _stage + "BossXml");
			_bossManager = new BossManager();
			_bossManager.createFromXml(xml.bosses[0]);

			addEventListener(Event.ENTER_FRAME, bossModeEnterFrameHandler);

			_bossManager.initialize();
			_objectLayer.addChild(_bossManager);
			_bossManager.start();
		}
		
//		private function createStageBossDataCompleteHandler(event:Event):void
//		{
//			addEventListener(Event.ENTER_FRAME, bossModeEnterFrameHandler);
//			addEventListener(BossManager.DEFEAT_BOSS, defeatBossHandler);
//
//			var stageBossData:StageBossData = event.currentTarget as StageBossData;
//			_bossManager = stageBossData.bossManager;
//			_bossManager.initialize();
//			_bossManager.start();
//		}
		
		private function enterFrameHandler(event:Event):void
		{
			var intersectRect:Rectangle;

			// ボールとバーの当たり判定
			if (_ball.y > Const.BAR_Y - (_bar.height << 1)
				&& _ball.y < Const.BAR_Y + (_bar.height << 1)) { // ボールがバーの近傍にあるときだけ衝突判定
				intersectRect = getCollisionRectangle(_ball, _bar);
				if (intersectRect != null)
				{
					sendCollisionEventToBall(_ball, _bar, intersectRect);
				}
			}

			if (_enemyManager == null) {
				return;
			}

			// ループが回っている間に、イベントハンドラによってremoveChildされることがあるので
			// あえて毎ループnumChildrenにアクセスしている
			if (_ball.y < Const.SCREEN_HEIGHT >> 2) { // ボールが画面半分より上にあるときに衝突判定
				var enemy:EnemyObjectBase;
				for (var i:int = 0; i < _enemyManager.numChildren; i++)
				{
					enemy = _enemyManager.getChildAt(i) as EnemyObjectBase;
					intersectRect = getCollisionRectangle(_ball, enemy);
					if (intersectRect != null)
				{
						sendCollisionEventToBall(_ball, enemy, intersectRect);
						enemy.dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION));
					}
				}
			}
			
			var enemyNum:uint = _enemyManager.numChildren;
			if (enemyNum == 0)
			{
				enterBossMode();
			}
		}

		private function bossModeEnterFrameHandler(event:Event):void
		{
			var intersectRect:Rectangle;

			// ボールとバーの当たり判定
			if (_ball.y > Const.BAR_Y - (_bar.height << 1)
				&& _ball.y < Const.BAR_Y + (_bar.height << 1)) { // ボールがバーの近傍にあるときだけ衝突判定
				intersectRect = getCollisionRectangle(_ball, _bar);
				if (intersectRect != null)
				{
					sendCollisionEventToBall(_ball, _bar, intersectRect);
				}
			}

			if (_bossManager == null) {
				return;
			}

			// ボールとボスの当たり判定
			// TODO:もうちょい絞れるはず
			var bossLayer:Sprite = _bossManager.bossLayer;
			var bossNum:int = bossLayer.numChildren;
			var boss:EnemyObjectBase;
			for (var i:int = 0; i < bossNum; i++)
			{
				boss = bossLayer.getChildAt(i) as EnemyObjectBase;
				if (_ball.y > boss.y - boss.height 
					&& _ball.y < boss.y + boss.height)
				{ // ボールがボスの近傍にあるときだけ衝突判定
					intersectRect = getCollisionRectangle(_ball, boss);
					if (intersectRect != null)
					{
						sendCollisionEventToBall(_ball, boss, intersectRect);
						var e:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION);
						var data:Object = {dx:(intersectRect.x - boss.x), dy:(intersectRect.y - boss.y)};
						e.data = data;
						boss.dispatchEvent(e);
					}
				}
			}
			
			if (_bossManager.bossLayer.numChildren == 0) {
				defeatBoss();
			}
				
			if (_bossManager == null) {
				return;
			}

			// バーとミサイルの当たり判定
			var bulletLayer:Sprite = _bossManager.bulletLayer;
			var bulletNum:int = bulletLayer.numChildren;
			var bullet:BulletObjectBase;
			for (var j:int = 0; j < bulletNum; j++)
			{
				bullet = bulletLayer.getChildAt(j) as BulletObjectBase;
				if (bullet.y > Const.BAR_Y - (_bar.height << 1)
					&& bullet.y < Const.BAR_Y + (_bar.height << 1)) { // 弾がバーの近傍にあるときだけ衝突判定
					intersectRect = getCollisionRectangle(_bar, bullet);
					if (intersectRect != null)
					{
						lifeLostHandler();
						_bar.dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION));
						bullet.dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION));
					}
				}
			}
		}

		/**
		 * 衝突判定し、衝突していたものには衝突イベントを送信する 
		 * @param view1 判定対象1
		 * @param view2 判定対象2
		 * 
		 */
		private function getCollisionRectangle(view1:Image, view2:Image):Rectangle
		{
			var rect:Rectangle = view1.getBounds(view1);
			var rect2:Rectangle = view2.getBounds(view2);
			
			// getBoundsでは左上頂点が(0, 0)のrectがとれるので位置修正
			rect.offset((view1.x - view1.pivotX), (view1.y - view1.pivotY));
			rect2.offset((view2.x - view2.pivotX), (view2.y - view2.pivotY));

			var intersectRect:Rectangle = rect.intersection(rect2);
			
			// rectに交差がない場合は衝突イベントを送信しない
			if (intersectRect.width == 0 && intersectRect.height == 0)
			{
				return null;
			}
			
			return intersectRect;
		}

		private function sendCollisionEventToBall(ball:Ball, opponent:ImageObjectBase, intersectRect:Rectangle):void
		{
			var data:Object = createCollisionData(ball, opponent, intersectRect);
	
			var event:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION, data);
			ball.dispatchEvent(event);
		}

		private function createCollisionData(ball:Ball, opponent:ImageObjectBase, intersectRect:Rectangle):Object
		{
			var nextStartDx:Number = 0;
			var nextStartDy:Number = 0;

			// ボールよりブロックやバーの方が縦横ともに大きいという仮定
			// 1フレームでのボールよりブロックの方が大きいという仮定
			if (intersectRect.width >= intersectRect.height) // 上下方向に反射させる
			{
				// view1とview2の相対速度により次フレームでずらしておく量を決める
				if ((ball.vy) >= 0)
				{
					nextStartDy = -(intersectRect.height + 1);
				} else {
					nextStartDy = intersectRect.height + 1; // 次フレームで確実に衝突させないため、1多めに移動させておく
				}
			} else {
				if ((ball.vx) >= 0)
				{
					nextStartDx = -(intersectRect.width + 1);
				} else {
					nextStartDx = intersectRect.width + 1;
				}
			}

			var v1:Point = new Point(ball.vx, ball.vy);
			var nextVx:Number;
			var nextVy:Number;
			
			// ボールよりブロックやバーの方が縦横ともに大きいという前提
			// 1フレームでのボール移動よりブロックの方が大きいという前提
			if (intersectRect.width >= intersectRect.height)
			{
				// 上下方向に反射させる
				// TODO:isの結果で動きを変えているよくないコード。
				if (opponent is Bar)
				{
					var vx:Number;
					var vy:Number;
					vx = ball.vx + opponent.vx;
					vy = -ball.vy;
					var absVx:Number = Math.abs(vx);
					var absVy:Number = Math.abs(vy);
					
					// ボール反射角度があまりに水平にならないよう調節する
					if (absVx / 6 > absVy) {
						vy = vy / absVy * absVx / 6;
					}
					v1.setTo(vx, vy);
					v1.normalize(Ball.BALL_SPEED);
				}
				else
				{
					v1.setTo(ball.vx, -ball.vy);
				}
			}
			else
			{
				v1.setTo(-ball.vx, ball.vy);
			}
			
			var collisionData:Object = {nextVx:v1.x, nextVy:v1.y, nextStartDx:nextStartDx, nextStartDy:nextStartDy}
			return collisionData;
		}

		private function lifeLostHandler(event:Event = null):void
		{
			var newLife:uint = --_life;
			setLife(newLife);
			if (newLife < 1) {
				var e:SceneEvent = new SceneEvent(SceneEvent.NEXT_SCENE, RootStarling.SCENE_GAME_OVER);
				dispatchEvent(e);
			}
		}

		private function defeatBoss():void
		{
			var nextStage:uint = _stage + 1;
			var event:SceneEvent;
			if (nextStage > NUM_STAGE)
			{
				event = new SceneEvent(SceneEvent.NEXT_SCENE, RootStarling.SCENE_GAME_CLEAR);
			}
			else
			{
				event = new SceneEvent(SceneEvent.NEXT_SCENE, RootStarling.SCENE_STAGE_CLEAR, nextStage);
			}
			dispatchEvent(event);
		}
		
		private function setLife(value:uint):void
		{
			_life = value;
			_lifeCounter.setLifeCounter(value);
		}
	}
}
