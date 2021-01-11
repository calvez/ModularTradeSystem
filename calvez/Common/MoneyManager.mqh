//+------------------------------------------------------------------+
//|                                                 MoneyManager.mqh |
//|                                         Copyright 2020, @calvez  |
//|                                              https://t.me/calvez |
//+------------------------------------------------------------------+
//| Money Manager : Responsible for money-related operations                                                             |
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"
#include "Input.mqh"
#include "Log.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyManager
  {
private:
   static const string TAG;
   static double     MaxEquity;

public:
                     CMoneyManager(void);
                    ~CMoneyManager(void);
   static bool       HasEnoughMoney(void);
   static bool       HasEnoughMargin(void);
   static double     GetInitLots(void);
   static double     GetAddLots(void);
   static double     GetOpenLots(void);
   static double     GetSymbolProfit(void);
   static void       UpdateMaxEquity(void);
   static double     GetDrawdownPercent(void);
   static double     GetProfitPercent(void);
  };

const string CMoneyManager::TAG = "CMoneyManager";
double CMoneyManager::MaxEquity = 0;

double AccountMarginLevel =  (AccountEquity() / 100);

//+------------------------------------------------------------------+
//| Check if your money is enough                                                                 |
//+------------------------------------------------------------------+
bool CMoneyManager::HasEnoughMoney(void)
  {
   if(AccountFreeMargin()< MoneyAtLeast)
     {
      LogR(TAG,"Your money is not enough! FreeMargin = ",DoubleToStr(AccountFreeMargin()));
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Check if your money is margin                                                                 |
//+------------------------------------------------------------------+
bool CMoneyManager::HasEnoughMargin(void)
  {
   if(AccountFreeMargin()< MoneyAtLeast)
     {
      LogR(TAG,"Your margin is not enough for new trades! FreeMargin = ",DoubleToStr(AccountFreeMargin()));
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Calculate the lots to open                                                                    |
//+------------------------------------------------------------------+
double CMoneyManager::GetOpenLots(void)
  {
   return GetAddLots(); //GetInitLots();
  }

//+------------------------------------------------------------------+
//| Calculate the initial lots to open                                                            |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyManager::GetInitLots(void)
  {
   if(!FixedRiskMode)
     {
      double lot=MathCeil(AccountFreeMargin()*Risk/1000)/100;
      if(lot<MarketInfo(Symbol(),MODE_MINLOT))
         lot=MarketInfo(Symbol(),MODE_MINLOT);
      if(lot>MarketInfo(Symbol(),MODE_MAXLOT))
         lot=MarketInfo(Symbol(),MODE_MAXLOT);

      //double lots=NormalizeDouble(AccountBalance()/(MoneyEveryLot*2),1);

      LogR(TAG,StringConcatenate("AccountBalance = ",AccountBalance(),",lots = ",lot));
      return lot;
     }
   else
     {
      double lot=FixedRisk;
      return lot;
     }
  }

//+------------------------------------------------------------------+
//| Calculate the add lots to open                                                                  |
//+------------------------------------------------------------------+
double CMoneyManager::GetAddLots(void)
  {
   double maxLots = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      double orderLots = OrderLots();
      if(orderLots>maxLots)
         maxLots = orderLots;
     }
   return maxLots == 0? GetInitLots():maxLots*AddLotsMultiple;
  }

//+------------------------------------------------------------------+
//| Get the total profit of the current symbol                                                                 |
//+------------------------------------------------------------------+
double CMoneyManager::GetSymbolProfit()
  {
   double totalProfit = 0;
   int  total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      totalProfit+=OrderProfit();
     }
   return totalProfit;
  }

//+------------------------------------------------------------------+
//| Updating the max equity, which should be called in onTick()                                                                 |
//+------------------------------------------------------------------+
void CMoneyManager::UpdateMaxEquity()
  {
   MaxEquity = AccountEquity()>MaxEquity? AccountEquity():MaxEquity;
  }

//+------------------------------------------------------------------+
//| Get the drawdown percentage                                                                  |
//+------------------------------------------------------------------+
double CMoneyManager::GetDrawdownPercent()
  {
   return 100*(AccountEquity()-MaxEquity)/MaxEquity;
  }

//+------------------------------------------------------------------+
//| Get the profit percentage                                                                    |
//+------------------------------------------------------------------+
double CMoneyManager::GetProfitPercent()
  {
   return AccountProfit()/AccountBalance();
  }
//+------------------------------------------------------------------+
