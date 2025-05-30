[back](./README.md)

# Copy of Nginx http_proxy_module docs

Direct copy of https://nginx.org/en/docs/http/ngx_http_proxy_module.html as of 03/20/2023

<h2>Module ngx_http_proxy_module</h2><table width="100%"><tbody><tr><td align="left"><a href="#example">Example Configuration</a><br><a href="#directives">Directives</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_bind">proxy_bind</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_buffer_size">proxy_buffer_size</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_buffering">proxy_buffering</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_buffers">proxy_buffers</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_busy_buffers_size">proxy_busy_buffers_size</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache">proxy_cache</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_background_update">proxy_cache_background_update</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_bypass">proxy_cache_bypass</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_convert_head">proxy_cache_convert_head</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_key">proxy_cache_key</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_lock">proxy_cache_lock</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_lock_age">proxy_cache_lock_age</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_lock_timeout">proxy_cache_lock_timeout</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_max_range_offset">proxy_cache_max_range_offset</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_methods">proxy_cache_methods</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_min_uses">proxy_cache_min_uses</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_path">proxy_cache_path</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_purge">proxy_cache_purge</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_revalidate">proxy_cache_revalidate</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_use_stale">proxy_cache_use_stale</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cache_valid">proxy_cache_valid</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_connect_timeout">proxy_connect_timeout</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cookie_domain">proxy_cookie_domain</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cookie_flags">proxy_cookie_flags</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_cookie_path">proxy_cookie_path</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_force_ranges">proxy_force_ranges</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_headers_hash_bucket_size">proxy_headers_hash_bucket_size</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_headers_hash_max_size">proxy_headers_hash_max_size</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_hide_header">proxy_hide_header</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_http_version">proxy_http_version</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ignore_client_abort">proxy_ignore_client_abort</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ignore_headers">proxy_ignore_headers</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_intercept_errors">proxy_intercept_errors</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_limit_rate">proxy_limit_rate</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_max_temp_file_size">proxy_max_temp_file_size</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_method">proxy_method</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_next_upstream">proxy_next_upstream</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_next_upstream_timeout">proxy_next_upstream_timeout</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_next_upstream_tries">proxy_next_upstream_tries</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_no_cache">proxy_no_cache</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_pass">proxy_pass</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_pass_header">proxy_pass_header</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_pass_request_body">proxy_pass_request_body</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_pass_request_headers">proxy_pass_request_headers</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_read_timeout">proxy_read_timeout</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_redirect">proxy_redirect</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_request_buffering">proxy_request_buffering</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_send_lowat">proxy_send_lowat</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_send_timeout">proxy_send_timeout</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_set_body">proxy_set_body</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_set_header">proxy_set_header</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_socket_keepalive">proxy_socket_keepalive</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_certificate">proxy_ssl_certificate</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_certificate_key">proxy_ssl_certificate_key</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_ciphers">proxy_ssl_ciphers</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_conf_command">proxy_ssl_conf_command</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_crl">proxy_ssl_crl</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_name">proxy_ssl_name</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_password_file">proxy_ssl_password_file</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_protocols">proxy_ssl_protocols</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_server_name">proxy_ssl_server_name</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_session_reuse">proxy_ssl_session_reuse</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_trusted_certificate">proxy_ssl_trusted_certificate</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_verify">proxy_ssl_verify</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_ssl_verify_depth">proxy_ssl_verify_depth</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_store">proxy_store</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_store_access">proxy_store_access</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_temp_file_write_size">proxy_temp_file_write_size</a><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#proxy_temp_path">proxy_temp_path</a><br><a href="#variables">Embedded Variables</a><br></td></tr></tbody></table>

<a name="summary"></a><p>
The <code>ngx_http_proxy_module</code> module allows passing
requests to another server.
</p>


<a name="example"></a><center><h4>Example Configuration</h4></center><p>
</p> <blockquote class="example"><pre>location / {
proxy_pass       http://localhost:8000;
proxy_set_header Host      $host;
proxy_set_header X-Real-IP $remote_addr;
}
</pre></blockquote><p> 
</p>


<a name="directives"></a><center><h4>Directives</h4></center><a name="proxy_bind"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_bind</strong> 
<code><i>address</i></code>
[<code>transparent</code>] |
<code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 0.8.22.
</p></div><p>
Makes outgoing connections to a proxied server originate
from the specified local IP address with an optional port (1.11.2).
Parameter value can contain variables (1.3.12).
The special value <code>off</code> (1.3.12) cancels the effect
of the <code>proxy_bind</code> directive
inherited from the previous configuration level, which allows the
system to auto-assign the local IP address and port.
</p><a name="proxy_bind_transparent"></a><p>
The <code>transparent</code> parameter (1.11.0) allows
outgoing connections to a proxied server originate
from a non-local IP address,
for example, from a real IP address of a client:
</p> <blockquote class="example"><pre>proxy_bind $remote_addr transparent;
</pre></blockquote><p> 
In order for this parameter to work,
it is usually necessary to run nginx worker processes with the
<a href="../ngx_core_module.html#user">superuser</a> privileges.
On Linux it is not required (1.13.8) as if
the <code>transparent</code> parameter is specified, worker processes
inherit the <code>CAP_NET_RAW</code> capability from the master process.
It is also necessary to configure kernel routing table
to intercept network traffic from the proxied server.
</p><a name="proxy_buffer_size"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_buffer_size</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_buffer_size 4k|8k;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the <code><i>size</i></code> of the buffer used for reading the first part
of the response received from the proxied server.
This part usually contains a small response header.
By default, the buffer size is equal to one memory page.
This is either 4K or 8K, depending on a platform.
It can be made smaller, however.
</p><a name="proxy_buffering"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_buffering</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_buffering on;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Enables or disables buffering of responses from the proxied server.
</p><p>
When buffering is enabled, nginx receives a response from the proxied server
as soon as possible, saving it into the buffers set by the
<a href="#proxy_buffer_size">proxy_buffer_size</a> and <a href="#proxy_buffers">proxy_buffers</a> directives.
If the whole response does not fit into memory, a part of it can be saved
to a <a href="#proxy_temp_path">temporary file</a> on the disk.
Writing to temporary files is controlled by the
<a href="#proxy_max_temp_file_size">proxy_max_temp_file_size</a> and
<a href="#proxy_temp_file_write_size">proxy_temp_file_write_size</a> directives.
</p><p>
When buffering is disabled, the response is passed to a client synchronously,
immediately as it is received.
nginx will not try to read the whole response from the proxied server.
The maximum size of the data that nginx can receive from the server
at a time is set by the <a href="#proxy_buffer_size">proxy_buffer_size</a> directive.
</p><p>
Buffering can also be enabled or disabled by passing
“<code>yes</code>” or “<code>no</code>” in the
“X-Accel-Buffering” response header field.
This capability can be disabled using the
<a href="#proxy_ignore_headers">proxy_ignore_headers</a> directive.
</p><a name="proxy_buffers"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_buffers</strong> <code><i>number</i></code> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_buffers 8 4k|8k;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the <code><i>number</i></code> and <code><i>size</i></code> of the
buffers used for reading a response from the proxied server,
for a single connection.
By default, the buffer size is equal to one memory page.
This is either 4K or 8K, depending on a platform.
</p><a name="proxy_busy_buffers_size"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_busy_buffers_size</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_busy_buffers_size 8k|16k;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
When <a href="#proxy_buffering">buffering</a> of responses from the proxied
server is enabled, limits the total <code><i>size</i></code> of buffers that
can be busy sending a response to the client while the response is not
yet fully read.
In the meantime, the rest of the buffers can be used for reading the response
and, if needed, buffering part of the response to a temporary file.
By default, <code><i>size</i></code> is limited by the size of two buffers set by the
<a href="#proxy_buffer_size">proxy_buffer_size</a> and <a href="#proxy_buffers">proxy_buffers</a> directives.
</p><a name="proxy_cache"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache</strong> <code><i>zone</i></code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines a shared memory zone used for caching.
The same zone can be used in several places.
Parameter value can contain variables (1.7.9).
The <code>off</code> parameter disables caching inherited
from the previous configuration level.
</p><a name="proxy_cache_background_update"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_background_update</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_background_update off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.11.10.
</p></div><p>
Allows starting a background subrequest
to update an expired cache item,
while a stale cached response is returned to the client.
Note that it is necessary to
<a href="#proxy_cache_use_stale_updating">allow</a>
the usage of a stale cached response when it is being updated.
</p><a name="proxy_cache_bypass"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_bypass</strong> <code><i>string</i></code> ...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines conditions under which the response will not be taken from a cache.
If at least one value of the string parameters is not empty and is not
equal to “0” then the response will not be taken from the cache:
</p> <blockquote class="example"><pre>proxy_cache_bypass $cookie_nocache $arg_nocache$arg_comment;
proxy_cache_bypass $http_pragma    $http_authorization;
</pre></blockquote><p> 
Can be used along with the <a href="#proxy_no_cache">proxy_no_cache</a> directive.
</p><a name="proxy_cache_convert_head"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_convert_head</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_convert_head on;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.9.7.
</p></div><p>
Enables or disables the conversion of the “<code>HEAD</code>” method
to “<code>GET</code>” for caching.
When the conversion is disabled, the
<a href="#proxy_cache_key">cache key</a> should be configured
to include the <code>$request_method</code>.
</p><a name="proxy_cache_key"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_key</strong> <code><i>string</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_key $scheme$proxy_host$request_uri;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines a key for caching, for example
</p> <blockquote class="example"><pre>proxy_cache_key "$host$request_uri $cookie_user";
</pre></blockquote><p> 
By default, the directive’s value is close to the string
</p> <blockquote class="example"><pre>proxy_cache_key $scheme$proxy_host$uri$is_args$args;
</pre></blockquote><p> 
</p><a name="proxy_cache_lock"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_lock</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_lock off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.1.12.
</p></div><p>
When enabled, only one request at a time will be allowed to populate
a new cache element identified according to the <a href="#proxy_cache_key">proxy_cache_key</a>
directive by passing a request to a proxied server.
Other requests of the same cache element will either wait
for a response to appear in the cache or the cache lock for
this element to be released, up to the time set by the
<a href="#proxy_cache_lock_timeout">proxy_cache_lock_timeout</a> directive.
</p><a name="proxy_cache_lock_age"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_lock_age</strong> <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_lock_age 5s;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.8.
</p></div><p>
If the last request passed to the proxied server
for populating a new cache element
has not completed for the specified <code><i>time</i></code>,
one more request may be passed to the proxied server.
</p><a name="proxy_cache_lock_timeout"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_lock_timeout</strong> <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_lock_timeout 5s;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.1.12.
</p></div><p>
Sets a timeout for <a href="#proxy_cache_lock">proxy_cache_lock</a>.
When the <code><i>time</i></code> expires,
the request will be passed to the proxied server,
however, the response will not be cached.
</p> <blockquote class="note">
Before 1.7.8, the response could be cached.
</blockquote><p> 
</p><a name="proxy_cache_max_range_offset"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_max_range_offset</strong> <code><i>number</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.11.6.
</p></div><p>
Sets an offset in bytes for byte-range requests.
If the range is beyond the offset,
the range request will be passed to the proxied server
and the response will not be cached.
</p><a name="proxy_cache_methods"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_methods</strong> 
<code>GET</code> |
<code>HEAD</code> |
<code>POST</code>
...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_methods GET HEAD;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 0.7.59.
</p></div><p>
If the client request method is listed in this directive then
the response will be cached.
“<code>GET</code>” and “<code>HEAD</code>” methods are always
added to the list, though it is recommended to specify them explicitly.
See also the <a href="#proxy_no_cache">proxy_no_cache</a> directive.
</p><a name="proxy_cache_min_uses"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_min_uses</strong> <code><i>number</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_min_uses 1;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the <code><i>number</i></code> of requests after which the response
will be cached.
</p><a name="proxy_cache_path"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_path</strong> 
<code><i>path</i></code>
[<code>levels</code>=<code><i>levels</i></code>]
[<code>use_temp_path</code>=<code>on</code>|<code>off</code>]
<code>keys_zone</code>=<code><i>name</i></code>:<code><i>size</i></code>
[<code>inactive</code>=<code><i>time</i></code>]
[<code>max_size</code>=<code><i>size</i></code>]
[<code>min_free</code>=<code><i>size</i></code>]
[<code>manager_files</code>=<code><i>number</i></code>]
[<code>manager_sleep</code>=<code><i>time</i></code>]
[<code>manager_threshold</code>=<code><i>time</i></code>]
[<code>loader_files</code>=<code><i>number</i></code>]
[<code>loader_sleep</code>=<code><i>time</i></code>]
[<code>loader_threshold</code>=<code><i>time</i></code>]
[<code>purger</code>=<code>on</code>|<code>off</code>]
[<code>purger_files</code>=<code><i>number</i></code>]
[<code>purger_sleep</code>=<code><i>time</i></code>]
[<code>purger_threshold</code>=<code><i>time</i></code>];</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the path and other parameters of a cache.
Cache data are stored in files.
The file name in a cache is a result of
applying the MD5 function to the
<a href="#proxy_cache_key">cache key</a>.
The <code>levels</code> parameter defines hierarchy levels of a cache:
from 1 to 3, each level accepts values 1 or 2.
For example, in the following configuration
</p> <blockquote class="example"><pre>proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=one:10m;
</pre></blockquote><p> 
file names in a cache will look like this:
</p> <blockquote class="example"><pre>/data/nginx/cache/<strong>c</strong>/<strong>29</strong>/b7f54b2df7773722d382f4809d650<strong>29c</strong>
</pre></blockquote><p> 
</p><p>
A cached response is first written to a temporary file,
and then the file is renamed.
Starting from version 0.8.9, temporary files and the cache can be put on
different file systems.
However, be aware that in this case a file is copied
across two file systems instead of the cheap renaming operation.
It is thus recommended that for any given location both cache and a directory
holding temporary files
are put on the same file system.
The directory for temporary files is set based on
the <code>use_temp_path</code> parameter (1.7.10).
If this parameter is omitted or set to the value <code>on</code>,
the directory set by the <a href="#proxy_temp_path">proxy_temp_path</a> directive
for the given location will be used.
If the value is set to <code>off</code>,
temporary files will be put directly in the cache directory.
</p><p>
In addition, all active keys and information about data are stored
in a shared memory zone, whose <code><i>name</i></code> and <code><i>size</i></code>
are configured by the <code>keys_zone</code> parameter.
One megabyte zone can store about 8 thousand keys.
</p> <blockquote class="note">
As part of
<a href="http://nginx.com/products/">commercial subscription</a>,
the shared memory zone also stores extended
cache <a href="ngx_http_api_module.html#http_caches_">information</a>,
thus, it is required to specify a larger zone size for the same number of keys.
For example,
one megabyte zone can store about 4 thousand keys.
</blockquote><p> 
</p><p>
Cached data that are not accessed during the time specified by the
<code>inactive</code> parameter get removed from the cache
regardless of their freshness.
By default, <code>inactive</code> is set to 10 minutes.
</p><a name="proxy_cache_path_max_size"></a><p>
The special “cache manager” process monitors the maximum cache size set
by the <code>max_size</code> parameter,
and the minimum amount of free space set
by the <code>min_free</code> (1.19.1) parameter
on the file system with cache.
When the size is exceeded or there is not enough free space,
it removes the least recently used data.
The data is removed in iterations configured by
<code>manager_files</code>,
<code>manager_threshold</code>, and
<code>manager_sleep</code> parameters (1.11.5).
During one iteration no more than <code>manager_files</code> items
are deleted (by default, 100).
The duration of one iteration is limited by the
<code>manager_threshold</code> parameter (by default, 200 milliseconds).
Between iterations, a pause configured by the <code>manager_sleep</code>
parameter (by default, 50 milliseconds) is made.
</p><p>
A minute after the start the special “cache loader” process is activated.
It loads information about previously cached data stored on file system
into a cache zone.
The loading is also done in iterations.
During one iteration no more than <code>loader_files</code> items
are loaded (by default, 100).
Besides, the duration of one iteration is limited by the
<code>loader_threshold</code> parameter (by default, 200 milliseconds).
Between iterations, a pause configured by the <code>loader_sleep</code>
parameter (by default, 50 milliseconds) is made.
</p><p>
Additionally,
the following parameters are available as part of our
<a href="http://nginx.com/products/">commercial subscription</a>:
</p><p>
</p> <dl class="compact">

<dt id="purger">
<code>purger</code>=<code>on</code>|<code>off</code>
</dt>
<dd>
Instructs whether cache entries that match a
<a href="#proxy_cache_purge">wildcard key</a>
will be removed from the disk by the cache purger (1.7.12).
Setting the parameter to <code>on</code>
(default is <code>off</code>)
will activate the “cache purger” process that
permanently iterates through all cache entries
and deletes the entries that match the wildcard key.
</dd>

<dt id="purger_files">
<code>purger_files</code>=<code><i>number</i></code>
</dt>
<dd>
Sets the number of items that will be scanned during one iteration (1.7.12).
By default, <code>purger_files</code> is set to 10.
</dd>

<dt id="purger_threshold">
<code>purger_threshold</code>=<code><i>number</i></code>
</dt>
<dd>
Sets the duration of one iteration (1.7.12).
By default, <code>purger_threshold</code> is set to 50 milliseconds.
</dd>

<dt id="purger_sleep">
<code>purger_sleep</code>=<code><i>number</i></code>
</dt>
<dd>
Sets a pause between iterations (1.7.12).
By default, <code>purger_sleep</code> is set to 50 milliseconds.
</dd>

</dl><p> 
</p><p>
</p> <blockquote class="note">
In versions 1.7.3, 1.7.7, and 1.11.10 cache header format has been changed.
Previously cached responses will be considered invalid
after upgrading to a newer nginx version.
</blockquote><p> 
</p><a name="proxy_cache_purge"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_purge</strong> string ...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.5.7.
</p></div><p>
Defines conditions under which the request will be considered a cache
purge request.
If at least one value of the string parameters is not empty and is not equal
to “0” then the cache entry with a corresponding
<a href="#proxy_cache_key">cache key</a> is removed.
The result of successful operation is indicated by returning
the 204 (No Content) response.
</p><p>
If the <a href="#proxy_cache_key">cache key</a> of a purge request ends
with an asterisk (“<code>*</code>”), all cache entries matching the
wildcard key will be removed from the cache.
However, these entries will remain on the disk until they are deleted
for either <a href="#proxy_cache_path">inactivity</a>,
or processed by the <a href="#purger">cache purger</a> (1.7.12),
or a client attempts to access them.
</p><p>
Example configuration:
</p> <blockquote class="example"><pre>proxy_cache_path /data/nginx/cache keys_zone=cache_zone:10m;

map $request_method $purge_method {
PURGE   1;
default 0;
}

server {
...
location / {
proxy_pass http://backend;
proxy_cache cache_zone;
proxy_cache_key $uri;
proxy_cache_purge $purge_method;
}
}
</pre></blockquote><p> 
</p> <blockquote class="note">
This functionality is available as part of our
<a href="http://nginx.com/products/">commercial subscription</a>.
</blockquote><p> 
</p><a name="proxy_cache_revalidate"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_revalidate</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_revalidate off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.5.7.
</p></div><p>
Enables revalidation of expired cache items using conditional requests with
the “If-Modified-Since” and “If-None-Match”
header fields.
</p><a name="proxy_cache_use_stale"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_use_stale</strong> 
<code>error</code> |
<code>timeout</code> |
<code>invalid_header</code> |
<code>updating</code> |
<code>http_500</code> |
<code>http_502</code> |
<code>http_503</code> |
<code>http_504</code> |
<code>http_403</code> |
<code>http_404</code> |
<code>http_429</code> |
<code>off</code>
...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cache_use_stale off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Determines in which cases a stale cached response can be used
during communication with the proxied server.
The directive’s parameters match the parameters of the
<a href="#proxy_next_upstream">proxy_next_upstream</a> directive.
</p><p>
The <code>error</code> parameter also permits
using a stale cached response if a proxied server to process a request
cannot be selected.
</p><a name="proxy_cache_use_stale_updating"></a><p>
Additionally, the <code>updating</code> parameter permits
using a stale cached response if it is currently being updated.
This allows minimizing the number of accesses to proxied servers
when updating cached data.
</p><p>
Using a stale cached response
can also be enabled directly in the response header
for a specified number of seconds after the response became stale (1.11.10).
This has lower priority than using the directive parameters.
</p> <ul>

<li>
The
“<a href="https://datatracker.ietf.org/doc/html/rfc5861#section-3">stale-while-revalidate</a>”
extension of the “Cache-Control” header field permits
using a stale cached response if it is currently being updated.
</li>

<li>
The
“<a href="https://datatracker.ietf.org/doc/html/rfc5861#section-4">stale-if-error</a>”
extension of the “Cache-Control” header field permits
using a stale cached response in case of an error.
</li>

</ul><p> 
</p><p>
To minimize the number of accesses to proxied servers when
populating a new cache element, the <a href="#proxy_cache_lock">proxy_cache_lock</a>
directive can be used.
</p><a name="proxy_cache_valid"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cache_valid</strong> [<code><i>code</i></code> ...] <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets caching time for different response codes.
For example, the following directives
</p> <blockquote class="example"><pre>proxy_cache_valid 200 302 10m;
proxy_cache_valid 404      1m;
</pre></blockquote><p> 
set 10 minutes of caching for responses with codes 200 and 302
and 1 minute for responses with code 404.
</p><p>
If only caching <code><i>time</i></code> is specified
</p> <blockquote class="example"><pre>proxy_cache_valid 5m;
</pre></blockquote><p> 
then only 200, 301, and 302 responses are cached.
</p><p>
In addition, the <code>any</code> parameter can be specified
to cache any responses:
</p> <blockquote class="example"><pre>proxy_cache_valid 200 302 10m;
proxy_cache_valid 301      1h;
proxy_cache_valid any      1m;
</pre></blockquote><p> 
</p><p>
Parameters of caching can also be set directly
in the response header.
This has higher priority than setting of caching time using the directive.
</p> <ul>

<li>
The “X-Accel-Expires” header field sets caching time of a
response in seconds.
The zero value disables caching for a response.
If the value starts with the <code>@</code> prefix, it sets an absolute
time in seconds since Epoch, up to which the response may be cached.
</li>

<li>
If the header does not include the “X-Accel-Expires” field,
parameters of caching may be set in the header fields
“Expires” or “Cache-Control”.
</li>

<li>
If the header includes the “Set-Cookie” field, such a
response will not be cached.
</li>

<li>
If the header includes the “Vary” field
with the special value “<code>*</code>”, such a
response will not be cached (1.7.7).
If the header includes the “Vary” field
with another value, such a response will be cached
taking into account the corresponding request header fields (1.7.7).
</li>

</ul><p> 
Processing of one or more of these response header fields can be disabled
using the <a href="#proxy_ignore_headers">proxy_ignore_headers</a> directive.
</p><a name="proxy_connect_timeout"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_connect_timeout</strong> <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_connect_timeout 60s;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines a timeout for establishing a connection with a proxied server.
It should be noted that this timeout cannot usually exceed 75 seconds.
</p><a name="proxy_cookie_domain"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cookie_domain</strong> <code>off</code>;</code><br><code><strong>proxy_cookie_domain</strong> <code><i>domain</i></code> <code><i>replacement</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cookie_domain off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.1.15.
</p></div><p>
Sets a text that should be changed in the <code>domain</code>
attribute of the “Set-Cookie” header fields of a
proxied server response.
Suppose a proxied server returned the “Set-Cookie”
header field with the attribute
“<code>domain=localhost</code>”.
The directive
</p> <blockquote class="example"><pre>proxy_cookie_domain localhost example.org;
</pre></blockquote><p> 
will rewrite this attribute to
“<code>domain=example.org</code>”.
</p><p>
A dot at the beginning of the <code><i>domain</i></code> and
<code><i>replacement</i></code> strings and the <code>domain</code>
attribute is ignored.
Matching is case-insensitive.
</p><p>
The <code><i>domain</i></code> and <code><i>replacement</i></code> strings
can contain variables:
</p> <blockquote class="example"><pre>proxy_cookie_domain www.$host $host;
</pre></blockquote><p> 
</p><p>
The directive can also be specified using regular expressions.
In this case, <code><i>domain</i></code> should start from
the “<code>~</code>” symbol.
A regular expression can contain named and positional captures,
and <code><i>replacement</i></code> can reference them:
</p> <blockquote class="example"><pre>proxy_cookie_domain ~\.(?P&lt;sl_domain&gt;[-0-9a-z]+\.[a-z]+)$ $sl_domain;
</pre></blockquote><p> 
</p><p>
Several <code>proxy_cookie_domain</code> directives
can be specified on the same level:
</p> <blockquote class="example"><pre>proxy_cookie_domain localhost example.org;
proxy_cookie_domain ~\.([a-z]+\.[a-z]+)$ $1;
</pre></blockquote><p> 
If several directives can be applied to the cookie,
the first matching directive will be chosen.
</p><p>
The <code>off</code> parameter cancels the effect
of the <code>proxy_cookie_domain</code> directives
inherited from the previous configuration level.
</p><a name="proxy_cookie_flags"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cookie_flags</strong> 
<code>off</code> |
<code><i>cookie</i></code>
[<code><i>flag</i></code> ...];</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cookie_flags off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.19.3.
</p></div><p>
Sets one or more flags for the cookie.
The <code><i>cookie</i></code> can contain text, variables, and their combinations.
The <code><i>flag</i></code>
can contain text, variables, and their combinations (1.19.8).
The
<code>secure</code>,
<code>httponly</code>,
<code>samesite=strict</code>,
<code>samesite=lax</code>,
<code>samesite=none</code>
parameters add the corresponding flags.
The
<code>nosecure</code>,
<code>nohttponly</code>,
<code>nosamesite</code>
parameters remove the corresponding flags.
</p><p>
The cookie can also be specified using regular expressions.
In this case, <code><i>cookie</i></code> should start from
the “<code>~</code>” symbol.
</p><p>
Several <code>proxy_cookie_flags</code> directives
can be specified on the same configuration level:
</p> <blockquote class="example"><pre>proxy_cookie_flags one httponly;
proxy_cookie_flags ~ nosecure samesite=strict;
</pre></blockquote><p> 
If several directives can be applied to the cookie,
the first matching directive will be chosen.
In the example, the <code>httponly</code> flag
is added to the cookie <code>one</code>,
for all other cookies
the <code>samesite=strict</code> flag is added and
the <code>secure</code> flag is deleted.
</p><p>
The <code>off</code> parameter cancels the effect
of the <code>proxy_cookie_flags</code> directives
inherited from the previous configuration level.
</p><a name="proxy_cookie_path"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_cookie_path</strong> <code>off</code>;</code><br><code><strong>proxy_cookie_path</strong> <code><i>path</i></code> <code><i>replacement</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_cookie_path off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.1.15.
</p></div><p>
Sets a text that should be changed in the <code>path</code>
attribute of the “Set-Cookie” header fields of a
proxied server response.
Suppose a proxied server returned the “Set-Cookie”
header field with the attribute
“<code>path=/two/some/uri/</code>”.
The directive
</p> <blockquote class="example"><pre>proxy_cookie_path /two/ /;
</pre></blockquote><p> 
will rewrite this attribute to
“<code>path=/some/uri/</code>”.
</p><p>
The <code><i>path</i></code> and <code><i>replacement</i></code> strings
can contain variables:
</p> <blockquote class="example"><pre>proxy_cookie_path $uri /some$uri;
</pre></blockquote><p> 
</p><p>
The directive can also be specified using regular expressions.
In this case, <code><i>path</i></code> should either start from
the “<code>~</code>” symbol for a case-sensitive matching,
or from the “<code>~*</code>” symbols for case-insensitive
matching.
The regular expression can contain named and positional captures,
and <code><i>replacement</i></code> can reference them:
</p> <blockquote class="example"><pre>proxy_cookie_path ~*^/user/([^/]+) /u/$1;
</pre></blockquote><p> 
</p><p>
Several <code>proxy_cookie_path</code> directives
can be specified on the same level:
</p> <blockquote class="example"><pre>proxy_cookie_path /one/ /;
proxy_cookie_path / /two/;
</pre></blockquote><p> 
If several directives can be applied to the cookie,
the first matching directive will be chosen.
</p><p>
The <code>off</code> parameter cancels the effect
of the <code>proxy_cookie_path</code> directives
inherited from the previous configuration level.
</p><a name="proxy_force_ranges"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_force_ranges</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_force_ranges off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.7.
</p></div><p>
Enables byte-range support
for both cached and uncached responses from the proxied server
regardless of the “Accept-Ranges” field in these responses.
</p><a name="proxy_headers_hash_bucket_size"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_headers_hash_bucket_size</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_headers_hash_bucket_size 64;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the bucket <code><i>size</i></code> for hash tables
used by the <a href="#proxy_hide_header">proxy_hide_header</a> and <a href="#proxy_set_header">proxy_set_header</a>
directives.
The details of setting up hash tables are provided in a separate
<a href="../hash.html">document</a>.
</p><a name="proxy_headers_hash_max_size"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_headers_hash_max_size</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_headers_hash_max_size 512;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the maximum <code><i>size</i></code> of hash tables
used by the <a href="#proxy_hide_header">proxy_hide_header</a> and <a href="#proxy_set_header">proxy_set_header</a>
directives.
The details of setting up hash tables are provided in a separate
<a href="../hash.html">document</a>.
</p><a name="proxy_hide_header"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_hide_header</strong> <code><i>field</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
By default,
nginx does not pass the header fields “Date”,
“Server”, “X-Pad”, and
“X-Accel-...” from the response of a proxied
server to a client.
The <code>proxy_hide_header</code> directive sets additional fields
that will not be passed.
If, on the contrary, the passing of fields needs to be permitted,
the <a href="#proxy_pass_header">proxy_pass_header</a> directive can be used.
</p><a name="proxy_http_version"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_http_version</strong> <code>1.0</code> | <code>1.1</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_http_version 1.0;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.1.4.
</p></div><p>
Sets the HTTP protocol version for proxying.
By default, version 1.0 is used.
Version 1.1 is recommended for use with
<a href="ngx_http_upstream_module.html#keepalive">keepalive</a>
connections and
<a href="ngx_http_upstream_module.html#ntlm">NTLM authentication</a>.
</p><a name="proxy_ignore_client_abort"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ignore_client_abort</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ignore_client_abort off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Determines whether the connection with a proxied server should be
closed when a client closes the connection without waiting
for a response.
</p><a name="proxy_ignore_headers"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ignore_headers</strong> <code><i>field</i></code> ...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Disables processing of certain response header fields from the proxied server.
The following fields can be ignored: “X-Accel-Redirect”,
“X-Accel-Expires”, “X-Accel-Limit-Rate” (1.1.6),
“X-Accel-Buffering” (1.1.6),
“X-Accel-Charset” (1.1.6), “Expires”,
“Cache-Control”, “Set-Cookie” (0.8.44),
and “Vary” (1.7.7).
</p><p>
If not disabled, processing of these header fields has the following
effect:
</p> <ul>

<li>
“X-Accel-Expires”, “Expires”,
“Cache-Control”, “Set-Cookie”,
and “Vary”
set the parameters of response <a href="#proxy_cache_valid">caching</a>;
</li>

<li>
“X-Accel-Redirect” performs an
<a href="ngx_http_core_module.html#internal">internal
redirect</a> to the specified URI;
</li>

<li>
“X-Accel-Limit-Rate” sets the
<a href="ngx_http_core_module.html#limit_rate">rate
limit</a> for transmission of a response to a client;
</li>

<li>
“X-Accel-Buffering” enables or disables
<a href="#proxy_buffering">buffering</a> of a response;
</li>

<li>
“X-Accel-Charset” sets the desired
<a href="ngx_http_charset_module.html#charset">charset</a>
of a response.
</li>

</ul><p> 
</p><a name="proxy_intercept_errors"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_intercept_errors</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_intercept_errors off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Determines whether proxied responses with codes greater than or equal
to 300 should be passed to a client
or be intercepted and redirected to nginx for processing
with the <a href="ngx_http_core_module.html#error_page">error_page</a> directive.
</p><a name="proxy_limit_rate"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_limit_rate</strong> <code><i>rate</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_limit_rate 0;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.7.
</p></div><p>
Limits the speed of reading the response from the proxied server.
The <code><i>rate</i></code> is specified in bytes per second.
The zero value disables rate limiting.
The limit is set per a request, and so if nginx simultaneously opens
two connections to the proxied server,
the overall rate will be twice as much as the specified limit.
The limitation works only if
<a href="#proxy_buffering">buffering</a> of responses from the proxied
server is enabled.
</p><a name="proxy_max_temp_file_size"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_max_temp_file_size</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_max_temp_file_size 1024m;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
When <a href="#proxy_buffering">buffering</a> of responses from the proxied
server is enabled, and the whole response does not fit into the buffers
set by the <a href="#proxy_buffer_size">proxy_buffer_size</a> and <a href="#proxy_buffers">proxy_buffers</a>
directives, a part of the response can be saved to a temporary file.
This directive sets the maximum <code><i>size</i></code> of the temporary file.
The size of data written to the temporary file at a time is set
by the <a href="#proxy_temp_file_write_size">proxy_temp_file_write_size</a> directive.
</p><p>
The zero value disables buffering of responses to temporary files.
</p><p>
</p> <blockquote class="note">
This restriction does not apply to responses
that will be <a href="#proxy_cache">cached</a>
or <a href="#proxy_store">stored</a> on disk.
</blockquote><p> 
</p><a name="proxy_method"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_method</strong> <code><i>method</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Specifies the HTTP <code><i>method</i></code> to use in requests forwarded
to the proxied server instead of the method from the client request.
Parameter value can contain variables (1.11.6).
</p><a name="proxy_next_upstream"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_next_upstream</strong> 
<code>error</code> |
<code>timeout</code> |
<code>invalid_header</code> |
<code>http_500</code> |
<code>http_502</code> |
<code>http_503</code> |
<code>http_504</code> |
<code>http_403</code> |
<code>http_404</code> |
<code>http_429</code> |
<code>non_idempotent</code> |
<code>off</code>
...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_next_upstream error timeout;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Specifies in which cases a request should be passed to the next server:
</p> <dl class="compact">

<dt><code>error</code></dt>
<dd>an error occurred while establishing a connection with the
server, passing a request to it, or reading the response header;</dd>

<dt><code>timeout</code></dt>
<dd>a timeout has occurred while establishing a connection with the
server, passing a request to it, or reading the response header;</dd>

<dt><code>invalid_header</code></dt>
<dd>a server returned an empty or invalid response;</dd>

<dt><code>http_500</code></dt>
<dd>a server returned a response with the code 500;</dd>

<dt><code>http_502</code></dt>
<dd>a server returned a response with the code 502;</dd>

<dt><code>http_503</code></dt>
<dd>a server returned a response with the code 503;</dd>

<dt><code>http_504</code></dt>
<dd>a server returned a response with the code 504;</dd>

<dt><code>http_403</code></dt>
<dd>a server returned a response with the code 403;</dd>

<dt><code>http_404</code></dt>
<dd>a server returned a response with the code 404;</dd>

<dt><code>http_429</code></dt>
<dd>a server returned a response with the code 429 (1.11.13);</dd>

<dt id="non_idempotent"><code>non_idempotent</code></dt>
<dd>normally, requests with a
<a href="https://datatracker.ietf.org/doc/html/rfc7231#section-4.2.2">non-idempotent</a>
method
(<code>POST</code>, <code>LOCK</code>, <code>PATCH</code>)
are not passed to the next server
if a request has been sent to an upstream server (1.9.13);
enabling this option explicitly allows retrying such requests;
</dd>

<dt><code>off</code></dt>
<dd>disables passing a request to the next server.</dd>

</dl><p> 
</p><p>
One should bear in mind that passing a request to the next server is
only possible if nothing has been sent to a client yet.
That is, if an error or timeout occurs in the middle of the
transferring of a response, fixing this is impossible.
</p><p>
The directive also defines what is considered an
<a href="ngx_http_upstream_module.html#max_fails">unsuccessful
attempt</a> of communication with a server.
The cases of <code>error</code>, <code>timeout</code> and
<code>invalid_header</code> are always considered unsuccessful attempts,
even if they are not specified in the directive.
The cases of <code>http_500</code>, <code>http_502</code>,
<code>http_503</code>, <code>http_504</code>,
and <code>http_429</code> are
considered unsuccessful attempts only if they are specified in the directive.
The cases of <code>http_403</code> and <code>http_404</code>
are never considered unsuccessful attempts.
</p><p>
Passing a request to the next server can be limited by
<a href="#proxy_next_upstream_tries">the number of tries</a>
and by <a href="#proxy_next_upstream_timeout">time</a>.
</p><a name="proxy_next_upstream_timeout"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_next_upstream_timeout</strong> <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_next_upstream_timeout 0;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.5.
</p></div><p>
Limits the time during which a request can be passed to the
<a href="#proxy_next_upstream">next server</a>.
The <code>0</code> value turns off this limitation.
</p><a name="proxy_next_upstream_tries"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_next_upstream_tries</strong> <code><i>number</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_next_upstream_tries 0;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.5.
</p></div><p>
Limits the number of possible tries for passing a request to the
<a href="#proxy_next_upstream">next server</a>.
The <code>0</code> value turns off this limitation.
</p><a name="proxy_no_cache"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_no_cache</strong> <code><i>string</i></code> ...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines conditions under which the response will not be saved to a cache.
If at least one value of the string parameters is not empty and is not
equal to “0” then the response will not be saved:
</p> <blockquote class="example"><pre>proxy_no_cache $cookie_nocache $arg_nocache$arg_comment;
proxy_no_cache $http_pragma    $http_authorization;
</pre></blockquote><p> 
Can be used along with the <a href="#proxy_cache_bypass">proxy_cache_bypass</a> directive.
</p><a name="proxy_pass"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_pass</strong> <code><i>URL</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>location</code>, <code>if in location</code>, <code>limit_except</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the protocol and address of a proxied server and an optional URI
to which a location should be mapped.
As a protocol, “<code>http</code>” or “<code>https</code>”
can be specified.
The address can be specified as a domain name or IP address,
and an optional port:
</p> <blockquote class="example"><pre>proxy_pass http://localhost:8000/uri/;
</pre></blockquote><p> 
or as a UNIX-domain socket path specified after the word
“<code>unix</code>” and enclosed in colons:
</p> <blockquote class="example"><pre>proxy_pass http://unix:/tmp/backend.socket:/uri/;
</pre></blockquote><p> 
</p><p>
If a domain name resolves to several addresses, all of them will be
used in a round-robin fashion.
In addition, an address can be specified as a
<a href="ngx_http_upstream_module.html">server group</a>.
</p><p>
Parameter value can contain variables.
In this case, if an address is specified as a domain name,
the name is searched among the described server groups,
and, if not found, is determined using a
<a href="ngx_http_core_module.html#resolver">resolver</a>.
</p><p>
A request URI is passed to the server as follows:
</p> <ul>

<li>
If the <code>proxy_pass</code> directive is specified with a URI,
then when a request is passed to the server, the part of a
<a href="ngx_http_core_module.html#location">normalized</a>
request URI matching the location is replaced by a URI
specified in the directive:
<blockquote class="example"><pre>location /name/ {
proxy_pass http://127.0.0.1/remote/;
}
</pre></blockquote>
</li>

<li>
If <code>proxy_pass</code> is specified without a URI,
the request URI is passed to the server in the same form
as sent by a client when the original request is processed,
or the full normalized request URI is passed
when processing the changed URI:
<blockquote class="example"><pre>location /some/path/ {
proxy_pass http://127.0.0.1;
}
</pre></blockquote>
<blockquote class="note">
Before version 1.1.12,
if <code>proxy_pass</code> is specified without a URI,
the original request URI might be passed
instead of the changed URI in some cases.
</blockquote>
</li>
</ul><p> 
</p><p>
In some cases, the part of a request URI to be replaced cannot be determined:
</p> <ul>

<li>
When location is specified using a regular expression,
and also inside named locations.
<p>
In these cases,
<code>proxy_pass</code> should be specified without a URI.
</p>
</li>

<li>
When the URI is changed inside a proxied location using the
<a href="ngx_http_rewrite_module.html#rewrite">rewrite</a> directive,
and this same configuration will be used to process a request
(<code>break</code>):
<blockquote class="example"><pre>location /name/ {
rewrite    /name/([^/]+) /users?name=$1 break;
proxy_pass http://127.0.0.1;
}
</pre></blockquote>
<p>
In this case, the URI specified in the directive is ignored and
the full changed request URI is passed to the server.
</p>
</li>

<li>
When variables are used in <code>proxy_pass</code>:
<blockquote class="example"><pre>location /name/ {
proxy_pass http://127.0.0.1$request_uri;
}
</pre></blockquote>
In this case, if URI is specified in the directive,
it is passed to the server as is,
replacing the original request URI.
</li>
</ul><p> 
</p><p>
<a href="websocket.html">WebSocket</a> proxying requires special
configuration and is supported since version 1.3.13.
</p><a name="proxy_pass_header"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_pass_header</strong> <code><i>field</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Permits passing <a href="#proxy_hide_header">otherwise disabled</a> header
fields from a proxied server to a client.
</p><a name="proxy_pass_request_body"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_pass_request_body</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_pass_request_body on;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Indicates whether the original request body is passed
to the proxied server.
</p> <blockquote class="example"><pre>location /x-accel-redirect-here/ {
proxy_method GET;
proxy_pass_request_body off;
proxy_set_header Content-Length "";

proxy_pass ...
}
</pre></blockquote><p> 
See also the <a href="#proxy_set_header">proxy_set_header</a> and
<a href="#proxy_pass_request_headers">proxy_pass_request_headers</a> directives.
</p><a name="proxy_pass_request_headers"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_pass_request_headers</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_pass_request_headers on;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Indicates whether the header fields of the original request are passed
to the proxied server.
</p> <blockquote class="example"><pre>location /x-accel-redirect-here/ {
proxy_method GET;
proxy_pass_request_headers off;
proxy_pass_request_body off;

proxy_pass ...
}
</pre></blockquote><p> 
See also the <a href="#proxy_set_header">proxy_set_header</a> and
<a href="#proxy_pass_request_body">proxy_pass_request_body</a> directives.
</p><a name="proxy_read_timeout"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_read_timeout</strong> <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_read_timeout 60s;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines a timeout for reading a response from the proxied server.
The timeout is set only between two successive read operations,
not for the transmission of the whole response.
If the proxied server does not transmit anything within this time,
the connection is closed.
</p><a name="proxy_redirect"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_redirect</strong> <code>default</code>;</code><br><code><strong>proxy_redirect</strong> <code>off</code>;</code><br><code><strong>proxy_redirect</strong> <code><i>redirect</i></code> <code><i>replacement</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_redirect default;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets the text that should be changed in the “Location”
and “Refresh” header fields of a proxied server response.
Suppose a proxied server returned the header field
“<code>Location: http://localhost:8000/two/some/uri/</code>”.
The directive
</p> <blockquote class="example"><pre>proxy_redirect http://localhost:8000/two/ http://frontend/one/;
</pre></blockquote><p> 
will rewrite this string to
“<code>Location: http://frontend/one/some/uri/</code>”.
</p><p>
A server name may be omitted in the <code><i>replacement</i></code> string:
</p> <blockquote class="example"><pre>proxy_redirect http://localhost:8000/two/ /;
</pre></blockquote><p> 
then the primary server’s name and port, if different from 80,
will be inserted.
</p><p>
The default replacement specified by the <code>default</code> parameter
uses the parameters of the
<a href="ngx_http_core_module.html#location">location</a> and
<a href="#proxy_pass">proxy_pass</a> directives.
Hence, the two configurations below are equivalent:
</p> <blockquote class="example"><pre>location /one/ {
proxy_pass     http://upstream:port/two/;
proxy_redirect default;
</pre></blockquote><p> 

</p> <blockquote class="example"><pre>location /one/ {
proxy_pass     http://upstream:port/two/;
proxy_redirect http://upstream:port/two/ /one/;
</pre></blockquote><p> 
The <code>default</code> parameter is not permitted if
<a href="#proxy_pass">proxy_pass</a> is specified using variables.
</p><p>
A <code><i>replacement</i></code> string can contain variables:
</p> <blockquote class="example"><pre>proxy_redirect http://localhost:8000/ http://$host:$server_port/;
</pre></blockquote><p> 
</p><p>
A <code><i>redirect</i></code> can also contain (1.1.11) variables:
</p> <blockquote class="example"><pre>proxy_redirect http://$proxy_host:8000/ /;
</pre></blockquote><p> 
</p><p>
The directive can be specified (1.1.11) using regular expressions.
In this case, <code><i>redirect</i></code> should either start with
the “<code>~</code>” symbol for a case-sensitive matching,
or with the “<code>~*</code>” symbols for case-insensitive
matching.
The regular expression can contain named and positional captures,
and <code><i>replacement</i></code> can reference them:
</p> <blockquote class="example"><pre>proxy_redirect ~^(http://[^:]+):\d+(/.+)$ $1$2;
proxy_redirect ~*/user/([^/]+)/(.+)$      http://$1.example.com/$2;
</pre></blockquote><p> 
</p><p>
Several <code>proxy_redirect</code> directives
can be specified on the same level:
</p> <blockquote class="example"><pre>proxy_redirect default;
proxy_redirect http://localhost:8000/  /;
proxy_redirect http://www.example.com/ /;
</pre></blockquote><p> 
If several directives can be applied to
the header fields of a proxied server response,
the first matching directive will be chosen.
</p><p>
The <code>off</code> parameter cancels the effect
of the <code>proxy_redirect</code> directives
inherited from the previous configuration level.
</p><p>
Using this directive, it is also possible to add host names to relative
redirects issued by a proxied server:
</p> <blockquote class="example"><pre>proxy_redirect / /;
</pre></blockquote><p> 
</p><a name="proxy_request_buffering"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_request_buffering</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_request_buffering on;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.11.
</p></div><p>
Enables or disables buffering of a client request body.
</p><p>
When buffering is enabled, the entire request body is
<a href="ngx_http_core_module.html#client_body_buffer_size">read</a>
from the client before sending the request to a proxied server.
</p><p>
When buffering is disabled, the request body is sent to the proxied server
immediately as it is received.
In this case, the request cannot be passed to the
<a href="#proxy_next_upstream">next server</a>
if nginx already started sending the request body.
</p><p>
When HTTP/1.1 chunked transfer encoding is used
to send the original request body,
the request body will be buffered regardless of the directive value unless
HTTP/1.1 is <a href="#proxy_http_version">enabled</a> for proxying.
</p><a name="proxy_send_lowat"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_send_lowat</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_send_lowat 0;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
If the directive is set to a non-zero value, nginx will try to
minimize the number
of send operations on outgoing connections to a proxied server by using either
<code>NOTE_LOWAT</code> flag of the
<a href="../events.html#kqueue">kqueue</a> method,
or the <code>SO_SNDLOWAT</code> socket option,
with the specified <code><i>size</i></code>.
</p><p>
This directive is ignored on Linux, Solaris, and Windows.
</p><a name="proxy_send_timeout"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_send_timeout</strong> <code><i>time</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_send_timeout 60s;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets a timeout for transmitting a request to the proxied server.
The timeout is set only between two successive write operations,
not for the transmission of the whole request.
If the proxied server does not receive anything within this time,
the connection is closed.
</p><a name="proxy_set_body"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_set_body</strong> <code><i>value</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Allows redefining the request body passed to the proxied server.
The <code><i>value</i></code> can contain text, variables, and their combination.
</p><a name="proxy_set_header"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_set_header</strong> <code><i>field</i></code> <code><i>value</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_set_header Host $proxy_host;</pre><pre>proxy_set_header Connection close;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Allows redefining or appending fields to the request header
<a href="#proxy_pass_request_headers">passed</a> to the proxied server.
The <code><i>value</i></code> can contain text, variables, and their combinations.
These directives are inherited from the previous configuration level
if and only if there are no <code>proxy_set_header</code> directives
defined on the current level.
By default, only two fields are redefined:
</p> <blockquote class="example"><pre>proxy_set_header Host       $proxy_host;
proxy_set_header Connection close;
</pre></blockquote><p> 
If caching is enabled, the header fields
“If-Modified-Since”,
“If-Unmodified-Since”,
“If-None-Match”,
“If-Match”,
“Range”,
and
“If-Range”
from the original request are not passed to the proxied server.
</p><p>
An unchanged “Host” request header field can be passed like this:
</p> <blockquote class="example"><pre>proxy_set_header Host       $http_host;
</pre></blockquote><p> 
</p><p>
However, if this field is not present in a client request header then
nothing will be passed.
In such a case it is better to use the <code>$host</code> variable&nbsp;- its
value equals the server name in the “Host” request header
field or the primary server name if this field is not present:
</p> <blockquote class="example"><pre>proxy_set_header Host       $host;
</pre></blockquote><p> 
</p><p>
In addition, the server name can be passed together with the port of the
proxied server:
</p> <blockquote class="example"><pre>proxy_set_header Host       $host:$proxy_port;
</pre></blockquote><p> 
</p><p>
If the value of a header field is an empty string then this
field will not be passed to a proxied server:
</p> <blockquote class="example"><pre>proxy_set_header Accept-Encoding "";
</pre></blockquote><p> 
</p><a name="proxy_socket_keepalive"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_socket_keepalive</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_socket_keepalive off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.15.6.
</p></div><p>
Configures the “TCP keepalive” behavior
for outgoing connections to a proxied server.
By default, the operating system’s settings are in effect for the socket.
If the directive is set to the value “<code>on</code>”, the
<code>SO_KEEPALIVE</code> socket option is turned on for the socket.
</p><a name="proxy_ssl_certificate"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_certificate</strong> <code><i>file</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.8.
</p></div><p>
Specifies a <code><i>file</i></code> with the certificate in the PEM format
used for authentication to a proxied HTTPS server.
</p><p>
Since version 1.21.0, variables can be used in the <code><i>file</i></code> name.
</p><a name="proxy_ssl_certificate_key"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_certificate_key</strong> <code><i>file</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.8.
</p></div><p>
Specifies a <code><i>file</i></code> with the secret key in the PEM format
used for authentication to a proxied HTTPS server.
</p><p>
The value
<code>engine</code>:<code><i>name</i></code>:<code><i>id</i></code>
can be specified instead of the <code><i>file</i></code> (1.7.9),
which loads a secret key with a specified <code><i>id</i></code>
from the OpenSSL engine <code><i>name</i></code>.
</p><p>
Since version 1.21.0, variables can be used in the <code><i>file</i></code> name.
</p><a name="proxy_ssl_ciphers"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_ciphers</strong> <code><i>ciphers</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_ciphers DEFAULT;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.5.6.
</p></div><p>
Specifies the enabled ciphers for requests to a proxied HTTPS server.
The ciphers are specified in the format understood by the OpenSSL library.
</p><p>
The full list can be viewed using the
“<code>openssl ciphers</code>” command.
</p><a name="proxy_ssl_conf_command"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_conf_command</strong> <code><i>name</i></code> <code><i>value</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.19.4.
</p></div><p>
Sets arbitrary OpenSSL configuration
<a href="https://www.openssl.org/docs/man1.1.1/man3/SSL_CONF_cmd.html">commands</a>
when establishing a connection with the proxied HTTPS server.
</p> <blockquote class="note">
The directive is supported when using OpenSSL 1.0.2 or higher.
</blockquote><p> 
</p><p>
Several <code>proxy_ssl_conf_command</code> directives
can be specified on the same level.
These directives are inherited from the previous configuration level
if and only if there are
no <code>proxy_ssl_conf_command</code> directives
defined on the current level.
</p><p>
</p> <blockquote class="note">
Note that configuring OpenSSL directly
might result in unexpected behavior.
</blockquote><p> 
</p><a name="proxy_ssl_crl"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_crl</strong> <code><i>file</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.0.
</p></div><p>
Specifies a <code><i>file</i></code> with revoked certificates (CRL)
in the PEM format used to <a href="#proxy_ssl_verify">verify</a>
the certificate of the proxied HTTPS server.
</p><a name="proxy_ssl_name"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_name</strong> <code><i>name</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_name $proxy_host;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.0.
</p></div><p>
Allows overriding the server name used to
<a href="#proxy_ssl_verify">verify</a>
the certificate of the proxied HTTPS server and to be
<a href="#proxy_ssl_server_name">passed through SNI</a>
when establishing a connection with the proxied HTTPS server.
</p><p>
By default, the host part of the <a href="#proxy_pass">proxy_pass</a> URL is used.
</p><a name="proxy_ssl_password_file"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_password_file</strong> <code><i>file</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.8.
</p></div><p>
Specifies a <code><i>file</i></code> with passphrases for
<a href="#proxy_ssl_certificate_key">secret keys</a>
where each passphrase is specified on a separate line.
Passphrases are tried in turn when loading the key.
</p><a name="proxy_ssl_protocols"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_protocols</strong> 
[<code>SSLv2</code>]
[<code>SSLv3</code>]
[<code>TLSv1</code>]
[<code>TLSv1.1</code>]
[<code>TLSv1.2</code>]
[<code>TLSv1.3</code>];</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.5.6.
</p></div><p>
Enables the specified protocols for requests to a proxied HTTPS server.
</p><a name="proxy_ssl_server_name"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_server_name</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_server_name off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.0.
</p></div><p>
Enables or disables passing of the server name through
<a href="http://en.wikipedia.org/wiki/Server_Name_Indication">TLS
Server Name Indication extension</a> (SNI, RFC 6066)
when establishing a connection with the proxied HTTPS server.
</p><a name="proxy_ssl_session_reuse"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_session_reuse</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_session_reuse on;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Determines whether SSL sessions can be reused when working with
the proxied server.
If the errors
“<code>SSL3_GET_FINISHED:digest check failed</code>”
appear in the logs, try disabling session reuse.
</p><a name="proxy_ssl_trusted_certificate"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_trusted_certificate</strong> <code><i>file</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>

—

</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.0.
</p></div><p>
Specifies a <code><i>file</i></code> with trusted CA certificates in the PEM format
used to <a href="#proxy_ssl_verify">verify</a>
the certificate of the proxied HTTPS server.
</p><a name="proxy_ssl_verify"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_verify</strong> <code>on</code> | <code>off</code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_verify off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.0.
</p></div><p>
Enables or disables verification of the proxied HTTPS server certificate.
</p><a name="proxy_ssl_verify_depth"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_ssl_verify_depth</strong> <code><i>number</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_ssl_verify_depth 1;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table><p>This directive appeared in version 1.7.0.
</p></div><p>
Sets the verification depth in the proxied HTTPS server certificates chain.
</p><a name="proxy_store"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_store</strong> 
<code>on</code> |
<code>off</code> |
<code><i>string</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_store off;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Enables saving of files to a disk.
The <code>on</code> parameter saves files with paths
corresponding to the directives
<a href="ngx_http_core_module.html#alias">alias</a> or
<a href="ngx_http_core_module.html#root">root</a>.
The <code>off</code> parameter disables saving of files.
In addition, the file name can be set explicitly using the
<code><i>string</i></code> with variables:
</p> <blockquote class="example"><pre>proxy_store /data/www$original_uri;
</pre></blockquote><p> 
</p><p>
The modification time of files is set according to the received
“Last-Modified” response header field.
The response is first written to a temporary file,
and then the file is renamed.
Starting from version 0.8.9, temporary files and the persistent store
can be put on different file systems.
However, be aware that in this case a file is copied
across two file systems instead of the cheap renaming operation.
It is thus recommended that for any given location both saved files and a
directory holding temporary files, set by the <a href="#proxy_temp_path">proxy_temp_path</a>
directive, are put on the same file system.
</p><p>
This directive can be used to create local copies of static unchangeable
files, e.g.:
</p> <blockquote class="example"><pre>location /images/ {
root               /data/www;
error_page         404 = /fetch$uri;
}

location /fetch/ {
internal;

proxy_pass         http://backend/;
proxy_store        on;
proxy_store_access user:rw group:rw all:r;
proxy_temp_path    /data/temp;

alias              /data/www/;
}
</pre></blockquote><p> 
</p><p>
or like this:
</p> <blockquote class="example"><pre>location /images/ {
root               /data/www;
error_page         404 = @fetch;
}

location @fetch {
internal;

proxy_pass         http://backend;
proxy_store        on;
proxy_store_access user:rw group:rw all:r;
proxy_temp_path    /data/temp;

root               /data/www;
}
</pre></blockquote><p> 
</p><a name="proxy_store_access"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_store_access</strong> <code><i>users</i></code>:<code><i>permissions</i></code> ...;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_store_access user:rw;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Sets access permissions for newly created files and directories, e.g.:
</p> <blockquote class="example"><pre>proxy_store_access user:rw group:rw all:r;
</pre></blockquote><p> 
</p><p>
If any <code>group</code> or <code>all</code> access permissions
are specified then <code>user</code> permissions may be omitted:
</p> <blockquote class="example"><pre>proxy_store_access group:rw all:r;
</pre></blockquote><p> 
</p><a name="proxy_temp_file_write_size"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_temp_file_write_size</strong> <code><i>size</i></code>;</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_temp_file_write_size 8k|16k;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Limits the <code><i>size</i></code> of data written to a temporary file
at a time, when buffering of responses from the proxied server
to temporary files is enabled.
By default, <code><i>size</i></code> is limited by two buffers set by the
<a href="#proxy_buffer_size">proxy_buffer_size</a> and <a href="#proxy_buffers">proxy_buffers</a> directives.
The maximum size of a temporary file is set by the
<a href="#proxy_max_temp_file_size">proxy_max_temp_file_size</a> directive.
</p><a name="proxy_temp_path"></a><div class="directive"><table cellspacing="0">
<tbody><tr>
<th>
Syntax:
</th>
<td>
<code><strong>proxy_temp_path</strong> 
<code><i>path</i></code>
[<code><i>level1</i></code>
[<code><i>level2</i></code>
[<code><i>level3</i></code>]]];</code><br>
</td>
</tr>

<tr>
<th>
Default:
</th>
<td>
<pre>proxy_temp_path proxy_temp;</pre>
</td>
</tr>

<tr>
<th>
Context:
</th>
<td>
<code>http</code>, <code>server</code>, <code>location</code><br>
</td>
</tr>
</tbody></table></div><p>
Defines a directory for storing temporary files
with data received from proxied servers.
Up to three-level subdirectory hierarchy can be used underneath the specified
directory.
For example, in the following configuration
</p> <blockquote class="example"><pre>proxy_temp_path /spool/nginx/proxy_temp 1 2;
</pre></blockquote><p> 
a temporary file might look like this:
</p> <blockquote class="example"><pre>/spool/nginx/proxy_temp/<strong>7</strong>/<strong>45</strong>/00000123<strong>457</strong>
</pre></blockquote><p> 
</p><p>
See also the <code>use_temp_path</code> parameter of the
<a href="#proxy_cache_path">proxy_cache_path</a> directive.
</p>


<a name="variables"></a><center><h4>Embedded Variables</h4></center><p>
The <code>ngx_http_proxy_module</code> module supports embedded variables
that can be used to compose headers using the
<a href="#proxy_set_header">proxy_set_header</a> directive:
</p> <dl class="compact">

<dt id="var_proxy_host"><code>$proxy_host</code></dt>
<dd>name and port of a proxied server as specified in the
<a href="#proxy_pass">proxy_pass</a> directive;</dd>

<dt id="var_proxy_port"><code>$proxy_port</code></dt>
<dd>port of a proxied server as specified in the
<a href="#proxy_pass">proxy_pass</a> directive, or the protocol’s default port;</dd>

<dt id="var_proxy_add_x_forwarded_for">
<code>$proxy_add_x_forwarded_for</code></dt>
<dd>the “X-Forwarded-For” client request header field
with the <code>$remote_addr</code> variable appended to it, separated by a comma.
If the “X-Forwarded-For” field is not present in the client
request header, the <code>$proxy_add_x_forwarded_for</code> variable is equal
to the <code>$remote_addr</code> variable.</dd>
</dl><p> 
</p>

