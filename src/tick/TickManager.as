package   tick
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	public class TickManager
	{
		private static var g_Instance:TickManager;
		
		private var m_TickContainer:DisplayObject;
		private var m_TickList:Vector.<Tick>;
		private var m_LastTime:int;
		private var m_Accelerate:Boolean = false;
		
		public function TickManager(enforcer:SingletonEnforcer)
		{
			if(!enforcer) throw new Error("singletonEnforcer");
			enforcer = null;
			m_TickList = new Vector.<Tick>;
		}
		
		public static function GetInstance():TickManager
		{
			return g_Instance || (g_Instance = new TickManager(new SingletonEnforcer()));
		}
		
		public function getTickCount():int
		{
			return m_TickList.length;
		}
		
		public function getSleepTickCount():int
		{
			var count:int;
			for each(var tick1:Tick in m_TickList)
			{
				if(tick1.isStop()) count++;	
			}
			return count;
		}
		
		public function setup(container:DisplayObject):void
		{
			m_TickContainer = container;
			if(m_TickContainer) 
			{
//				var timer:Timer = new Timer(10);
//				timer.addEventListener(TimerEvent.TIMER,onTimer);
//				timer.start();
				m_TickContainer.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				if(m_Accelerate) m_LastTime = getTimer();
				else m_LastTime = (new Date).time;
			}
		}
		
		/**屏蔽加速**/
		public function setAccelerate(flag:Boolean = false):void
		{
			m_Accelerate = flag;
			if(m_Accelerate) m_LastTime = getTimer();
			else m_LastTime = (new Date).time;
		}
		
		public function addTick(tick:Tick):void
		{
			if(null == m_TickList) return;
			if(m_TickList.indexOf(tick) == -1)
				m_TickList.push(tick);
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			m_LastTime = getTimer();
			trace(m_LastTime);
			if(null == m_TickList) return;
			var len:int = m_TickList.length;
			var tick1:Tick;
			for(var i:int = len - 1; i >= 0; i--) 
			{
				tick1 = m_TickList[i];
				if(tick1 && !tick1.isEnd())
				{
					tick1.onTick(30);
				}
				else 
				{
					m_TickList.splice(i,1);
				}
			}
		}
		
		private function onEnterFrame(evt:Event):void
		{
			if(null == m_TickList) return;
			var nowTime:Number;
			if(m_Accelerate) nowTime = getTimer();
			else nowTime = (new Date).time;
			var timeElapsed:Number = nowTime - m_LastTime;
			m_LastTime = nowTime; 
			var len:int = m_TickList.length;
			var tick1:Tick;
			for(var i:int = len - 1; i >= 0; i--) 
			{
				tick1 = m_TickList[i];
				if(tick1 && !tick1.isEnd())
				{
					tick1.onTick(timeElapsed);
				}
				else 
				{
					m_TickList.splice(i,1);
				}
			}
		}
		
		public function onDispose():void
		{
			if(m_TickList)
			{
				for each(var tick1:Tick in m_TickList)
				{
					tick1.dispose();	
				}
				m_TickList = null;				
			}
			if(m_TickContainer) 
			{
				m_TickContainer.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				m_TickContainer = null;
			}
		}
		
		public function onClear():void {}
	}
}

class SingletonEnforcer
{
	
}