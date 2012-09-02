package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width="640", height="960", frameRate="60", backgroundColor="#000000")]

	public class BlockShooting extends Sprite
	{
		public function BlockShooting()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			Starling.multitouchEnabled = true;
			Starling.handleLostContext = false;

			var rootStarling:Starling = new Starling(RootStarling, stage);
			rootStarling.simulateMultitouch = false;
			rootStarling.enableErrorChecking = false;
			rootStarling.start();
		}
	}
}