package object.lifeCounter
{
	import asset.AssetsManager;
	
	import common.Const;
	
	import flash.display.Bitmap;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class LifeCounter extends DisplayObjectContainer
	{
		[Embed(source = "assets/minibar.png")]
		private static const BallBitmap:Class;

		private var _life:TextField;

		/** ライフ減少イベントの識別子 */
		public static const LIFE_LOST:String = "lifeLost";

		public function LifeCounter()
		{
			var texture:Texture = AssetsManager.getTexture("MiniBarBitmap");
			var lifeImage:Image = new Image(texture);
			lifeImage.pivotX = lifeImage.width >> 1;
			lifeImage.pivotY = lifeImage.height >> 1;
			lifeImage.x = Const.SCREEN_WIDTH - 92;
			lifeImage.y = 24;
			addChild(lifeImage);

			_life = new TextField(24, 36, "");
			_life.pivotY = _life.height >> 1;
			_life.x = Const.SCREEN_WIDTH - 48;
			_life.y = 24;
			_life.color = 0xffffff;
			_life.fontSize = 36;
			_life.autoScale = true;
			addChild(_life);
		}
		
		public function setLifeCounter(value:uint):void
		{
			_life.text = value.toString();
		}
	}
}