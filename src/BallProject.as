package
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import core.com.greensock.TweenLite;
	
	import tick.Tick;
	import tick.TickManager;
	
	/**
	 * @author cyb
	 * 创建时间：2015-9-6 下午8:12:59
	 * 
	 */
	[SWF(width = "1280", height = "960", frameRate = "30", backgroundColor = "0xffffff")] 
	public class BallProject extends Sprite
	{
		public function BallProject()
		{
			TickManager.GetInstance().setup(this);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			for (var i:int = 0;i < 1000;i++)
			{
				creatBall();
			}
			ballTick =  new Tick(30);
			ballTick.setCallBack(tickHandler);
			ballTick.start();
			
			initDevice();
		}
		
		private static const TOP_LEFT:Point = new Point(0, 0);
		private var device:Kinect;
		private var depthImage:Bitmap;
		
		
		//private var userMasks:Vector.<Bitmap>;
		private var userMaskDictionary:Dictionary;
		public function initDevice():void
		{
			if (Kinect.isSupported()) 
			{
				trace("[UserMaskDemo] Start Kinect");
				
			//	depthImage = new Bitmap();
				//addChild(depthImage);
				
				//userMasks = new Vector.<Bitmap>();
				userMaskDictionary = new Dictionary();
				
				device = Kinect.getDevice();
				
				///device.addEventListener(UserEvent.USERS_ADDED, usersAddedHandler, false, 0, true);
				//device.addEventListener(UserEvent.USERS_REMOVED, usersRemovedHandler, false, 0, true);
			//	device.addEventListener(UserEvent.USERS_MASK_IMAGE_UPDATE, usersMaskImageUpdateHandler, false, 0, true);
				
				var settings:KinectSettings = new KinectSettings();
				
				settings.userMaskEnabled = true;
				settings.userMaskResolution = CameraResolution.RESOLUTION_320_240;
				
				
				APPTick = new Tick(300);
				APPTick.setCallBack(appHandler);
				APPTick.start();
				//initUI(settings);
				
				device.start(settings);
			}
		}
		
		private function appHandler():void
		{
			if( device.users.length == 0)
			{
				return;
			}
			for each(var user:User in device.users) 
			{
				var bitmapdata:BitmapData = user.userMaskData;
				if(bitmapdata == null)
				{
					return;
				}
				//APPTick.stop();
				var roundCenterList:Array = [];
				var p:Point;
				//trace(user.position.world.z);
				var len:int = 0;
				
				var rect:Rectangle = bitmapdata.getColorBoundsRect(0xff000000,0x00000000,false);
				var rowCount:int = Math.ceil(rect.height/8);
				var colCount:int = Math.ceil(rect.width/8);
				for(var i:int = 0;i < rowCount;i++)
				{
					for(var j:int = 0;j < colCount;j++)
					{
						if (bitmapdata.getPixel32(rect.x + j *8,i * 8 + rect.y))
						{
							
								var itemBall:Ball  = ballList[len++];
								itemBall.stop();
								//userBodys.push(itemBall);
								itemBall.x = rect.x + j *8;
								itemBall.y = i * 8 + rect.y;
								//roundCenterList.push(p);
							
						}
					}
				}
			
				//userMaskDictionary[user.userID] = userBodys;
			}
			
//			if(personTick == null)
//			{
//				personTick = new Tick(300);
//				personTick.setCallBack(personHandler);
//				personTick.start();
//			}
		}
		
		public static var MAX_PERSON_NUM:int = 1;
		protected function usersMaskImageUpdateHandler(event:UserEvent):void 
		{
			for each(var user:User in event.users) 
			{
//				var bmp:Bitmap = userMaskDictionary[user.userID];
//				if (bmp != null) 
//				{
//					bmp.bitmapData = user.userMaskData;
//				}
			}
		}
		
		
		protected function usersRemovedHandler(event:UserEvent):void 
		{
			for each(var user:User in event.users) 
			{
				delete userMaskDictionary[user.userID]
			}
			//layout();
		}
		
		private var APPTick:Tick;
		private var len:int;
		private var userBodys:Array = [];
		protected function usersAddedHandler(event:UserEvent):void 
		{
			for each(var user:User in event.users) 
			{
				
				
				
			}
		}
		
		
		
		private function personHandler():void
		{
			for each(var user:User in device.users) 
			{
				var bitmapdata:BitmapData = user.userMaskData;
				var bodyBalls:Array = userMaskDictionary[user.userID];
				var p:Point;
				var roundCenterList:Array = [];
				for(var i:int = 0;i < bitmapdata.width;i++)
				{
					for(var j:int = 0;j < bitmapdata.height;j++)
					{
						if (bitmapdata.getPixel32(i,j))
						{
							if (bitmapdata.getPixel32(i,j))
							{
								p = new Point(i,j);
								var roundHave:Boolean = false;
								for each(var centerPoint:Point in roundCenterList)
								{
									if(Point.distance(centerPoint,p) < 20)
									{
										roundHave = true;
										break;
									}
								}
								if(!roundHave)
								{
									roundCenterList.push(p);
								}
							}
						} 
					}
				}
				var ballLen:int = bodyBalls.length;
				for(i = 0; i < roundCenterList.length;i++)
				{
					var ball:Ball;
					if( i <  ballLen)
					{
						ball = bodyBalls[i];
						ball.x = roundCenterList[i].x;
						ball.y = roundCenterList[i].y;
					} 
					
				}
				userMaskDictionary[user.userID] = userBodys;
			}
		}
		
		private var personTick:Tick;
		private function tickHandler():void
		{
			for each(var itemBall:Ball in ballList)
			{
				itemBall.render();
			}
		}
		
		
		
		private var sw:Number = 1280; //Stage Widht，舞台宽，自定
		private var sh:Number = 960; //Stage Height，舞台高，自定
		
		public var ballList:Array = [];
		private var ballTick:Tick
		
		protected function creatBall():void
		{
			//创建小球
			
			var i:int = Math.round(Math.random() *6);
			var ball:Ball = new Ball(i + 1);
			//随机位置
			ball.x = Math.random()*sw;
			ball.y = Math.random()*sh;
			//随机速度和方向
			ball.speedX = RandomUtility.range(-1,1,false);;
			ball.speedY =  RandomUtility.range(-1,1,false);;
			//因为小球的坐标原点是小球的中心，所以用该函数用来调整小球位置，防止移出边界
			adjustBall(ball);
			//添加小球到显示列表
			addChild(ball);
			ballList.push(ball);
			//用ENTER_FRAME侦听器使小球运动
		}
		
		protected function adjustBall(mc:Sprite):void
		{
			if(mc.x >= sw-mc.width/2)
			{
				mc.x = sw-mc.width/2;
			}
			if(mc.x <= mc.width/2)
			{
				mc.x = mc.width/2
			};
			if(mc.y >= sh-mc.height/2)
			{
				mc.y = sh-mc.height/2;
			}
			if(mc.y <= mc.height/2)
			{
				mc.y = mc.height/2;
			}
		}
		
		
	}
}