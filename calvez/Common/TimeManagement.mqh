//+------------------------------------------------------------------+
//|                                               TimeManagement.mqh |
//|                                                   A.Lopatin 2017 |
//|                                              diver.stv@gmail.com |
//+------------------------------------------------------------------+
#property copyright "A.Lopatin 2017"
#property link      "diver.stv@gmail.com"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string special4 = "<<<  Trading Time Settings (uses BrokerTime) >>>"; // ----------------------------------------------------------------------------
input bool    UseTimeManagement    = true; //Enable/disable time management
input int     StartHour            = 3;   //Start hour (0-24) of trade
input int     StartMinutes         = 00;   //Start minutes (0-59) of trade
input int     EndHour              = 21;   //End hour (0-24) of trade
input int     EndMinutes           = 00;   //End minutes (0-24) of trade
input bool    UseDayManagement     = false;//Enable/disable day management
input bool    TradeMonday          = true; //On/off trade on monday
input bool    TradeTuesday         = true; //On/off trade on tuesday
input bool    TradeWednesday       = true; //On/off trade on wednesday
input bool    TradeThursday        = true; //On/off trade on thursday
input bool    TradeFriday          = true; //On/off trade on friday
//+-------------------------------------------------------------------+
//|  The function checks time for a trade.                            |
//|  It returns true - trade is allowed, false - trade is not allowed |
//+-------------------------------------------------------------------+
bool CheckTime()
  {
   bool result=false;

   if(UseTimeManagement)
     {
      LogR("Checking Time... ");
      datetime curr_time=TimeCurrent(),start_time=StrToTime(StringConcatenate(StartHour,":",StartMinutes)),
               end_time=StrToTime(StringConcatenate(EndHour,":",EndMinutes));

      if((end_time>start_time && start_time<=curr_time && end_time>=curr_time)
         || (end_time<=start_time && (start_time<=curr_time || end_time>=curr_time)))
         result=true;
     }
   else
      result=true;

   return result;
  }
//+-------------------------------------------------------------------+
//|  The function checks week day for a trade.                        |
//|  It returns true - trade is allowed, false - trade is not allowed |
//+-------------------------------------------------------------------+
bool CheckDayOfWeek()
  {
   bool result=false;

   if(!UseDayManagement)
      result=true;
   else
     {
      int day_week=DayOfWeek();

      if(TradeMonday && day_week==1)
         result=true;
      if(TradeTuesday && day_week==2)
         result=true;
      if(TradeWednesday && day_week==3)
         result=true;
      if(TradeThursday && day_week==4)
         result=true;
      if(TradeFriday && day_week==5)
         result=true;
     }

   return result;
  }
//+------------------------------------------------------------------+
