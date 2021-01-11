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
#include "Common\ATR.mqh"
#include "Common\Breakeven.mqh"

//// custom settings

string eaName = "LCFX - base";

// protection settings

bool protection = false;

datetime ValidTo = D'31.10.2021';// What date to deactivate expert adviser
int Acc = 0000;                // Account number restriction to use in real account mode

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RealAccRestriction = true;  // Use Real Account restrictions(Do not use with DemoRestriction)
bool DateRestriction= true;      // Use Date expiration(both real and demo mode)
// end of protection settings

CTradeSystemController *controller = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(protection)
     {
      if(RealAccRestriction)//Is Real account number restriction in use?If yes and trading mode do check, else skip and continue
        {
         if(AccountNumber()!=Acc)//Is account real? If yes, do check and see if account number match or not
           {
            Alert("Real account number do not match! Registered account: " + (string)Acc);//Alert user if account number don't match
            ExpertRemove();//Remove adviser from chart
            return(INIT_FAILED);//Initiation failed due to wrong account number
           }
        }
      if(!IsTesting()&& DateRestriction)//Is Date restriction in use and trading mode, if yes do check else skip and continue
        {
         if(TimeCurrent()>ValidTo)//Has current date exceeded set date?If yes continue do alert, else skip and continue
           {
            Alert("Licence Expired");//Alert user if date exceeded
            ExpertRemove();//Remove adviser from chart
            return(INIT_FAILED);//Initiation failed due to exceeded date
           }
        }
     }
   ATR_TF = TF_Selector(ATR_TimeFrame);

   LogR("OnInit... account id: " + (string)Acc);
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
// Check breakeven
   Breakeven();
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

   if(Set_StopLoss)
      SetStopLoss();
   if(Set_TakeProfit)
      SetTakeProfit();
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
