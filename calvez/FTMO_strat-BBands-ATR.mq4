//+------------------------------------------------------------------+
//|                                                        clvz.mq4  |
//|                                         Copyright 2020, @calvez  |
//|                                              https://t.me/kr7ea  |
//+------------------------------------------------------------------+
#property strict
#property version "2.704"
#property copyright "Copyright © 2020, @calvez"
#property link "https://www.lowcostforex.io"
#property icon "\\Images\\lcfx.ico"
#property description "All in one multi currency trader."
#property strict

#include "Common\MoneyManager.mqh"
#include "Common\OrderManager.mqh"
#include "Common\EnvChecker.mqh"
#include "Common\TradeSystemController.mqh"
#include "Common\Log.mqh"
#include "Common\ShowUtil.mqh"
#include "Common\Const.mqh"
#include "Common\TSControllerFactory.mqh"

CTradeSystemController *controller = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   LogR("OnInit...");
   controller = CTSControllerFactory::Create();
   EventSetTimer(60);   // Trigger timer every 60 seconds
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   LogR("OnDeinit...reason=",IntegerToString(reason));
   delete(controller);
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   LogR("OnTimer...");
   CheckSafe();
   Print("Account free margin = ",AccountFreeMargin());
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Check the runtime environment
   if(!CheckEnv())
      return;
// Update the max equity
   CMoneyManager::UpdateMaxEquity();
// Process trade signals
   ProcessTradeSignals();
// Show some info on screen
   ShowInfo();
// Check Order SL TP
   SetTPSL();
  }

//+------------------------------------------------------------------+
//| Process trade signals, and check when to open or close orders
//+------------------------------------------------------------------+
void ProcessTradeSignals()
  {
   int signal = controller.ComputeTradeSignal();
   switch(signal)
     {
      case SIGNAL_OPEN_BUY:
         if(OpenBuy())
            controller.SetSingalConsumed(true);
         break;
      case SIGNAL_OPEN_SELL:
         if(OpenSell())
            controller.SetSingalConsumed(true);
         break;
      case SIGNAL_CLOSE_BUY:
      case SIGNAL_CLOSE_SELL:
         CloseOrder();
     }

// CheckStopLoss(); // TODO
// CheckTakeProfit(); // TODO
  }

//+------------------------------------------------------------------+
//| Check the safety of the position regularly,
//| to see if there is no need for manual intervention                                                              |
//+------------------------------------------------------------------+
void CheckSafe()
  {
   int state = controller.GetSafeState();
   string msg = "";
   switch(state)
     {
      case POSITION_STATE_WARN:
         msg = "Your "+_Symbol+" position is NOT SAFE! Pls check.";
         Print(msg);
         if(AllowMail)
            SendMail("Attention!",msg);
         break;
      case POSITION_STATE_DANG:
         msg = "Your "+_Symbol+" position is DANGEROUS! Pls check.";
         Print(msg);
         if(AllowMail)
            SendMail("Dangerous!",msg);
         if(AllowHedge)
            OpenHedgePosition(true);
     }
  }

//+------------------------------------------------------------------+
//| Show some key information on screen immediately                                                                |
//+------------------------------------------------------------------+
void ShowInfo()
  {
// show profit
   double totalProfit = CMoneyManager::GetSymbolProfit();
   string profitContent = "               Profit:"+DoubleToStr(totalProfit,2)+"("+DoubleToStr(100*totalProfit/AccountBalance(),2)+"%)";
   ShowDynamicText("Profit",profitContent,0,0);
// show drawdown
   double drawdown  = CMoneyManager::GetDrawdownPercent();
   string drawdownContent = "               Drawdown:"+DoubleToStr(drawdown,2)+"%";
   ShowDynamicText("Drawdown",drawdownContent,0,-200);
  }

//+------------------------------------------------------------------+

void SetTPSL()
{
   int TicketNo=-1;
   for(int cc=OrdersTotal()-1; cc>=0; cc--)
   {
   if(!OrderSelect(cc,SELECT_BY_POS,MODE_TRADES)) continue;
      TicketNo=OrderTicket();
      eDigits=int(MarketInfo(_Symbol,MODE_DIGITS));
      ask = NormalizeDouble(MarketInfo(_Symbol, MODE_ASK),eDigits);
      bid = NormalizeDouble(MarketInfo(_Symbol, MODE_BID),eDigits);
      factor=GetPipFactor(_Symbol);
      if(NormalizeDouble(OrderStopLoss(),eDigits)==0) SetInitialSL(TicketNo,factor,eDigits);
      if(NormalizeDouble(OrderTakeProfit(),eDigits)==0) SetInitialTP(TicketNo,factor,eDigits);
   }

}