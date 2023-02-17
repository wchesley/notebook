# A configuration mode command to establish dynamic source translation. Use of the “list” keyword enables you to use an ACL to identify the traffic that will be subject to NAT. The “overload” option enables the router to use one global address for many local addresses.

Command: ip nat inside source {list{access-list-number | access-list-name}} interface type number[overload]