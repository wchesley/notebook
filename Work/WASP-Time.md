# WASP Time Server

Installed at Fuzzy's Radiator, on FUZ-APP-01
Installed to: `C:\Program Files (x86)\WaspTechnologies\WaspTime`
Logs are in the install directory, all are text files, ie `WaspTimeServer.log`, previous logs are renamed to `log1, log2, ... logN`

Typically, when you see: `The type initializer for 'WaspTime.Members' threw an exception.` - Wasp cannot read the timezone values that are set in the registry. There is a copy of valid timezones for windows 10 (32 & 64bit) in `Admin.Westgate` dowloads directory. Run the `x64` file to rewrite these values to the registry, then try to relaunch Wasp Time.

Only one user can be in Wasp at a time, so please close it when you are done. 

This software is long out of support with the vendor. 