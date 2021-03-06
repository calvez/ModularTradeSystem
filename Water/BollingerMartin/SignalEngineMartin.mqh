//+------------------------------------------------------------------+
//|                                           SignalEngineMartin.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict
#include "..\Common\ISignalEngine.mqh"
#include "..\Common\Const.mqh"
#include "..\Common\Input.mqh"
#include "..\Common\Log.mqh"
#include "..\Common\ShowUtil.mqh"
#include "..\Common\OrderManager.mqh"

//+------------------------------------------------------------------+
//| The specific implementation class of the signal engine interface:
//| It implements the unified interface in ISignalEngine.mqh and
//| independently encapsulate the signal calculation logic.
//| You can customize your signal calculation logic here.                                                           |
//+------------------------------------------------------------------+
class CSignalEngineMartin : public ISignalEngine
  {
private:
   static const string TAG;
   int               m_big_trend;
   int               GetOrientation();
   int               GetOpenSignal();
   int               GetCloseSignal();
   CSignalData       CreateSignalData();
public:
                     CSignalEngineMartin():m_big_trend(TREND_NO) { Print("CSignalEngineMartin was born"); }
                    ~CSignalEngineMartin() { Print("CSignalEngineMartin is dead");  }
   //--- Implementing the virtual methods of the ISignalEngine interface
   CSignalData       GetSignalData();
  };

const string CSignalEngineMartin::TAG = "CSignalEngineMartin";

//+------------------------------------------------------------------+
//| For the outside world to obtain original signal data                                                                 |
//+------------------------------------------------------------------+
CSignalData CSignalEngineMartin::GetSignalData()
  {
//Log(TAG,"GetSignalData..."+StringConcatenate("m_big_trend=",m_big_trend,",m_small_trend=",m_small_trend));
   return CreateSignalData();
  }

//+------------------------------------------------------------------+
//| Create a CSignalData instance                                                                 |
//+------------------------------------------------------------------+
CSignalData CSignalEngineMartin::CreateSignalData()
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
int CSignalEngineMartin::GetOrientation()
  {
   m_big_trend = TREND_NO;
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
int CSignalEngineMartin::GetOpenSignal()
  {
// get the last matin buy order
   COrder lastMartinOrder = GetLastMartinOrder(true);
   int orderCounts = GetOrderCountsCurSymbol(true);
   double MartinPoints = MartinInitPoints*MathPow(MartinPointsMultiple,orderCounts-1);
   LogD(TAG,"lastMartinOrder..."+StringConcatenate("ticket=",lastMartinOrder.ticket,",openPrice=",lastMartinOrder.openPrice));
   if(lastMartinOrder.ticket>0 && Ask < lastMartinOrder.openPrice - MartinPoints*Point)
      return SIGNAL_OPEN_BUY;
// get the last matin buy order
   lastMartinOrder = GetLastMartinOrder(false);
   orderCounts = GetOrderCountsCurSymbol(false);
   MartinPoints = MartinInitPoints*MathPow(MartinPointsMultiple,orderCounts-1);
   //Log(TAG,"lastMartinOrder..."+StringConcatenate("ticket=",lastMartinOrder.ticket,",openPrice=",lastMartinOrder.openPrice));
   if(lastMartinOrder.ticket>0 && Bid > lastMartinOrder.openPrice + MartinPoints*Point)
      return SIGNAL_OPEN_SELL;
   return SIGNAL_NO;
  }

//+------------------------------------------------------------------+
//| Get signal to close marting orders                                                                      |
//+------------------------------------------------------------------+
int CSignalEngineMartin::GetCloseSignal()
  {
   COrder totalOrder = GetAllOrdersAsOne();
   if(totalOrder.type==ORDER_BUY && (totalOrder.profit > MartinMinProfitPoints*totalOrder.lots))// || CMoneyManager::GetProfitPercent()<MaxAccountRiskPercent))
      return SIGNAL_CLOSE_BUY;
   if(totalOrder.type==ORDER_SELL && (totalOrder.profit > MartinMinProfitPoints*totalOrder.lots)) //|| CMoneyManager::GetProfitPercent()<MaxAccountRiskPercent))
      return SIGNAL_CLOSE_SELL;
   return SIGNAL_NO;
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
