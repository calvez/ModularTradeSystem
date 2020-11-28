//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| All BollingerMartin input variables should be defined here.
//+------------------------------------------------------------------+
#property strict

// Parameters for big period indicator
input int BigFastEMA= 100;
input int BigSlowEMA= 216;
input int BigSignalSMA= 9;
// Parameters for Bollinger Bands indicator
input int BollingerPeriod= 20;
input int BollingerDeviation= 2;
input int BollingerCrossBars=2;
// Points between two adjacent martin orders
input int MartinInitPoints=350;
input int MartinMinProfitPoints = 300;
input double MartinPointsMultiple = 1.8;

//+------------------------------------------------------------------+
