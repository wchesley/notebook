# Remove text between () and [] - Stack Overflow

Created: April 13, 2021 7:48 PM
URL: https://stackoverflow.com/questions/14596884/remove-text-between-and

![apple-touch-icon@2.png](Remove%20text%20between%20()%20and%20%5B%5D%20-%20Stack%20Overflow%20c40d363cdfd54930a95049198b4b6327/apple-touch-icon2.png)

This should work for parentheses. Regular expressions will "consume" the text it has matched so it won't work for nested parentheses.

```
import re
regex = re.compile(".*?\((.*?)\)")
result = re.findall(regex, mystring)

```

or this would find one set of parentheses, simply loop to find more:

```
start = mystring.find("(")
end = mystring.find(")")
if start != -1 and end != -1:
  result = mystring[start+1:end]

```