//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| All BollingerMartin input variables should be defined here.
//+------------------------------------------------------------------+
#property strict

extern string  IndicatorSetup = "<<< Indicator parameters >>>";
// Parameters for big period indicator
input int BigFastEMA= 4800;
input int BigSlowEMA= 10368;
input int BigSignalSMA= 432;
// Parameters for Bollinger Bands indicator
input int BollingerPeriod= 20;
input int BollingerDeviation= 2;
input int BollingerCrossBars=2;
// Points between two adjacent martin orders
input int MartinInitPoints=250;
input int MartinMinProfitPoints = 200;
input double MartinPointsMultiple = 2.0;

//+------------------------------------------------------------------+
