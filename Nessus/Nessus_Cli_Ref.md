[back](./README.md)

# Nessus CLI Reference

Link to [Nessuscli Docs](https://docs.tenable.com/nessus/Content/NessusCLI.htm)

You can administer some Tenable Nessus functions through a command-line interface (CLI) using the nessuscli utility.

This allows the user to manage user accounts, modify advanced settings, manage digital certificates, report bugs, update Tenable Nessus, and fetch necessary license information.

> Note: You must run all commands with administrative privileges.

<table>
<colgroup><col>
<col>
</colgroup><thead>
<tr>
<th scope="col">
<p>Operating System</p>
</th>
<th scope="col">
<p>Command</p>
</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<p>Linux</p>
</td>
<td>
<p><span class="Code"># /opt/nessus/sbin/nessuscli &lt;cmd&gt;&nbsp;&lt;arg1&gt; &lt;arg2&gt;</span>
</p>
</td>
</tr>
<tr>
<td>
<p>Windows</p>
</td>
<td>
<p><span class="Code">C:\Program Files\Tenable\Nessus\nessuscli.exe &lt;cmd&gt; &lt;arg1&gt; &lt;arg2&gt;</span> </p>
</td>
</tr>
<tr>
<td>
<p>macOS</p>
</td>
<td>
<p><span class="Code"># /Library/Nessus/run/sbin/nessuscli &lt;cmd&gt; &lt;arg1&gt; &lt;arg2&gt;</span>
</p>
</td>
</tr>
</tbody>
</table>

### Download via curl: 
```bash
curl --request GET \
  --url 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.6.0-x64.msi' \
  --output 'Nessus-10.6.0-x64.msi'
```

### Refresh Nessus License: 
`& "C:\Program Files\Tenable\Nessus\nessuscli.exe" fetch --register <Liscense-Code>`

### Update Plugins only: 
`& "C:\Program Files\Tenable\Nessus\nessuscli.exe" update --plugins-only`

### Check Nessus Version from Commandline: 
`Get-Content "C:\ProgramData\Tenable\Nessus\Nessus\nessus.version"`

### Download Nessus Plugins for offline updating: 
`curl.exe "https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/20783/download?i_agree_to_tenable_license_agreement=true" --output nessus-updates-10.6.1.tar.gz`