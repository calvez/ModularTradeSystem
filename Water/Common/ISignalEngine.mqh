//+------------------------------------------------------------------+
//|                                                ISignalEngine.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict

//+------------------------------------------------------------------+
//| Wrapper of a signal data                                                                |
//+------------------------------------------------------------------+
struct CSignalData
  {
   int               orientation;
   int               open_signal;
   int               close_signal;
   bool              is_consumed;  // wheather the signal is consumed
   bool              operator == (const CSignalData &rhs);
   bool              operator != (const CSignalData &rhs);
                     CSignalData(void);
                    ~CSignalData(void) {};
   string            ToString(void);
  };

//+------------------------------------------------------------------+
//| overload the default constructor                                                                 |
//+------------------------------------------------------------------+
CSignalData::CSignalData()
  {
   orientation = 0;
   open_signal = 0;
   close_signal = 0;
   is_consumed = false;
  }
//+------------------------------------------------------------------+
//| Overloading operator ==, used to determine whether the signal content is equal,
//| excluding variable is_consumed.                                                                |
//+------------------------------------------------------------------+
bool CSignalData::operator == (const CSignalData &rhs)
  {
   return ((orientation == rhs.orientation) &&
           (open_signal == rhs.open_signal) &&
           (close_signal == rhs.close_signal));
  }

//+------------------------------------------------------------------+
//| Prevent operator != being misused.                                                             |
//+------------------------------------------------------------------+
bool CSignalData::operator != (const CSignalData &signalData)
  {
   return !operator==(signalData);
  }

//+------------------------------------------------------------------+
//| Convert a CSignalData instance to a string                                                           |
//+------------------------------------------------------------------+
string CSignalData::ToString()
  {
   return StringConcatenate("CSignalData={",
                            "orientation:",
                            orientation,
                            ",open_signal:",
                            open_signal,
                            ",close_signal:",
                            close_signal,
                            "}");
  }

//--- Basic interface for all signal engines.
interface ISignalEngine
  {
   CSignalData GetSignalData();
  };

//+------------------------------------------------------------------+
