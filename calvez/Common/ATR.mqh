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
int NumOfDays_D = 1;
bool M6_enabled = true;
bool M6_Trading_weighting = true;
int Recent_Days_Weighting = 5;
bool Weighting_to_ADR_percentage = true;
int NumOfDays_6M = 180;

int      DistanceL, DistanceHv, DistanceH, Distance6Mv, Distance6M, DistanceMv, DistanceM, DistanceYv, DistanceY, DistanceADRv, DistanceADR, Distance6Mv_new, Distance6M_new;

double pnt;
int    dig;
string objname = "DRPE";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSumDays
{
public:
   double            m_sum;
   int               m_days;
                     CSumDays(double sum, int days)
   {
      m_sum = sum;
      m_days = days;
   }
};
 double TodayOpenBuffer[];
//+------------------------------------------------------------------+
int initADR()
{
   //+------------------------------------------------------------------+
   pnt = MarketInfo(Symbol(), MODE_POINT);
   dig = MarketInfo(Symbol(), MODE_DIGITS);
   if(dig == 3 || dig == 5)
   {
      pnt *= 10;
   }
   return(0);
}

//+------------------------------------------------------------------+
int startADR()
{
   int lastbar;
   int counted_bars= IndicatorCounted();
   if (counted_bars>0) counted_bars--;
   lastbar = Bars-counted_bars;	
   
  
//+------------------------------------------------------------------+
   CSumDays sum_day(0, 0);
   CSumDays sum_m(0, 0);
   CSumDays sum_6m(0, 0);
   CSumDays sum_6m_add(0, 0);
   range(NumOfDays_D, sum_day);
   range(GridAtrPeriod, sum_m);
   range(NumOfDays_6M, sum_6m);
   range(Recent_Days_Weighting, sum_6m_add);
   double hi = iHigh(NULL, PERIOD_D1, 0);
   double lo = iLow(NULL, PERIOD_D1, 0);
   if(pnt > 0)
   {
      string Y, M, M6, H, L, ADR;
      double m, m6, h, l;
      Y = DoubleToStr(sum_day.m_sum / sum_day.m_days / pnt, 0);
      m = sum_m.m_sum / sum_m.m_days / pnt;
      M = DoubleToStr(sum_m.m_sum / sum_m.m_days / pnt, 0);
      m6 = sum_6m.m_sum / sum_6m.m_days;
      h = (hi - Bid) / pnt;
      H = DoubleToStr((hi - Bid) / pnt, 0);
      l = (Bid - lo) / pnt;
      L = DoubleToStr((Bid - lo) / pnt, 0);
      Print("Y: " + Y, " M: " + M, " H: " + H, " L: " + H); 
      if(m6 == 0) return 0;
      double ADR_val;
      if(Weighting_to_ADR_percentage)
      {
        double WADR = ((iHigh(NULL, PERIOD_D1, 0) - iLow(NULL, PERIOD_D1, 0)) + (iHigh(NULL, PERIOD_D1, 1) - iLow(NULL, PERIOD_D1, 1)) + (iHigh(NULL, PERIOD_D1, 2) - iLow(NULL, PERIOD_D1, 2)) +
                       (iHigh(NULL, PERIOD_D1, 3) - iLow(NULL, PERIOD_D1, 3)) + (iHigh(NULL, PERIOD_D1, 4) - iLow(NULL, PERIOD_D1, 4))) / 5;
        double val = (m6 + WADR) / 2 / pnt;
        ADR_val=(h + l) / val * 100;
        ADR = DoubleToStr(ADR_val, 0);
        Print("Weighting_to_ADR_percentage: " + ADR); 
      }
      else
      {
        ADR_val=(h + l) / (m6 / pnt) * 100;
        ADR = DoubleToStr(ADR_val, 0);
        Print(" ! Weighting_to_ADR_percentage: " + ADR); 
      }
      if(M6_Trading_weighting)
      {
         m6 = (m6 + sum_6m_add.m_sum / sum_6m_add.m_days) / 2;        
      }
      m6 = m6 / pnt;
      M6 = DoubleToStr(m6, 0);
      Print("m6: " + M6); 

      

   }
    double Yesterday = sum_day.m_sum / sum_day.m_days / pnt;
    Comment("Yesterday RANGE (" + DoubleToStr(Yesterday, 0) + ")");

   return Yesterday;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void range(int days, CSumDays &sumdays)
{
   sumdays.m_days = 0;
   sumdays.m_sum = 0;
   for(int i = 1; i < Bars - 1; i++)
   {
      double hi = iHigh(NULL, PERIOD_D1, i);
      double lo = iLow(NULL, PERIOD_D1, i);
      datetime dt = iTime(NULL, PERIOD_D1, i);
      if(TimeDayOfWeek(dt) > 0 && TimeDayOfWeek(dt) < 6)
      {
         sumdays.m_sum += hi - lo;
         sumdays.m_days = sumdays.m_days + 1;
         if(sumdays.m_days >= days) break;
      }
   }
}

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+

double GetAtr(string symbol, int tf, int period, int shift)
{
   //Returns the value of atr
   
   return(iATR(symbol, tf, period, shift) );   

}//End double GetAtr()
