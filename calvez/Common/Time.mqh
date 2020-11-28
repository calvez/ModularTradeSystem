//+------------------------------------------------------------------+
//|                                                     Time.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| Provide some utils about CheckTradingTimes
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"

bool CheckTradingTimes()
{
   //This code contributed by squalou. Many thanks, sq.

   int hour = TimeHour(TimeLocal() );

   if (end_hourm < start_hourm)
	{
		end_hourm += 24;
	}


	if (end_houre < start_houre)
	{
		end_houre += 24;
	}

	bool ok2Trade = true;

	ok2Trade = (hour >= start_hourm && hour <= end_hourm) || (hour >= start_houre && hour <= end_houre);

	// adjust for past-end-of-day cases
	// eg in AUS, USDJPY trades 09-17 and 22-06
	// so, the above check failed, check if it is because of this condition
	if (!ok2Trade && hour < 12)
	{
 		hour += 24;
		ok2Trade = (hour >= start_hourm && hour <= end_hourm) || (hour >= start_houre && hour <= end_houre);
		// so, if the trading hours are 11pm - 6am and the time is between  midnight to 11am, (say, 5am)
		// the above code will result in comparing 5+24 to see if it is between 23 (11pm) and 30(6+24), which it is...
	}


   // check for end of day by looking at *both* end-hours

   if (hour >= MathMax(end_hourm, end_houre))
   {
      ok2Trade = false;
   }//if (hour >= MathMax(end_hourm, end_houre))

   return(ok2Trade);

}//bool CheckTradingTimes()