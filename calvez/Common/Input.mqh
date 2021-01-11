//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, @calvez |
//|                                             https://t.me/calvez |
//+------------------------------------------------------------------+
//| All input variables should be defined here.
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"

input string special1 = "<<< General Settings >>>"; // ----------------------------------------------------------------------------

input bool IsDebugMode = true;             // Choose running mode,debug or release
bool AllowAutoTrade = true;               // Whether to allow automated trading
input bool AllowMail = false;              // Whether to allow email
input bool AllowHedge = true;              // Whether to allow hedge
input bool AllowMartin = true;             // Whether to allow using Martingale strategy
input int MinIntervalPoints = 350;         // Minimum points between 2 same type orders
input int Slippage = 100;                   // Maximum acceptable slippage
input double MoneyAtLeast = 500.0;        // How much money must be in the account
input double MoneyEveryLot = 100000.0;     // How much money is needed for opening one lot position
input double MinMargin = 1500;             // The minimal margin % to open NEW trades
input double DefaultLots = 0.01;           // Default initial lot
input bool FixedRiskMode = false;              // Fixed risk, other money management calculations are off
input double FixedRisk = 0.10;              // Fixed risk if FixedRiskMode is TRUE
input double Risk = 0.25;                     // Order Risk Percent
input double AddLotsMultiple = 2;        // The lot multiple to add positions
input double MaxAccountRiskPercent = -2.0; // Max Account Risk Percent
input int MaxOrderCounts = 4;

                                                             // TP if no ATR
                                              // TP if no ATR
// input string partSet = " ---- Partial Close Inputs ---- ";                             // ----------------------------------------------------------------------------
// input bool PartCloseEnabled = false;                                                   // partial close enabled
// input double PartClosePercent = 10;                                                    // partial close percent
// input bool PartCloseWithBE = false;                                                    // partial close with BE
// input bool PartCloseAsFirstTP = true;                                                  // partial close as First TP
// input bool SetBEonPartCloseFirstTP = false;                                            // Set BE on partial close First TP
// input bool useATRForPartClosePips = true;                                              // use ATR for partial close (true overrides other settings)
// input ENUM_TIMEFRAMES atrForPartClosePipsTF = PERIOD_H4;                               // ATR for partial close pips TF
// input double atrMultiplicatorForPartClosePips = 0.5;                                   // ATR multiplicator For partial close pips
// input int atrPeriodForPartClosePips = 14;                                              // ATR period For partial close pips
// input double PartCloseFirstTpPips = 25;                                                // partial close First TP pips
// input string special3 = " ---- Special Basket TP/SL Option in Account Currency ---- "; // ----------------------------------------------------------------------------
// input bool UseBasketSLTP = false;                                                      // Use Basket SL TP
// input bool UseBasketSLTPinAccountCurr = false;                                         // Use Basket SL TP in Account Curr
// input double BasketSL = 50;                                                           // Basket SL
// input double BasketTP = 75;                                                           // Basket TP
// input bool UseBasketSLTPinPips = true;                                                 // Use Basket SL TP in Pips
// input double BasketSLinPips = 250;                                                    // Basket SL in Pips
// input double BasketTPinPips = 350;


input string special6 = "<<< Orientation  >>>"; // ----------------------------------------------------------------------------

enum Orientation
{
  ORI_NO = ORIENTATION_NO,
  ORI_UP = ORIENTATION_UP,
  ORI_DW = ORIENTATION_DW,
  ORI_HOR = ORIENTATION_HOR
};
// The orientation which is confirmed manually.
// Default option ORI_NO: let machine determine the orientation.
input Orientation ArtificialOrientation = ORI_NO;
//+------------------------------------------------------------------+
