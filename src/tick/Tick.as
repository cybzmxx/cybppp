package   tick
{

	/**
	 * 计时器
	 * @author cyb
	 * 
	 */
	public class Tick 
	{
		private var m_Timer:int = 0;
		private var m_StopTime:int = 0;	//停止时间
		private var m_AccumulativeTime:int = 0;	//累计时间
		private var m_StopFlag:Boolean = true;
		private var m_EndFlag:Boolean = false;
		private var m_CallBack:Function;
		private var m_RenderCall:Function;
		protected var m_Delay:uint;
		
		/**
		 *只要传入毫秒数，就会多少时间执行一次 
		 * @param pDelay
		 * @param stopTime
		 * 
		 */
		public function Tick(pDelay:uint = 17,stopTime:uint = 0)
		{
			m_Delay = pDelay;
			m_StopTime = stopTime;
			TickManager.GetInstance().addTick(this);
		}
		
		public function setDelay(delay:uint):void 
		{
			m_Delay = delay;
		}
		
		public function setCallBack(callBack:Function):void 
		{
			m_CallBack = callBack;
		}
		
		//具体执行过程，使用override
		protected function update():void 
		{
			if(null != m_CallBack) m_CallBack();
		}
		
		//这里把计算和渲染分开，用于帧数降低时候，避免无谓的渲染消耗
		protected function render(timeElapsed:int):void 
		{
			if(null != m_RenderCall) m_RenderCall(timeElapsed);
		}
		
		public function setRenderCallBack(callBack:Function):void 
		{
			m_RenderCall = callBack;
		}
		
		public function onTick(timeElapsed:int):void
		{
			if(isEnd()) return;
			if(isStop()) return;
			if(m_StopTime > 0)
			{
				//TODO njw:这里面有个错误，不太精确，会导致应该执行的update()没有执行
				m_AccumulativeTime += timeElapsed;
				if(m_AccumulativeTime > m_StopTime)
				{
					stop();
					return;	
				}
			}
			if(m_Delay > 0) 
			{
				m_Timer += timeElapsed;
//				var count:int = m_Timer / m_Delay;
//				if(count > 0)
//				{
//					if(count == 2) count = 1;
//					m_Timer = m_Timer % m_Delay;
//					while(count)
//					{
//						update();
//						count--;
//						if(isEnd()) break;
//						if(isStop()) break;
//					}	
//				}
								
				while(m_Timer >= m_Delay)
				{
					update();
					m_Timer -= m_Delay;
					if(isEnd()) break;
					if(isStop()) break;
				}
			}

			render(timeElapsed);
		}
		
		public function start():void
		{
			m_StopFlag = false;
		}
		
		public function reStart():void
		{
			m_StopFlag = false;
			m_Timer = 0;
			m_AccumulativeTime = 0;
			//先执行一次
//			update();
		}
		
		public function stop():void
		{
			m_StopFlag = true;
//			trace("stop");
		}
		
		public function isStop():Boolean
		{
			return m_StopFlag;
		}
		
		public function isEnd():Boolean
		{
			return m_EndFlag;
		}
		
		public function onClear():void {}
		
		public function dispose():void
		{
			stop();
			m_CallBack = null;
			m_RenderCall = null;
			m_EndFlag = true;
		}
	}
}