# delphi-GSDK
Control your Logitech devices from a Delphi application.

# What does this do?
This repo provices a library to do things like setting LED colors of a logitech keyboard.

There are also two example applications that demonstrate how to use it:

1. Logi_SetTargetZone_Sample_Delphi.dpr
   This is a port of the C++ and C# demo that comes with the SDK
   It sets the keys L,O,G,I to the color cyan.  

2. KnightRider.dpr
   This animates the number key row with a red glow for a couple of seconds.
   
# How does it work?
This library wraps LogitechLedEnginesWrapper.dll.
It comes with the G SDK (see https://www.logitechg.com/en-us/innovation/developer-lab.html)
There are also more details there on the library's interface.
# How to use this?
1. Include LogitechSDK.pas in your Delphi application. 
2. Make sure that LogitechLedEnginesWrapper.dll can be found by the executable.
3. Initialize with LogiLedInitWithName.
4. Do your thing.
5. Call LogiLedShutdown upon closing.

