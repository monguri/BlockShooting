package object.boss
{
	import asset.AssetsManager;
	
	import common.Const;
	
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	
	import object.CollisionEvent;
	import object.bullet.BulletObjectBase;
	import object.bullet.SimpleBullet;
	import object.enemy.EnemyObjectBase;
	import object.explosion.ExplosionObjectBase;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class SimpleBoss extends EnemyObjectBase
	{
		private static const APPEAR_SPEED:int = 1;
		private static const SPEED:int = 3;
		private var _bulletTimer:Timer = new Timer(0, 0); // delay=0はとりあえず入れてるだけ
		private var _defeatedEffectTimer:Timer = new Timer(300, 10);

		public function SimpleBoss(texture:Texture)
		{
			super(texture);
			pivotX = width / 2;
			pivotY = height / 2;
		}

		override public function start():void
		{
			x = _initX;
			y = -height;
			vy = APPEAR_SPEED;
			addEventListener(Event.ENTER_FRAME, apperanceModeEnterFrameHandler);
		}
		
		override public function stop():void
		{
			_bulletTimer.reset();
			_bulletTimer.removeEventListener(TimerEvent.TIMER, bulletTimerHandler);
			_bulletTimer = null;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			vx = 0;
		}

		private function apperanceModeEnterFrameHandler(e:Event):void
		{
			if (y + vy >= _initY)
			{
				x = _initX;
				y = _initY;
				
				vx = _initVx;
				
				removeEventListener(Event.ENTER_FRAME, apperanceModeEnterFrameHandler);
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_bulletTimer.delay = _bulletInterval;
				_bulletTimer.addEventListener(TimerEvent.TIMER, bulletTimerHandler);
				_bulletTimer.start();
				return;
			}

			y += vy;
		}
		
		protected function bulletTimerHandler(event:TimerEvent):void
		{
			var texture:Texture = AssetsManager.getTexture(_bulletTexture);
			var bullet:BulletObjectBase = new _bulletClass(texture);
			bullet.x = this.x;
			bullet.y = this.y + this.height / 2;
			bullet.speed = _bulletSpeed;
			_bulletLayer.addChild(bullet);
			bullet.addEventListener(CollisionEvent.COLLISION, bullet.collisionHandler);
			bullet.addEventListener(BulletObjectBase.EVENT_TYPE_SELF_DISPOSE, selfDisposeHandler);
			bullet.start();
		}
		
		private function selfDisposeHandler(event:Event):void
		{
			var bullet:BulletObjectBase = event.currentTarget as BulletObjectBase;
			bullet.removeEventListener(CollisionEvent.COLLISION, bullet.collisionHandler);
			bullet.removeEventListener(BulletObjectBase.EVENT_TYPE_SELF_DISPOSE, selfDisposeHandler);
			_bulletLayer.removeChild(bullet);
		}
		
		override public function collisionHandler(event:CollisionEvent):void
		{
			startExplosion(event.data.dx, event.data.dy);

			life--;
			if (life <= 0) {
				vx = vy = 0;
				// ボスが死ぬときはボールが衝突しても反応させない
				removeEventListener(CollisionEvent.COLLISION, collisionHandler);
				startDefeatedEffect();
			}
		}
		
		private function startExplosion(dx:int, dy:int):void
		{
			var frames:Vector.<Texture> = AssetsManager.getTextureAtlas(_explosionTexture);
			var sound:Sound = AssetsManager.getSound(_explosionSound);
			var explosion:ExplosionObjectBase = new _explosionClass(sound, frames);
			explosion.target = this;
			explosion.dx = dx;
			explosion.dy = dy;
			explosion.addEventListener(Event.COMPLETE, explosionCompleteHandler);
			_explosionLayer.addChild(explosion);
		}

		private function explosionCompleteHandler(e:Event):void
		{
			var explosion:ExplosionObjectBase = e.currentTarget as ExplosionObjectBase;
			_explosionLayer.removeChild(explosion);
			explosion.removeEventListener(Event.COMPLETE, explosionCompleteHandler);
			explosion.dispose();
		}
		
		private function enterFrameHandler(e:Event):void
		{
			x += vx;
			if (x - pivotX < Const.SCREEN_WIDTH / 6
				|| x + pivotX > Const.SCREEN_WIDTH * 5 / 6)
			{
				vx = -vx;
				x += vx; // 境界から少し離して境界で毎フレーム反射を繰り返さないようにするう
			}
		}
		
		private function startDefeatedEffect():void
		{
			_defeatedEffectTimer.addEventListener(TimerEvent.TIMER, defeatedEffectTimerHandler);
			_defeatedEffectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, defeatedEffectTimerCompleteHandler);
			_defeatedEffectTimer.start();
		}
		
		protected function defeatedEffectTimerHandler(event:TimerEvent):void
		{
			var dx:int = (Math.random() - 0.5) * width;
			var dy:int = (Math.random() - 0.5) * height;
			startExplosion(dx, dy);
		}

		protected function defeatedEffectTimerCompleteHandler(event:TimerEvent):void
		{
			_defeatedEffectTimer.stop();
			_defeatedEffectTimer.removeEventListener(TimerEvent.TIMER, defeatedEffectTimerHandler);
			_defeatedEffectTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, defeatedEffectTimerCompleteHandler);
			_defeatedEffectTimer = null;
			dispatchEvent(new Event(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE));
		}
	}
}