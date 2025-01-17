[back](./README.md)

# CMD & Powershell Reference

For powershell, go [here](../Development/Scripts/powershell.md)

Created: April 8, 2021 12:04 PM
## General use: (CMD)
- list items with `dir` instead of `ls`
- can still change directory with `cwd`
- Can still pipe out put `| > >>`
- No `grep` but there is `findstr`
	- `set | findstr -i xdclientname`
		- Where `-i` makes for a case insensitive search 
- `tracert` is akin to `traceroute`
- most bash style commands translate into powershell. ie. can still use `ls` to list contents of directory. 

NFS - if installed on windows see [this](./windows-nfs) for more
- `rpcinfo`
- `mount`

View all env vars set for a system: 
- `set`

Windows `touch` equivilent: 
- They don't really have one, just use `echo text > text.txt` to create a new file. 

Batch renaming files in windows: 
- Powershell: 
  - See [this stackoverflow post](https://stackoverflow.com/questions/13382638/how-can-i-bulk-rename-files-in-powershell)
  - generall command: `get-help Rename-Item -example`
  - replace .txt with .log: `Get-ChildItem *.txt| Rename-Item -NewName { $_.Name -replace '\.txt','.log' }`
    - *Note the explanation in the help documentation for the escaping backslash in the replace command due to it using regular expressions to find the text to replace.*
  - To ensure the regex `-replace` operator matches only an extension at the end of the string, include the regex end-of-string character `$`.
    - `Get-ChildItem *.txt | Rename-Item -NewName { $_.Name -replace '\.txt$','.log' }`
    - This takes care of the case mentioned by @OhadSchneider in the comments, where we might have a file named `lorem.txt.txt` and we want to end up with `lorem.txt.log` rather than `lorem.log.log`.
  - Now that the regex is sufficiently tightly targeted, and inspired by @etoxin's answer, we could make the command more usable as follows:
    - `Get-ChildItem | Rename-Item -NewName { $_.Name -replace '\.txt$','.log' }`
    - That is, there is no need to filter before the pipe if our regex sufficiently filters after the pipe. And altering the command string (e.g. if you copy the above command and now want to use it to change the extension of '.xml' files) is no longer required in two places.

Chang ownership of files (powershell):
- Use the `takeown` command

<table aria-label="Table 1" class="table table-sm">
<thead>
<tr>
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>/s <code>&lt;computer&gt;</code></td>
<td>Specifies the name or IP address of a remote computer (do not use backslashes). The default value is the local computer. This parameter applies to all of the files and folders specified in the command.</td>
</tr>
<tr>
<td>/u <code>[&lt;domain&gt;\]&lt;username&gt;</code></td>
<td>Runs the script with the permissions of the specified user account. The default value is system permissions.</td>
</tr>
<tr>
<td>/p <code>[&lt;[password&gt;]</code></td>
<td>Specifies the password of the user account that is specified in the <strong>/u</strong> parameter.</td>
</tr>
<tr>
<td>/f <code>&lt;filename&gt;</code></td>
<td>Specifies the file name or directory name pattern. You can use the wildcard character <code>*</code> when specifying the pattern. You can also use the syntax <code>&lt;sharename&gt;\&lt;filename&gt;</code>.</td>
</tr>
<tr>
<td>/a</td>
<td>Gives ownership to the Administrators group instead of the current user. If you don't specify this option, file ownership is given to the user who is currently logged on to the computer.</td>
</tr>
<tr>
<td>/r</td>
<td>Performs a recursive operation on all files in the specified directory and subdirectories.</td>
</tr>
<tr>
<td>/d <code>{Y | N}</code></td>
<td>Suppresses the confirmation prompt that is displayed when the current user does not have the <strong>List Folder</strong> permission on a specified directory, and instead uses the specified default value. Valid values for the <strong>/d</strong> option are:<ul><li><strong>Y</strong> - Take ownership of the directory.</li><li><strong>N</strong> - Skip the directory.<p><strong>NOTE</strong><br>You must use this option in conjunction with the <strong>/r</strong> option.</p></li></ul></td>
</tr>
<tr>
<td>/?</td>
<td>Displays help at the command prompt.</td>
</tr>
</tbody>
</table>

- So the last time I needed to use this was when I was denied access to my old windows profile. `takeown /F /R /A ./myoldprofileFolder/`
  - This recursively changed all owners of files and folder in my old profile to the admins group.