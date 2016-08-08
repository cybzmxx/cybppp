package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * @author cyb
	 * 创建时间：2015-9-6 下午8:03:27
	 * 
	 */
	public class Ball extends Sprite
	{
		public var stopFlag:Boolean;
		public function stop():void
		{
			stopFlag = true;
		}
		public function render():void
		{
			if(stopFlag)
			{
				return;
			}
			this.x += this.speedX;
			this.y += this.speedY;
			//检测小球是否碰到舞台边界
			if(this.x >= 1280 - this.width/2 )
			{
				this.x = 1280 - this.width/2
				this.speedX *= -1;
			}
			if( this.x <= this.width/2)
			{
				this.x = this.width/2
				this.speedX *= -1;
			}
			if(this.y >= 960 - this.height/2 )
			{
				this.y = 960 - this.height/2;
				this.speedY *= -1;
			}
			if( this.y <= this.height / 2)
			{
				this.y = this.height / 2
				this.speedY *= -1;
			}
		}
		
		public var index:int;
		public function Ball(i:int)
		{
			super();
			var mc:MovieClip;
			if(i == 1)
			{
				mc = new  BallSkin1;
			}
			else if (i == 2)
			{
				mc = new  BallSkin2;
			}
			else if (i == 3)
			{
				mc = new  BallSkin3;
			}
			else if (i == 4)
			{
				mc = new  BallSkin4;
			}
			else if (i == 5)
			{
				mc = new  BallSkin5;
			}
			else if (i == 6)
			{ 
				mc = new  BallSkin6;
			}
			else if (i == 7)
			{
				mc = new  BallSkin7;
			}
			
			addChild(mc);
		}
		public var speedX:Number;
		public var speedY:Number;
	}
}