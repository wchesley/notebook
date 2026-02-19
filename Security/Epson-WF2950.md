<sub>[back](./README.md)</sub>

# Epson WF-2950

The Epson WorkForce WF-2950 is a compact, all-in-one inkjet printer designed for home offices, featuring print, scan, copy, and fax capabilities. It offers wireless connectivity (Wi-Fi, Wi-Fi Direct), a 30-page auto document feeder (ADF), automatic 2-sided printing, and a color LCD screen. It uses four individual 232 or 232XL ink cartridges.

## Web UI

Can be access via HTTP/HTTPS at printer IP address. Default password is the serial number of the printer. If the password was changed from the default and can no longer be remembered, you must factory default the printer to change the password back to the serial number.  

I had an issue where the initial Administrator password wasn't working, even after a factory reset of the printer. I tried caps, no caps, 0 vs O and had no success. I eventually started looking at the web page makeup itself (inspect-element) and found a fairly basic layout for login, one form, a submit button, one text box and a couple of hidden input fields. One field holds the admin username, two others are for unknown purposes, but they were the key to getting into the web UI. One value was preset to `0`, changed it to `1` and attempted login with no success. The second hidden input was an empty string, I tested with a boolean value of `true` in this field, and `1` in the other field, used serial number as password and to my surprise, I was able to get logged in! Still cannot change the admin password, that input form is a bit different and I haven't put much time into it yet. 

Login was a basic `POST` to and endpoint called `SET`. Post data was just the username, password and two hidden input fields. 