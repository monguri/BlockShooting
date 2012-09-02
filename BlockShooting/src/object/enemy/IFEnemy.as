package object.enemy
{
	import object.CollisionEvent;

	public interface IFEnemy
	{
		function start():void;
		function stop():void;
		function collisionHandler(event:CollisionEvent):void;
	}
}
