//+------------------------------------------------------------------+
//|                                                 ATR.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| ATR values
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| check ATR values                                                 |
//+------------------------------------------------------------------+

#property strict
int eDigits;
double ask=0;
double bid=0;
double digiter;
double minDistanceSLTP=1;
double SLMinDistanceToPrice=45;
double TakeProfitATRPips = 0;
double StopLossATRPips = 0;
double adr;
string  modmsg;
string line = "--------------------------------------------------------";
double GetAtr(string symbol, int tf, int period, int shift)
{
   //Returns the value of atr
   
   return(iATR(symbol, tf, period, shift) );   

}//End double GetAtr()


double CalculateSLBuy(int ticket,double Xfactor,int Xdigits)
{
   ask = NormalizeDouble(MarketInfo(_Symbol, MODE_ASK),Xdigits);
   bid = NormalizeDouble(MarketInfo(_Symbol, MODE_BID),Xdigits);
   double CalculatedBuySL=0;
   if(Xdigits==5) digiter=0.1;
   else if(Xdigits==3) digiter=0.1;
   else digiter=1;
   if(useATRForStopLoss==true)
     {

      adr=GetAtr(_Symbol,atrForStopLossTF,atrPeriodForStopLoss,0);
      if(adr==0)adr=MathAbs(iHigh(_Symbol,PERIOD_W1,1)-iLow(_Symbol,PERIOD_W1,1));
      StopLossATRPips = NormalizeDouble((atrMultiplicatorForStopLoss*adr*Xfactor),0);
     }

   CalculatedBuySL=NormalizeDouble(OrderOpenPrice()-(StopLossATRPips/Xfactor),Xdigits);
   if(OrderType()==OP_BUY)
     {
      if(bid<CalculatedBuySL+minDistanceSLTP/Xfactor)
        {
         CalculatedBuySL=NormalizeDouble(bid-(SLMinDistanceToPrice/Xfactor),Xdigits);
        }
     }

   return(CalculatedBuySL);     
}

double CalculateSLSell(int ticket,double Xfactor,int Xdigits)
{
   ask=NormalizeDouble(MarketInfo(_Symbol,MODE_ASK),Xdigits);
   bid=NormalizeDouble(MarketInfo(_Symbol,MODE_BID),Xdigits);
   double CalculatedSellSL=0;
   if(Xdigits==5) digiter=0.1;
   else if(Xdigits==3) digiter=0.1;
   else digiter=1;

   if(useATRForStopLoss==true)
     {

      adr=GetAtr(_Symbol,atrForStopLossTF,atrPeriodForStopLoss,0);
      if(adr==0)adr=MathAbs(iHigh(_Symbol,PERIOD_W1,1)-iLow(_Symbol,PERIOD_W1,1));
      StopLossATRPips =NormalizeDouble((atrMultiplicatorForStopLoss*adr*Xfactor),0);
     }
   CalculatedSellSL=NormalizeDouble(OrderOpenPrice()+(StopLossATRPips/Xfactor),Xdigits);
   if(OrderType()==OP_SELL)
     {
      if(ask>CalculatedSellSL-minDistanceSLTP/Xfactor)
        {
         CalculatedSellSL=NormalizeDouble(ask+(SLMinDistanceToPrice/Xfactor),Xdigits);
        }
     }
     return (CalculatedSellSL);
}

double CalculateTPBuy(int ticket,double Xfactor,int Xdigits)
{
   ask=NormalizeDouble(MarketInfo(_Symbol,MODE_ASK),Xdigits);
   bid=NormalizeDouble(MarketInfo(_Symbol,MODE_BID),Xdigits);
   double CalculatedBuyTP=0;
   if(Xdigits==5) digiter=0.1;
   else if(Xdigits==3) digiter=0.1;
   else digiter=1;
   if(useATRForTakeProfit==true)
     {

      adr=GetAtr(_Symbol,atrForTakeProfitTF,atrPeriodForTakeProfit,0);
      if(adr==0)adr=MathAbs(iHigh(_Symbol,PERIOD_W1,1)-iLow(_Symbol,PERIOD_W1,1));
      TakeProfitATRPips=NormalizeDouble((atrMultiplicatorForTakeProfit*adr*Xfactor),0);
     }
   CalculatedBuyTP=NormalizeDouble(OrderOpenPrice()+(TakeProfitATRPips/Xfactor),Xdigits);
   if(bid>CalculatedBuyTP-minDistanceSLTP/Xfactor)
     {
      CalculatedBuyTP=NormalizeDouble(bid+(SLMinDistanceToPrice/Xfactor),Xdigits);
     }

   return(CalculatedBuyTP);     
}

double CalculateTPSell(int ticket,double Xfactor,int Xdigits)
{
   ask = NormalizeDouble(MarketInfo(_Symbol, MODE_ASK),Xdigits);
   bid = NormalizeDouble(MarketInfo(_Symbol, MODE_BID),Xdigits);
   double CalculatedSellTP=0;
   if(Xdigits==5) digiter=0.1;
   else if(Xdigits==3) digiter=0.1;
   else digiter=1;

   if(useATRForTakeProfit==true)
     {

      adr=GetAtr(_Symbol,atrForTakeProfitTF,atrPeriodForTakeProfit,0);
      if(adr==0)adr=MathAbs(iHigh(_Symbol,PERIOD_W1,1)-iLow(_Symbol,PERIOD_W1,1));
      TakeProfitATRPips=NormalizeDouble((atrMultiplicatorForTakeProfit*adr*Xfactor),0);
     }
   CalculatedSellTP=NormalizeDouble(OrderOpenPrice()-(TakeProfitATRPips/Xfactor),Xdigits);
   if(ask<CalculatedSellTP-minDistanceSLTP/Xfactor)
     {
      CalculatedSellTP=NormalizeDouble(ask-(SLMinDistanceToPrice/Xfactor),Xdigits);
     }

   return (CalculatedSellTP);
}


void SetInitialSL(int ticket,double Xfactor,int Xdigits)
  {
   bool modify=false;
   double NewStop=0;
   bool selectedOrder=OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
   if(selectedOrder==false) return;//in case the trade closed
   ask = NormalizeDouble(MarketInfo(_Symbol, MODE_ASK),Xdigits);
   bid = NormalizeDouble(MarketInfo(_Symbol, MODE_BID),Xdigits);
   if(OrderType()==OP_BUY)
     {

      NewStop=CalculateSLBuy(ticket,Xfactor,Xdigits);

      modify=true;

     }//if (OrderType() == OP_BUY)

   if(OrderType()==OP_SELL)
     {

      NewStop=CalculateSLSell(ticket,Xfactor,Xdigits);

      modify=true;

     }//if (OrderType() == OP_SELL)

//Send the new stop loss 
   if(modify==true)
     {
      bool result=OrderModify(ticket,OrderOpenPrice(),NewStop,OrderTakeProfit(),OrderExpiration(),CLR_NONE);

      if(!result && OrderType()==OP_SELL)
        {
         NewStop=NewStop+(0.1/Xfactor);
         result=OrderModify(ticket,OrderOpenPrice(),NewStop,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
         modmsg = "!!! SetInitialSL !!!" + _Symbol+" position modified: ";
         Print(modmsg);
         Print(line);

        }//if (!result)
      if(!result && OrderType()==OP_BUY)
        {
         NewStop=NewStop-(0.1/Xfactor);
         result=OrderModify(ticket,OrderOpenPrice(),NewStop,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
         modmsg = "!!! SetInitialSL !!!" + _Symbol+" position modified: ";
         Print(modmsg);
         Print(line);
        }//if (!result)

     }

  }//void SetInitialSL()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetInitialTP(int ticket,double Xfactor,int Xdigits)
  {
   bool modify=false;
   double NewTP=0;
   bool selectedOrder=OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
   if(selectedOrder==false) return;//in case the trade closed
   ask = NormalizeDouble(MarketInfo(_Symbol, MODE_ASK),Xdigits);
   bid = NormalizeDouble(MarketInfo(_Symbol, MODE_BID),Xdigits);
   if(OrderType()==OP_BUY)
     {

      NewTP=CalculateTPBuy(ticket,Xfactor,Xdigits);

      modify=true;

     }
   if(OrderType()==OP_SELL)
     {

      NewTP=CalculateTPSell(ticket,Xfactor,Xdigits);

      modify=true;

     }//if (OrderType() == OP_SELL)

//Send the new stop loss 
   if(modify==true)
     {
      bool result=OrderModify(ticket,OrderOpenPrice(),OrderStopLoss(),NewTP,OrderExpiration(),CLR_NONE);

      if(!result && OrderType()==OP_SELL)
        {
         NewTP=NewTP-(0.1/Xfactor);
         result=OrderModify(ticket,OrderOpenPrice(),OrderStopLoss(),NewTP,OrderExpiration(),CLR_NONE);
         modmsg = "!!! SetInitialTP !!!" + _Symbol+" position modified: ";
         Print(modmsg);
         Print(line);

        }//if (!result)
      if(!result && OrderType()==OP_BUY)
        {
         NewTP=NewTP+(0.1/Xfactor);
         result=OrderModify(ticket,OrderOpenPrice(),OrderStopLoss(),NewTP,OrderExpiration(),CLR_NONE);
         modmsg = "!!! SetInitialTP !!!" + _Symbol+" position modified: ";
         Print(modmsg);
         Print(line);

        }//if (!result)

     }

  }
