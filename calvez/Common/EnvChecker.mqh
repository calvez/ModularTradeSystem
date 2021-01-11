//+------------------------------------------------------------------+
//|                                                   EnvChecker.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| Responsible for checking the operating environment
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"
#include "MoneyManager.mqh"

//+------------------------------------------------------------------+
//| Check environment                                                                 |
//+------------------------------------------------------------------+
bool CheckEnv()
  {
   return  CMoneyManager::HasEnoughMoney() && CMoneyManager::HasEnoughMargin() && isBarsEnough() && IsAllowedTrade();
  }

//+------------------------------------------------------------------+
//| Check bars                                                                |
//+------------------------------------------------------------------+
bool isBarsEnough()
  {
   if(Bars<100)
     {
      Print("Bars less than 100! PLS check");
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Check if the allow automatic trading option is checked                                                                |
//+------------------------------------------------------------------+
bool IsAllowedTrade()
  {
   if(!IsTradeAllowed())
     {
      Print("Automatic trading isn't allowed! PLS check");
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
