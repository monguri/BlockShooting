package object.ball
{
	import asset.AssetsManager;
	
	import common.Const;
	
	import flash.display.Bitmap;
	
	import object.CollisionEvent;
	import object.ImageObjectBase;
	import object.lifeCounter.LifeCounter;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Ball extends ImageObjectBase
	{
		/** ボールの速度 */
		public static const BALL_SPEED:int = 5;

		private var _texture:Texture;

		public function Ball()
		{
			var texture:Texture = AssetsManager.getTexture("BallBitmap");
			super(texture);
		}

		public function start():void
		{
			// ピボットを中心点に設定
			pivotX = width >> 1;
			pivotY = height >> 1;
			
			// 初期位置を設定
			x = Const.SCREEN_WIDTH >> 1;
//			y = Const.SCREEN_HEIGHT * 2 / 6;
			y = Const.SCREEN_HEIGHT >> 1;

			// 初速を設定
			_vx = BALL_SPEED / 3.0;
			_vy = -BALL_SPEED * 2.0 / 3.0;
		
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(CollisionEvent.COLLISION, collisionHandler);
		}
		
		public function stop():void
		{
			removeEventListener(CollisionEvent.COLLISION, collisionHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		public function enterFrameHandler(event:Event):void
		{
			x += _vx;
			y += _vy;
			
			// 画面端との衝突処理はここで書く
			if (x < 0)
			{
				vx = -_vx;
			}
			else if (x > Const.SCREEN_WIDTH)
			{
				_vx = -_vx;
			}
			else if (y < 0)
			{
				_vy = -_vy;
			}
			else if (y > Const.SCREEN_HEIGHT)
			{
				var e:Event = new Event(LifeCounter.LIFE_LOST, true);
				dispatchEvent(e);
				stop();
				start();
			}
		}

		private function collisionHandler(e:CollisionEvent):void
		{
			x += e.data.nextStartDx as Number;
			y += e.data.nextStartDy as Number;
			_vx = e.data.nextVx as Number;
			_vy = e.data.nextVy as Number;
		}

	}
}