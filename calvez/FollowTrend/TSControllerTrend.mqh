//+------------------------------------------------------------------+
//|                                        TradeSystemController.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
#property strict
#include "..\Common\TradeSystemController.mqh"
#include "..\Common\ISignalEngine.mqh"
#include "..\Common\OrderManager.mqh"
#include "..\Common\Log.mqh"
#include "..\Common\Const.mqh"
#include "SignalEngineTrend.mqh"

//+------------------------------------------------------------------+
//| The controller is the main logical part of the trading system.
//| It processes the original signal data and combines it with other data
//| for comprehensive analysis, and finally outputs the execution signal.                                                             |
//+------------------------------------------------------------------+
class CTSControllerTrend:public CTradeSystemController
  {
private:
   static const string  TAG;
   ISignalEngine     *m_signal_engine;
   CSignalData       m_signal_data;
   bool              ShouldOpenBuy();
   bool              ShouldOpenSell();
   bool              ShouldCloseBuy(COrder &order);
   bool              ShouldCloseSell(COrder &order);
public:
                     CTSControllerTrend();
                    ~CTSControllerTrend();
   int               ComputeTradeSignal();
   int               GetSafeState();
   void              SetSingalConsumed(const bool isConsumed);
  };

const string CTSControllerTrend::TAG = "CTSControllerTrend";
//+------------------------------------------------------------------+
//| Constructor with initialization list                                                           |
//+------------------------------------------------------------------+
CTSControllerTrend::CTSControllerTrend():m_signal_engine(NULL)
  {
   m_signal_engine = new CSignalEngineTrend;
   LogR(TAG,"Controller Object is created");
  }
//+------------------------------------------------------------------+
//| Destructor                                                                 |
//+------------------------------------------------------------------+
CTSControllerTrend::~CTSControllerTrend()
  {
   delete(m_signal_engine);
   LogR(TAG,"Controller Object is deleted");
  }

//+------------------------------------------------------------------+
//| Compute Signal Data，called in onTick() function.
//| ATTENTION: It must be called before calling controller's other member functions
//+------------------------------------------------------------------+
int CTSControllerTrend::ComputeTradeSignal()
  {
   CSignalData new_signal_data = m_signal_engine.GetSignalData();
// if the ArtificialOrientation input variable is set, then choose the manual signal,
// Otherwise choose the machine signal.
   if(ArtificialOrientation != ORI_NO)
      new_signal_data.orientation = ArtificialOrientation;
// The new signal is taken only if the signal content changes,
// otherwise keep holding the old signal.
   if(m_signal_data != new_signal_data)
     {
      m_signal_data = new_signal_data;
     }
   LogD(TAG,"ComputeSignalData..."+m_signal_data.ToString());
   if(ShouldOpenBuy())
      return SIGNAL_OPEN_BUY;
   if(ShouldOpenSell())
      return SIGNAL_OPEN_SELL;
   COrder totalOrder = GetAllOrdersAsOne();
   if(ShouldCloseBuy(totalOrder))
      return SIGNAL_CLOSE_BUY;
   if(ShouldCloseSell(totalOrder))
      return SIGNAL_CLOSE_SELL;
   return SIGNAL_NO;
  }

//+------------------------------------------------------------------+
//| When to open BUY order                                                                |
//+------------------------------------------------------------------+
bool CTSControllerTrend::ShouldOpenBuy()
  {
   return  IsEmptyPositionsCurSymbol()
           !m_signal_data.is_consumed &&
           (m_signal_data.orientation == ORIENTATION_UP || m_signal_data.orientation == ORIENTATION_HOR) &&
           m_signal_data.open_signal == SIGNAL_OPEN_BUY;//&& !IsCloseToSameTypeOrders(true);
  }

//+------------------------------------------------------------------+
//| When to open SELL order                                                                   |
//+------------------------------------------------------------------+
bool CTSControllerTrend::ShouldOpenSell()
  {
   return   IsEmptyPositionsCurSymbol()
            !m_signal_data.is_consumed &&
            (m_signal_data.orientation == ORIENTATION_DW || m_signal_data.orientation == ORIENTATION_HOR) &&
            m_signal_data.open_signal == SIGNAL_OPEN_SELL; // && IsCloseToSameTypeOrders(false);
  }

//+------------------------------------------------------------------+
//| When to close BUY order
//| Current strategy：Multiple orders are also treated as a single order
//+------------------------------------------------------------------+
bool CTSControllerTrend::ShouldCloseBuy(COrder &order)
  {
   return  order.type==ORDER_BUY &&
           order.profit > MinProfit &&
           m_signal_data.close_signal == SIGNAL_CLOSE_BUY;
  }

//+------------------------------------------------------------------+
//| When to close SELL order
//+------------------------------------------------------------------+
bool CTSControllerTrend::ShouldCloseSell(COrder &order)
  {
   return  order.type==ORDER_SELL &&
           order.profit > MinProfit &&
           m_signal_data.close_signal == SIGNAL_CLOSE_SELL;
  }

//+------------------------------------------------------------------+
//| You must set a signal consumed after doing some actions according to it,
//| otherwise the signal will continuously trigger your actions.                                                             |
//+------------------------------------------------------------------+
void CTSControllerTrend::SetSingalConsumed(const bool isConsumed)
  {
   m_signal_data.is_consumed = isConsumed;
  }

//+------------------------------------------------------------------+
//| Get the position safe state                                                             |
//+------------------------------------------------------------------+
int  CTSControllerTrend::GetSafeState()
  {
   COrder totalOrder = GetAllOrdersAsOne();
//Log(TAG,"IsPositionDangerous..."+totalOrder.ToString());
   int state = POSITION_STATE_SAFE;
// if total profit is positive, never mind.
   if(totalOrder.profit>=0)
      return state;
// when totalorder's type is BUY
   if(totalOrder.type==ORDER_BUY && m_signal_data.close_signal == SIGNAL_CLOSE_BUY)
     {
      state = POSITION_STATE_WARN;  // level warn
      if(m_signal_data.orientation==ORIENTATION_DW)
         state = POSITION_STATE_DANG;
     }
// when totalorder's type is SELL
   if(totalOrder.type==ORDER_SELL && m_signal_data.close_signal == SIGNAL_CLOSE_SELL)
     {
      state = POSITION_STATE_WARN;
      if(m_signal_data.orientation==ORIENTATION_UP)
         state = POSITION_STATE_DANG; // level dangerous
     }
   return state;
  }

//+------------------------------------------------------------------+
