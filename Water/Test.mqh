//+------------------------------------------------------------------+
//|                                                         Test.mqh |
//|                                    Copyright 2020, Michael Wade. |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict
#include "Common\OrderManager.mqh"

bool IsTestOrderOpened = false; // Mark the test order is open
//+------------------------------------------------------------------+
//| TestSendMail                                                                 |
//+------------------------------------------------------------------+
void TestSendMail()
  {
   int ticket = 17528285;
   SendMail("New order！",GetOrderByTicket(ticket).ToFormatMail());
  }

//+------------------------------------------------------------------+
//| Test Open Order At Specified Time                                                                 |
//+------------------------------------------------------------------+
void TestOpenOrderAtSpecifiedTime()
  {
   if(!IsTestOrderOpened && TimeCurrent()> (D'2020.05.11 14:00') && TimeCurrent()< (D'2020.05.11 14:30'))
     {
      OpenOrder(false,CMoneyManager::GetOpenLots()*2);
      IsTestOrderOpened = true;
     }
  }
//+------------------------------------------------------------------+
