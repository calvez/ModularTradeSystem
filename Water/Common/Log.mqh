//+------------------------------------------------------------------+
//|                                                   CommonUtil.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| Provide some common utils
//+------------------------------------------------------------------+
#property strict
#include "Input.mqh"

//+------------------------------------------------------------------+
//| Print log when debug mode                                                              |
//+------------------------------------------------------------------+
void LogD(const string tag,
          const string s1,
          const string s2="",
          const string s3="",
          const string s4="",
          const string s5="",
          const string s6="")
  {
   if(IsDebugMode)
      return;
   Print(tag,"...",s1,s2,s3,s4,s5,s6);
  }

//+------------------------------------------------------------------+
//| Print log when release mode                                                                     |
//+------------------------------------------------------------------+
void LogR(const string tag,
          const string s1="",
          const string s2="",
          const string s3="",
          const string s4="",
          const string s5="",
          const string s6="")
  {
   Print(tag,"...",s1,s2,s3,s4,s5,s6);
  }
//+------------------------------------------------------------------+
