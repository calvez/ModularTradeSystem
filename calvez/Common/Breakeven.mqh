//+------------------------------------------------------------------+
//|                                                 Breakeven.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
input string special3 = "<<< Breakeven Settings >>>"; // ----------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Inputs
//-------------------------------------------------------------------------
input int BE = 20;                  //Break-Even Stop (pips)
input int LockBE = 5;               // Lock breakeven profit

//-------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------
int b;
double pip;
bool w;
//-------------------------------------------------------------------------
// 1. Main function
//-------------------------------------------------------------------------
void Breakeven(void)
  {

//--- 1.1. Define pip -----------------------------------------------------
   if(Digits==4 || Digits<=2) pip=Point;
   if(Digits==5 || Digits==3) pip=Point*10;

//--- 1.2. Break-Even -----------------------------------------------------
   for(b=0;b<OrdersTotal();b++)
     {
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && BE>0 && OrderProfit()>0)
           {
            if( OrderType()==OP_BUY && OrderOpenPrice()+BE*pip+LockBE*pip<=Bid && OrderStopLoss()<OrderOpenPrice()) 
            w=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0);

            if( OrderType()==OP_SELL && OrderOpenPrice()-BE*pip-LockBE*pip>=Ask && (OrderStopLoss()>OrderOpenPrice() || OrderStopLoss()==0)) 
            w=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0);
           }
        }
     }

//--- 1.3. End of main function -------------------------------------------
   return;
  }
//-------------------------------------------------------------------------