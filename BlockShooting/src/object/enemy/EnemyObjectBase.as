package object.enemy
{
	import object.CollisionEvent;
	import object.ImageObjectBase;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;

	public class EnemyObjectBase extends ImageObjectBase implements IFEnemy
	{
		protected var _life:int;
		protected var _bulletInterval:int;
		protected var _bulletSpeed:int;
		protected var _bulletTexture:String = null;
		protected var _bulletClass:Class;
		protected var _bulletLayer:Sprite;
		protected var _explosionTexture:String = null;
		protected var _explosionSound:String = null;
		protected var _explosionClass:Class;
		protected var _explosionLayer:Sprite;
		protected var _initX:int;
		protected var _initY:int;
		protected var _initVx:int;
		protected var _isBarCollisionTarget:Boolean = false;
		protected var _reboundBall:Boolean = true;
		
		public static const EVENT_TYPE_SELF_DISPOSE:String = "selfDispose";

		public function EnemyObjectBase(texture:Texture)
		{
			super(texture);
		}

		public function start():void
		{
			x = _initX;
			y = _initY;
		}

		public function stop():void
		{
			
		}

		public function collisionHandler(event:CollisionEvent):void
		{
			_life = _life - 1;
			if (_life < 1)
			{
				dispatchEvent(new Event(EnemyObjectBase.EVENT_TYPE_SELF_DISPOSE));
			}
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life = value;
		}

		public function set bulletInterval(value:int):void
		{
			_bulletInterval = value;
		}

		public function get bulletSpeed():int
		{
			return _bulletSpeed;
		}

		public function set bulletSpeed(value:int):void
		{
			_bulletSpeed = value;
		}

		public function set bulletTexture(value:String):void
		{
			_bulletTexture = value;
		}

		public function set bulletClass(value:Class):void
		{
			_bulletClass = value;
		}

		public function set bulletLayer(value:Sprite):void
		{
			_bulletLayer = value;
		}

		public function set explosionTexture(value:String):void
		{
			_explosionTexture = value;
		}

		public function set explosionSound(value:String):void
		{
			_explosionSound = value;
		}

		public function set explosionClass(value:Class):void
		{
			_explosionClass = value;
		}

		public function set explosionLayer(value:Sprite):void
		{
			_explosionLayer = value;
		}

		public function set initX(value:int):void
		{
			_initX = value;
		}

		public function set initY(value:int):void
		{
			_initY = value;
		}

		public function set initVx(value:int):void
		{
			_initVx = value;
		}

		public function get isBarCollisionTarget():Boolean
		{
			return _isBarCollisionTarget;
		}

		public function get reboundBall():Boolean
		{
			return _reboundBall;
		}

	}
}