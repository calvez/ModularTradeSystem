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
bool _run=true;

datetime ValidTo = D'10.12.2020';//What date to deactivate expert adviser
int      Acc     = 123456;       //Account number restriction to use in real account mode
//////////////////////////////////
bool DateRestriction=true;////////Use Date expiration(both real and demo mode)
//////////////////////////////////
bool DemoRestriction=false;////////Use Demo account restriction(Do not use with RealAccRestriction)
//////////////////////////////////
bool RealAccRestriction=true;/////Use Real Account restrictions(Do not use with DemoRestriction)

CTradeSystemController *controller = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//---Work only on demo account
   if(!IsDemo()&&DemoRestriction)//Is Demo restriction in use?If yes do demo check else skip and continue
     {
      Alert("Account not demo!");//Alert user that account is not demo!
      ExpertRemove();//Remove adviser from chart
      return(INIT_FAILED);//Initiation failed due to wrong account type
     }
//--Only certain account number work on real accounts
   if(RealAccRestriction)//Is Real account number restriction in use?If yes and trading mode do check, else skip and continue
     {
      if(!IsDemo()&& AccountNumber()!=Acc)//Is account real? If yes, do check and see if account number match or not
        {
         Alert("Real account number do not match!");//Alert user if account number don't match
         ExpertRemove();//Remove adviser from chart
         return(INIT_FAILED);//Initiation failed due to wrong account number
        }
     }
//--Adviser will stop working in trading mode when reaching set date
   if(!IsTesting()&& DateRestriction)//Is Date restriction in use and trading mode, if yes do check else skip and continue
     {
      if(TimeCurrent()>ValidTo)//Has current date exceeded set date?If yes continue do alert, else skip and continue
        {
         Alert("Licence Expired");//Alert user if date exceeded
         ExpertRemove();//Remove adviser from chart
         return(INIT_FAILED);//Initiation failed due to exceeded date
        }
     }
//---
   if(!IsTesting())
      _run=false;  
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
