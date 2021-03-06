//+------------------------------------------------------------------+
//|                                        SignalEngineBollinger.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict
#include "..\Common\ISignalEngine.mqh"
#include "..\Common\Const.mqh"
#include "..\Common\Input.mqh"
#include "..\Common\Log.mqh"
#include "..\Common\ShowUtil.mqh"
#include "InputBollinger.mqh"

//+------------------------------------------------------------------+
//| The specific implementation class of the signal engine interface:
//| It implements the unified interface in ISignalEngine.mqh and
//| independently encapsulate the signal calculation logic.
//| You can customize your signal calculation logic here.                                                           |
//+------------------------------------------------------------------+
class CSignalEngineBollinger : public ISignalEngine
  {
private:
   static const string TAG;
   int               m_big_cross;
   int               m_small_cross;
   int               m_big_trend;
   int               GetBigTrend();
   void              GetSmallCross();
   int               GetOrientation();
   int               GetOpenSignal();
   int               GetCloseSignal();
   CSignalData       CreateSignalData();
   void              ShowOriginalSignalInfo();
public:
                     CSignalEngineBollinger():m_big_cross(CROSS_NO),m_small_cross(CROSS_NO),m_big_trend(TREND_NO) { Print("CSignalEngineBollinger was born"); }
                    ~CSignalEngineBollinger() { Print("CSignalEngineBollinger is dead");  }
   //--- Implementing the virtual methods of the ISignalEngine interface
   CSignalData       GetSignalData();
  };

const string CSignalEngineBollinger::TAG = "CSignalEngineBollinger";

//+------------------------------------------------------------------+
//| For the outside world to obtain original signal data                                                                 |
//+------------------------------------------------------------------+
CSignalData CSignalEngineBollinger::GetSignalData()
  {
   m_big_trend = GetBigTrend();
   GetSmallCross();
//Log(TAG,"GetSignalData..."+StringConcatenate("m_big_trend=",m_big_trend,",m_small_trend=",m_small_trend));
   ShowOriginalSignalInfo();
   return CreateSignalData();
  }

//+------------------------------------------------------------------+
//| Create a CSignalData instance                                                                 |
//+------------------------------------------------------------------+
CSignalData CSignalEngineBollinger::CreateSignalData()
  {
   CSignalData data;
   data.orientation = GetOrientation();
   data.open_signal = GetOpenSignal();
   data.close_signal = GetCloseSignal();
   return data;
  }

//+------------------------------------------------------------------+
//| Get trading orientation                                                                 |
//+------------------------------------------------------------------+
int CSignalEngineBollinger::GetOrientation()
  {
   switch(m_big_trend)
     {
      case TREND_UP:
         return ORIENTATION_UP;
      case TREND_DW:
         return ORIENTATION_DW;
     }
   return ORIENTATION_NO;
  }

//+------------------------------------------------------------------+
//| Get signal to open a position                                                                  |
//+------------------------------------------------------------------+
int CSignalEngineBollinger::GetOpenSignal()
  {
   if(m_small_cross == CROSS_GLOD)
      return SIGNAL_OPEN_BUY;
   if(m_small_cross == CROSS_DEAD)
      return SIGNAL_OPEN_SELL;
   return SIGNAL_NO;
  }

//+------------------------------------------------------------------+
//| Get signal to close a position                                                                      |
//+------------------------------------------------------------------+
int CSignalEngineBollinger::GetCloseSignal()
  {
   if(m_small_cross == CROSS_DEAD)
      return SIGNAL_CLOSE_BUY;
   if(m_small_cross == CROSS_GLOD)
      return SIGNAL_CLOSE_SELL;
   return SIGNAL_NO;
  }

//+------------------------------------------------------------------+
//| Get the big timeframe trend
//+------------------------------------------------------------------+
int CSignalEngineBollinger::GetBigTrend()
  {
   double macdCurrent=iMACD(NULL,0,BigFastEMA,BigSlowEMA,BigSignalSMA,PRICE_CLOSE,MODE_MAIN,1);
   double signalCurrent=iMACD(NULL,0,BigFastEMA,BigSlowEMA,BigSignalSMA,PRICE_CLOSE,MODE_SIGNAL,1);
   if(macdCurrent == signalCurrent)
      return TREND_NO;
   return macdCurrent > signalCurrent ? TREND_UP : TREND_DW;
  }

//+------------------------------------------------------------------+
//| Get the small timeframe trend
//+------------------------------------------------------------------+
void CSignalEngineBollinger::GetSmallCross()
  {
   double bollUpperCur = iBands(NULL,0,BollingerPeriod,BollingerDeviation,0,PRICE_CLOSE,MODE_UPPER,1); // upper track
   double bollUpperPre = iBands(NULL,0,BollingerPeriod,BollingerDeviation,0,PRICE_CLOSE,MODE_UPPER,BollingerCrossBars); // upper track
   double bollLowerCur = iBands(NULL,0,BollingerPeriod,BollingerDeviation,0,PRICE_CLOSE,MODE_LOWER,1); // lower track
   double bollLowerPre = iBands(NULL,0,BollingerPeriod,BollingerDeviation,0,PRICE_CLOSE,MODE_LOWER,BollingerCrossBars); // lower track
// Get the cross signal
   if(Close[1] > bollLowerCur && Close[BollingerCrossBars] <= bollLowerPre)
      m_small_cross = CROSS_GLOD;
   else
      if(Close[1] < bollUpperCur && Close[BollingerCrossBars] >= bollUpperPre)
         m_small_cross = CROSS_DEAD;
      else
         m_small_cross = CROSS_NO;
  }

//+------------------------------------------------------------------+
//| Show original signal infomation on screen immediately                                                               |
//+------------------------------------------------------------------+
void CSignalEngineBollinger::ShowOriginalSignalInfo()
  {   
   ShowLable("BigIndicator",StringConcatenate("BigIndicator:",BigFastEMA," ",BigSlowEMA," ",BigSignalSMA),0,0,40,10,"",Red);
   ShowLable("SmallCross",StringConcatenate("SmallCross:",m_small_cross),0,0,80,15,"",Red);
   ShowLable("BigTrend",StringConcatenate("BigTrend:",m_big_trend),0,0,100,15,"",Red);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
