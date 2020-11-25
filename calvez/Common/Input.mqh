//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| All input variables should be defined here.
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"

input string special1 = " ---- General Settings ----------------------------------- "; // ----------------------------------------------------------------------------

input bool IsDebugMode = true;             // Choose running mode,debug or release
bool AllowAutoTrade = true;               // Whether to allow automated trading
input bool AllowMail = false;              // Whether to allow email
input bool AllowHedge = true;              // Whether to allow hedge
input bool AllowMartin = true;             // Whether to allow using Martingale strategy
input int MinIntervalPoints = 500;         // Minimum points between 2 same type orders
input int Slippage = 50;                   // Maximum acceptable slippage
input double MoneyAtLeast = 1000.0;        // How much money must be in the account
input double MoneyEveryLot = 100000.0;     // How much money is needed for opening one lot position
input double DefaultLots = 0.01;           // Default initial lot
input double AddLotsMultiple = 1.8;        // The lot multiple to add positions
input double MaxAccountRiskPercent = -1.0; // Max Account Risk Percent
input int MaxOrderCounts = 4;
input string special2 = " ---- TP and SL settings --------------------------------- "; // ----------------------------------------------------------------------------
input bool useATRForStopLoss = false;                                                   // use ATR For Stop Loss (true overrides other settings)
input ENUM_TIMEFRAMES atrForStopLossTF = PERIOD_H4;                                    // ATR For Stop Loss TF
input double atrMultiplicatorForStopLoss = 1;                                          // ATR Multiplicator For Stop Loss
input int atrPeriodForStopLoss = 14;                                                   // ATR Period For StopLoss
input double SL = 500;                                                                  // SL if no ATR
input bool useATRForTakeProfit = false;                                                 // use ATR for TP (true overrides other settings)
input ENUM_TIMEFRAMES atrForTakeProfitTF = PERIOD_H4;                                  // ATR For TP TF
input double atrMultiplicatorForTakeProfit = 3.0;                                      // ATR Multiplicator For TP
input int atrPeriodForTakeProfit = 14;                                                 // ATR Period For TP
input double TP = 1000;                                                                // TP if no ATR
input string partSet = " ---- Partial Close Inputs ---- ";                             // ----------------------------------------------------------------------------
input bool PartCloseEnabled = false;                                                   // partial close enabled
input double PartClosePercent = 10;                                                    // partial close percent
input bool PartCloseWithBE = false;                                                    // partial close with BE
input bool PartCloseAsFirstTP = true;                                                  // partial close as First TP
input bool SetBEonPartCloseFirstTP = false;                                            // Set BE on partial close First TP
input bool useATRForPartClosePips = true;                                              // use ATR for partial close (true overrides other settings)
input ENUM_TIMEFRAMES atrForPartClosePipsTF = PERIOD_H4;                               // ATR for partial close pips TF
input double atrMultiplicatorForPartClosePips = 0.5;                                   // ATR multiplicator For partial close pips
input int atrPeriodForPartClosePips = 14;                                              // ATR period For partial close pips
input double PartCloseFirstTpPips = 25;                                                // partial close First TP pips
input string special3 = " ---- Special Basket TP/SL Option in Account Currency ---- "; // ----------------------------------------------------------------------------
input bool UseBasketSLTP = false;                                                      // Use Basket SL TP
input bool UseBasketSLTPinAccountCurr = false;                                         // Use Basket SL TP in Account Curr
input double BasketSL = 500;                                                           // Basket SL
input double BasketTP = 750;                                                           // Basket TP
input bool UseBasketSLTPinPips = true;                                                 // Use Basket SL TP in Pips
input double BasketSLinPips = 2500;                                                    // Basket SL in Pips
input double BasketTPinPips = 3500;
input string special4 = " ---- Trading Time Settings (uses BrokerTime) ---- "; // ----------------------------------------------------------------------------
input bool UseCloseAllAtDefinedTime = false;                                   // Use Close All At Defined Time
input int CloseHour = 21;                                                      // Close Hour
input int CloseMinute = 15;                                                    // Close Minute
input string fridayClSet = " ---- FridayClose Inputs (uses BrokerTime) ---- "; // ----------------------------------------------------------------------------
input bool UseCloseFriday = false;                                             // Use Close Friday
input int FridayCloseHour = 21;                                                // Friday Close Hour
input int FridayCloseMinute = 15;
input string special5 = " ----  Grid builder  ------------------------------ "; // ----------------------------------------------------------------------------
input bool    UseAtrForGrid=false;
input ENUM_TIMEFRAMES GridAtrTimeFrame=PERIOD_D1;
input int     GridAtrPeriod=20;
input double  GridAtrDivisor=5;
double distanceBetweenTrades=0;
input string special6 = " ----  Signal specific settings ------------------- "; // ----------------------------------------------------------------------------

enum Orientation
{
  ORI_NO = ORIENTATION_NO,
  ORI_UP = ORIENTATION_UP,
  ORI_DW = ORIENTATION_DW,
  ORI_HOR = ORIENTATION_HOR
};
// The orientation which is confirmed manually.
// Default option ORI_NO: let machine determine the orientation.
input Orientation ArtificialOrientation = ORI_HOR;
//+------------------------------------------------------------------+
