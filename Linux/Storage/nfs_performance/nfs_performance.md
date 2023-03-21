# NFS Performance

Copy of: https://cromwell-intl.com/open-source/performance-tuning/nfs.html

<!DOCTYPE html>
<html xml:lang="en" class=" js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="UTF-8">
<title>NFS — Performance Tuning on Linux</title>
<meta name="description" content="How to optimize NFS performance on Linux with kernel tuning and appropriate mount and service options on the server and clients.">
<!-- start of standard header -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- style -->
<link rel="stylesheet" href="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.css">
<link rel="stylesheet" href="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/style.css">

<link rel="icon" type="image/png" href="https://cromwell-intl.com/pictures/favicon.png">
<!-- Safari -->
<link rel="apple-touch-icon" href="https://cromwell-intl.com/pictures/touch-icon-iphone-152x152.png">

<!-- Facebook, Twitter -->
<link rel="canonical" href="https://cromwell-intl.com/open-source/performance-tuning/nfs.html">
<meta property="og:title" content="NFS — Performance Tuning on Linux">
<meta name="twitter:title" content="NFS — Performance Tuning on Linux">
<meta name="twitter:description" content="How to optimize NFS performance on Linux with kernel tuning and appropriate mount and service options on the server and clients.">
<meta property="og:description" content="How to optimize NFS performance on Linux with kernel tuning and appropriate mount and service options on the server and clients.">
<meta property="fb:admins" content="bob.cromwell.10">
<meta property="fb:app_id" content="9869919170">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cromwell-intl.com/open-source/performance-tuning/nfs.html">
<meta property="og:site_name" content="Bob Cromwell: Travel, Linux, Cybersecurity">
<meta name="twitter:url" content="https://cromwell-intl.com/open-source/performance-tuning/nfs.html">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:creator" content="@ToiletGuru">

<!-- Google Page-level ads for mobile -->
<!-- Note: only need the adsbygoogle.js script this
one time in the header, not in every ad -->
<script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/googlesyndication_adsbygoogle.js"></script>
<script>
(adsbygoogle = window.adsbygoogle || []).push({
google_ad_client: "ca-pub-5845932372655417",
enable_page_level_ads: true
});
</script>

<!-- Google webmaster tools -->
<meta name="google-site-verification" content="-QwRAzF67ZlYJ9S4v3SCsyDceuoD2J7wLepdqiSX_Q4">
<link rel="author" href="https://plus.google.com/+BobCromwell">

<!-- Google translate -->
<meta name="google-translate-customization" content="e577b45d2703b3f4-274692b0024c3c77-gc02a134c617e3801-12">

<!-- Bing webmaster tools -->
<meta name="msvalidate.01" content="3E2092BE1413B6791596BCC09A493E58">



<!-- end of standard header -->
<meta name="twitter:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_082937.jpg">
<meta property="og:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_082937.jpg">
</head>

<body>
<article itemscope="" itemtype="http://schema.org/Article" class="container-fluid">
<!-- start of schema.org microdata included in all pages -->
<span itemprop="image" itemscope="" itemtype="https://schema.org/imageObject">
<meta itemprop="url" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_082937.jpg">
<meta itemprop="width" content="600px">
<meta itemprop="height" content="800px">
</span>
<meta itemprop="author" content="Bob Cromwell">
<span itemprop="publisher" itemscope="" itemtype="https://schema.org/organization">
<meta itemprop="name" content="Cromwell International">
<span itemprop="logo" itemscope="" itemtype="https://schema.org/imageObject">
<meta itemprop="url" content="https://cromwell-intl.com/pictures/cartoon-headshot-2484-10pc.jpg">
<meta itemprop="width" content="310px">
<meta itemprop="height" content="259px">
</span>
</span>
<meta itemprop="headline" content="NFS — Performance Tuning on Linux">
<meta itemprop="datePublished" content="2022-10-01">
<meta itemprop="dateModified" content="2022-10-01">
<meta itemprop="mainEntityOfPage" content="https://cromwell-intl.com/open-source/performance-tuning/nfs.html">
<!-- end of schema.org microdata -->
<meta itemprop="about" content="Linux">
<meta itemprop="about" content="performance tuning">
<meta itemprop="about" content="file server">
<header>
<div>
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/servers-082937-banner.jpg" alt="Linux servers.">
</div>
<h1>Performance Tuning on Linux — NFS</h1>
<div class="centered top-banner">

<ins class="adsbygoogle top-banner" style="display:inline-block; width:100%;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</header>

<section>
<h2 class="centered">
Tune NFS Performance </h2>

<p>
<strong>NFS performance is achieved through first tuning
the underlying networking — Ethernet and TCP
— and then selecting appropriate NFS
parameters.</strong>
NFS was originally designed for trusted environments
of a scale that today seems rather modest.
The primary design goal was data integrity, not performance,
which makes sense as Ethernet of the time ran at 10 Mbps
and files and file systems were relatively small.
The integrity goal led to a use of synchronous
write operations, greatly slowing things down.
But simultaneously, there was no lock function in the NFS
server itself and multiple clients could write to the same
file at the same time, leading to unpredictable corruption.
</p>

<p>
As for the trust built into the system, there was no real
security mechanism beyond access control based on IP addresses
plus the assumption that user and group IDs were consistent
across all systems on the network.
</p>

<p>
The NFS server and the added NFS lock server were not
required to run on any specific port, so the RPC port
mapper was invented.
The port mapper did a great job of solving a problem
that didn't need to exist.
It would start as one of the first network services,
then all these other services expected to be listening on
unpredictable ports would start and register
themselves with the port mapper.
<em>"If anyone asks, I'm listening on TCP port 2049."</em>
A client would first connect to the port mapper on its
predictable TCP port 111 and then ask it how to connect
to the service they really wanted.
</p>

<p>
Like I said, a solution to a problem that shouldn't have
been there in the first place.
The NFS server was about the only network service that needed
the port mapper, and it generally listened on the same port
every time.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_1" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame1"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> Evolution of NFS Versions </h2>

<p>
<strong>NFS version 2</strong> only allowed access to
the first 2 GB of a file.
The client made the decision about whether the user
could access the file or not.
This version supported UDP only,
and it limited write operations to 8 kbytes.
Ugh.
It was a nice start, though.
</p>

<p>
<strong>NFS version 3</strong> supported much larger files.
The client could ask the server to make the access
decision — although it didn't have to and so
we still had to fully trust all client hosts.
NFSv3 over UDP could use up to 56 kbyte transactions.
There was now support for NFS over TCP, although client
implementations varied quite a bit as to details with
associated compatibility issues.
</p>

<p>
<strong>NFS version 4</strong> added statefulness,
so an NFSv4 client could directly inform the server
about its locking, reading, writing the file, and so on.
All the NFS application protocols — mount, stat,
ACL checking, and the NFS file service itself,
run over a single network protocol always running on
a predictable TCP port 2049.
There is no longer any need for an RPC port mapper to
start first, or for separate mount and file locking
daemons to run independently.
Access control is now done by user name, not possibly
inconsistent UID and GID as before, and security could
be further enhanced with the use of Kerberos.
</p>

<p>
<strong>NFS version 4.1</strong> added Parallel NFS (or pNFS),
which can stripe data across multiple NFS servers.
You can do block-level access and use NFS v4.1 much like
Fibre Channel and iSCSI, and object access is meant to
be analogous to AWS S3.
NFS v4.1 added some performance enhancements 
Perhaps more importantly to many current users,
NFS v4.1 on Linux better inter-operates
with non-Linux NFS servers and clients.
Specifically, mounting NFS from Windows servers
using Kerberos V5.
For all the details see
<a href="https://tools.ietf.org/html/rfc5661">RFC 5661</a>.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_2" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame2"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> NFS Performance Goals </h2>

<p>
Rotating SATA and SAS disks can provide I/O of about 1 Gbps.
Solid-state disks can fill the 6 Gbps bandwidth
of a SATA 3 controller.
NFS should be about this fast, filling a 1 Gbps LAN.
NFS SAN appliances can fill a 10 Gbps LAN.
Random I/O performance should be good,
about 100 transactions per second per spindle.
</p>

</section>
<section>
<h2> Configuring NFS </h2>

<p>
On the server,
specify what you will export, to which clients, and how, in
<code>/etc/exports</code>.
</p>
<p>
On the client, specify what you will mount, from which server,
and how, in
<a href="http://linux.die.net/man/5/fstab">
<code>/etc/fstab</code></a>
for static mounts always made when the system starts,
or through the
<a href="http://linux.die.net/man/8/automount">automounter</a>
for mounts accessed only as needed.
See the automounter details below.
</p>

</section>
<section>
<h2> NFS Performance </h2>

<p>
First, of course, optimize the local I/O on the server, both
<a href="https://cromwell-intl.com/open-source/performance-tuning/disks.html">
block device I/O</a>
and the
<a href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">
file systems</a>.
Then optimize both
<a href="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html">
Ethernet</a>
and
<a href="https://cromwell-intl.com/open-source/performance-tuning/tcp.html">
TCP</a>
performance on the servers and clients.
Only after doing that will it make sense to worry
about NFS details.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_3" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame3"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h3> Tuning the NFS Client </h3>

<p>
You can get NFS statistics for each mounted file system
with <code>mountstats</code>.
</p>
<pre># mountstats /path/to/mountpoint </pre>

<p>
For each NFS operation you get a count of how many times
it has happens plus statistics on those events: bytes
per operations, execute time, retransmissions and timeouts,
etc.
RTT or Round-Trip Time in milliseconds should be checked
for NFS mounts used by interactive applications.
</p>

</section>
<section>
<h4> Specify NFS v4.1 or, Better Yet, v4.2</h4>

<p>
Make sure to specify the appropriate NFS version.
<strong>You will have to experiment, this has been changing
without corresponding updates in the manual pages
or in Red Hat's on-line documentation.</strong>
You may find that both of the below work, but you may
need to use just one or the other.
</p>

<pre><em style="background: #ddd;">probably:</em>
# mount -o nfsvers=4.2 srvr:/export /mountpoint

<em style="background: #ddd;">or possibly:</em>
# mount -o nfsvers=4,minorversion=2 srvr:/export /mountpoint </pre>

</section>
<section>
<h4> Specify Bytes Per Read/Write With
<code>rsize</code> and <code>wsize</code> </h4>

<p>
The <code>rsize</code> and <code>wsize</code> options
specify the number of bytes per NFS read and write
request, respectively.
</p>
<p>
For the read size, set this as large as possible if your
work load's reading is predominantly sequential —
streaming media files, for example.
</p>

<p>
If your work load's reading is predominantly random,
as for typical user file service, match the I/O size
used on the server.
</p>
<p>
For the write size, you could try to match the I/O size on
the server or simply maximize <code>wsize</code>.
Try both and compare performance.
</p>
<p>
Both clients and servers should be able to do 1 MB
read and write transfers.
</p>

<p>
Note that <code>rsize</code> and <code>wsize</code> are
<em>requests,</em> the client and server must negotiate
a mutually supported set of parameters.
See the packet trace below.
</p>

<p>
Put options for static mounts in <code>/etc/fstab</code>.
Put options for automounted file systems in the map file.
</p>

<pre style="clear: both;"># grep nfs /etc/fstab
srvr1:/usr/local  /usr/local  nfs  nfsvers=4.2,rsize=131072,wsize=131072  0  0
# tail -1 /etc/autofs/auto.master
/-   auto.local
# cat /etc/autofs/auto.local
/usr/local  -nfsvers=4.2,rsize=131072,wsize=131072  srvr1:/usr/local </pre>

<p>
What may be a better way is to use the systemd automounter.
</p>

<pre># grep nfs /etc/fstab
srvr1:/usr/local  /usr/local  nfs  noauto,x-systemd.automount,nfsvers=4.2,rsize=131072,wsize=131072  0  0 </pre>


<h5> Why Does The Output of <code>mount</code> Show Smaller
<code>rsize</code> and <code>wsize</code> than I
Requested? </h5>

<p>
Short answer:  Because what you got is all the server supports.
</p>

<p>
Detailed answer:
Below is a Wireshark trace of an NFS 4.1 session negotiation.
The selected packet shows the client request.
See
<a href="https://tools.ietf.org/html/draft-ietf-nfsv4-minorversion1-10#page-395">
section 17.36.5 of the IETF NFSv4.1 draft</a>
for an explanation.
Fields <code>csa_fore_chan_attrs</code> and
<code>csa_back_chan_attrs</code>
apply to attributes of the fore channel (also called the
operations channel, requests from the client to server)
and the back channel (requests from the server to client).
Values <code>ca_maxrequestsize</code> and
<code>ca_maxresponsesize</code>
are the maximum sizes of requests that will be sent
and responses that will be accepted.
Wireshark displays these as
<code>max_req_size</code> and <code>max_resp_size</code>.
</p>
<p>
Notice that the client 10.1.1.100 asks for 1,049,620.
That is the maximum possible NFS payload, 1,048,576,
plus 1,044.
</p>

<div class="centered">
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nfs41-session-1.png" alt="Wireshark capture of NFS 4.1 session negotiation, client request." class="bordered" loading="lazy">
</div>

<p>
This later packet is a response to the above one.
Notice that the server 10.1.1.232 specifies
<code>max_req_size</code> and <code>max_resp_size</code>
of 69,632, and 4,096&nbsp;+&nbsp;65,536&nbsp;=&nbsp;69,632.
</p>

<div class="centered">
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nfs41-session-2.png" alt="Wireshark capture of NFS 4.1 session negotiation, server response." class="bordered" loading="lazy">
</div>

<p>
Run <code>mount | grep nfs</code> on the client and you will
see
<code>rsize=65536,wsize=65536</code>.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_4" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame4"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h3> Tuning the NFS Server </h3>

<p>
First, apply all the earlier tuning to the local file system.
If the server can't get data on and off its disks quickly,
there's no hope of then getting that on and off the
network quickly.
</p>

<p>
<strong>Start plenty of NFS daemon threads.</strong>
The default is 8, increase this with
<code>RPCNFSDCOUNT=<em>NN</em></code> in
<code>/etc/sysconfig/nfs</code>.
Start <em>at least</em> one thread per processor core.
There is little penalty in starting too many threads,
make sure you have enough.
</p>

<p>
Check the NFS server statistics with <code>nfsstat</code>.
</p>
<pre># nfsstat -4 -s </pre>

<p>
Start by tuning whatever your server does most.
</p>
<ul>
<li>
If <code>read</code> dominates, add RAM on the clients
to cache more of the file systems and reduce read
operations.
</li>
<li>
If <code>write</code> dominates, make sure the clients
are using <code>noatime,nodiratime</code> to avoid
updating access times.
Make sure your server's local file system access
has been optimized.
</li>
<li>
If <code>getattr</code> dominates,
tune the attribute caches.
If you were using <code>noac</code> (which many
recommend against), try removing that.
</li>
<li>
If <code>readdir</code> dominates,
turn off attribute caching on the clients.
</li>
</ul>

<p>
Examine kernel structure <code>/proc/net/rpc/nfsd</code>
to see how busy the NFS server threads are.
The line starting <code>th</code> lists the number of
threads, and the last ten numbers are a histogram of the
number of seconds the first 10% of threads were busy,
the second 10%, and so on.
</p>
<p>
Load your system heavily and examine <code>/proc/net/rpc/nfsd</code>.
Add threads until the last two numbers are zero or nearly zero.
That means you have enough NFS server threads that they
never or almost never are over 80% busy.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_5" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame5"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h3> RDMA, or Remote Direct Memory Access </h3>

<p>
DMA or Direct Memory Access is a mechanism to allow an
application to more directly read and write from and to
local hardware, with fewer operating systems modules and
buffers along the way.
</p>
<p>
RDMA extends that across a LAN, where an Ethernet packet
arrives with RDMA extension.
The application communicates directly with the Ethernet adapter.
Application DMA access to the RDMA-capable Ethernet card
is much like reaching across the LAN to the remote Ethernet
adapter and through it to its application.
This decreases latency and increases throughput (a rare case
of making both better at once) and it decreases the CPU load
at both ends.
RDMA requires recent server-class Ethernet adapters,
a recent kernel, and user-space tools.
</p>

</section>
<section>
<h2> Security and Reliability Issues </h2>

</section>
<section>
<h3> <code>/etc/exports</code> Syntax </h3>

<p>
First, be aware that <code>/etc/exports</code> is very
fussy about its format.
This does what you expect, sharing file system tree
to <code>clienthost</code> in read-write mode:
</p>
<pre>/path/to/export  clienthost(rw) </pre>

<p>
The space in the following means that there are <em>two</em>
grantees of access to the exported file system.
It will first grant access to <code>clienthost</code>,
read-write because that's the default.
<em>Then it also grants access to all other hosts in
read-write mode because of the separate
<code>(rw)</code>.</em>
This is almost certainly <em>not</em> what the
administrator intended!
</p>
<pre>/path/to/export  clienthost (rw) </pre>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_6" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame6"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h3> <code>root</code> Squashing </h3>

<p>
The special user <code>root</code> is "squashed" to the
user <code>nobody</code> in order to compartmentalize
privileged access across an organization.
A user might boot a system from media and be <code>root</code>
on that workstation, change its IP if needed to gain access,
and mount a file system.
<em>But the user <code>root</code> and only that user
is "squashed" to the unprivileged <code>nobody</code>
and only has the privileges that are
given to all users.</em>
</p>
<p>
If you do want <code>root</code> to have the usual full
access on NFS-mounted file systems, export them with the
<code>no_root_squash</code> option:
</p>
<pre>/path/to/export  10.0.0.0/8(rw,no_root_squash) </pre>

</section>
<section>
<h3> Subtree Checking </h3>

<p>
Let's say that you export <code>/usr/local</code>,
which is part of the root file system.
</p>
<pre># cat /etc/exports
/usr/local  10.0.0.0/8(rw,no_root_squash)
# df /usr/local
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       150G   68G   67G  45% /
</pre>

<p>
There is a risk that an illicit administrator,
possibly on a compromised client, could guess
the file handle for a file on that file system
but not contained within the <code>/usr/local</code>
hierarchy.
As the export does not squash <code>root</code>,
the file <code>/etc/shadow</code> would be of
particular interest on that file system but
outside the export.
</p>
<p>
There is an option <code>subtree_check</code>
which enforces additional checks on the server to
verify that the requested file is contained within
the exported hierarchy.
You can specify <code>subtree_check</code> to force this
security check or <code>no_subtree_check</code> to avoid it.
The default behavior has changed back and forth.
It is easy to check which mounted file system a file is in,
it is surprisingly expensive to check if it is contained
within the exported hierarchy within that.
</p>

<p>
It has lately been felt that the minor security improvement
provided by <code>subtree_check</code> is overwhelmed by the
associated performance degradation, so from release 1.0.0
of the nfs-utils package forward, <code>no_subtree_check</code>
is the default.
</p>

<p>
<strong>The best solution is to make an exported hierarchy
be an independent file system.</strong>
In our example, if we want to share <code>/usr/local</code>
via NFS, then it should be an independent file system.
</p>
<pre># cat /etc/exports
/usr/local  10.0.0.0/8(rw,no_root_squash)
# df /usr/local
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1       917G  565G  353G  62% /usr/local </pre>


<h2> And next... </h2>

<p>
We have finished tuning the Linux operating system!
<strong>Now we can
<a href="https://cromwell-intl.com/open-source/performance-tuning/applications.html">
measure application resource use</a>
to see if we need to make any changes.</strong>
</p>

</section>

<nav>
<div class="row centered">

<div class="col-12 col-md-4">
<a href="https://cromwell-intl.com/open-source/performance-tuning/hardware.html" class="btn btn-lg btn-primary btn-block">
<strong>RAM and disk storage</strong><br>
RAM I/O speeds,
disk controllers and interfaces,
rotating versus solid-state disks,
performance versus power saving</a>
</div>

<div class="col-12 col-md-4">
<a href="https://cromwell-intl.com/open-source/performance-tuning/disks.html" class="btn btn-lg btn-primary btn-block">
<strong>Disk I/O</strong><br>
Elevator sorting algorithms,
tuning the scheduler,
disk memory management,
measuring disk I/O
</a>
</div>

<div class="col-12 col-md-4">
<a href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html" class="btn btn-lg btn-primary btn-block">
<strong>File Systems</strong><br>
Use multiple file systems,
choose a file system type,
create file systems,
limit fragmentation,
mount options,
journaling modes
</a>
</div>

<div class="clearfix visible-sm visible-md visible-lg"></div>

<div class="col-12 col-md-5">
<a href="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html" class="btn btn-lg btn-primary btn-block">
<strong>Ethernet options</strong><br>
Capacity planning,
measuring utilization,
enabling jumbo frames,
driver tuning with <code>ethtool</code>,
protocol offload,
kernel parameters for queue length
</a>
</div>

<div class="col-12 col-md-3">
<a href="https://cromwell-intl.com/open-source/performance-tuning/tcp.html" class="btn btn-lg btn-primary btn-block">
<strong>TCP tuning</strong><br>
Memory management,
TCP options,
initial window sizes
</a>
</div>

<div class="col-12 col-md-4">
<a href="https://cromwell-intl.com/open-source/performance-tuning/nfs.html" class="btn btn-lg btn-primary btn-block">
<strong>NFS tuning</strong><br>
NFS versions,
performance goals,
client options,
server options
server daemon threads,
RDMA,
security issues
</a>
</div>

<div class="clearfix visible-sm visible-md visible-lg"></div>

<div class="col-12 col-md-6">
<a href="https://cromwell-intl.com/open-source/performance-tuning/applications.html" class="btn btn-lg btn-success btn-block">
<strong>Next:</strong>
<strong>Measuring and Tuning Applications</strong>
</a>
</div>

<div class="col-12 col-md-6">
<a href="https://cromwell-intl.com/open-source/performance-tuning/measurements.html" class="btn btn-lg btn-info btn-block">
<strong>Taking Meaningful Measurements</strong>
</a>
</div>

<div class="col-12">
<a href="https://cromwell-intl.com/open-source/performance-tuning/" class="btn btn-info btn-block">
<strong>Back to the introduction</strong>
</a>
</div>

</div>
</nav>

<a href="https://cromwell-intl.com/open-source" class="btn btn-info btn-lg">
To the Linux / Unix Page</a>

<!-- start of footer.html -->
<footer>
<nav class="cb centered">
<hr style="margin-bottom: 2px; padding-bottom: 0px;">

<!-- Amazon related ads -->
<div id="amzn-assoc-ad-ef2fcc8e-0ac6-4a12-8f2b-bfcaa5e8eb58"></div><script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs_002"></script><!-- end Amazon related ads -->

<!-- Amazon oneTag script -->
<script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs"></script>

<!-- Google matched content -->
<p style="font-size:0.8rem; text-align:left; margin:0; padding:2px;">
Now some lurid advertisements from Google AdSense:
</p>
<div class="centered">
<ins class="adsbygoogle" style="display:block;" data-ad-client="ca-pub-5845932372655417" data-ad-slot="9123376601" data-ad-format="autorelaxed"><iframe id="aswift_7" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame7"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>


<nav class="row centered" style="margin-top:1px; padding-top:0; margin-bottom: 1em;">
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/" class="btn btn-info btn-block">
Home</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/travel/" class="btn btn-info btn-block">
Travel</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/open-source/" class="btn btn-info btn-block">
Linux/Unix</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/cybersecurity/" class="btn btn-info btn-block">
Cybersecurity</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/networking/" class="btn btn-info btn-block">
Networking</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/technical/" class="btn btn-info btn-block">
Technical</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/radio/" class="btn btn-info btn-block">
Radio</a>
</div>
<div class="col-6 col-md-3">
<a href="https://cromwell-intl.com/site-map.html" class="btn btn-info btn-block">
Site Map</a>
</div>
</nav>

<div class="fr" style="max-width:18%;">
<a href="https://validator.w3.org/nu/?showsource=yes&amp;doc=https://cromwell-intl.com/open-source/performance-tuning/nfs.html"><img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/html5-badge-h-css3-semantics.png" alt="Valid HTML 5.  Validate it here." loading="lazy" style="padding: 0; margin: 0;"></a>
<br>
<a href="https://jigsaw.w3.org/css-validator/check/referer">
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/valid-css.png" alt="Valid CSS.  Validate it here." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:12%;">
<a href="https://www.unicode.org/">
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/unicode.png" alt="Valid Unicode." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://nginx.org/">
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nginx_logo-70pc.png" alt="Nginx" loading="lazy"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://www.freebsd.org/">
<img src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/powerlogo.gif" alt="FreeBSD" loading="lazy"></a>
</div>

<div class="fl">

<a href="https://mastodon.world/@bobthetraveler" rel="me" class="badge badge-pill badge-success" style="margin-bottom:5px;"><span style="font-size:1.25rem;">🦣</span> Bob the Traveler</a>
&nbsp;
<a href="https://mstdn.social/@conansysadmin" rel="me" class="badge badge-pill badge-success" style="margin-bottom:5px;"><span style="font-size:1.25rem;">🦣</span> Conan the Sysadmin</a>
<br>

<!--
<a href="https://twitter.com/share" class="twitter-share-button" data-lang="en" data-count="none" style="margin:0; padding:0;">Tweet</a>
<a href="https://twitter.com/ToiletGuru" class="twitter-follow-button" data-show-count="false" data-show-screen-name="false">Follow @ToiletGuru</a>
<br>

<script async src="//platform.linkedin.com/in.js"></script><script type="IN/Share"></script>

<a href="https://www.reddit.com/login?dest=https%3A%2F%2Fwww.reddit.com%2Fsubmit" onclick="window.location = 'https://www.reddit.com/login?dest=https%3A%2F%2Fwww.reddit.com%2Fsubmit' + encodeURIComponent(window.location); return false"><img src="https://www.redditstatic.com/spreddit6.gif" alt="submit to reddit" loading="lazy" style="position:relative; margin:0; padding:0;"></a>
-->
</div>

<aside>
<p class="fr textright" style="font-size: 0.8rem;">
Viewport size:
<span id="w">1743</span> × <span id="h">793</span>
<script>
(function() {
if (typeof(document.documentElement.clientWidth) != 'undefined') {
var $w = document.getElementById('w'),
$h = document.getElementById('h');
$w.innerHTML = document.documentElement.clientWidth;
$h.innerHTML = document.documentElement.clientHeight;
window.onresize = function(event) {
$w.innerHTML = document.documentElement.clientWidth;
$h.innerHTML = document.documentElement.clientHeight;
};
}
})();
</script>
<br>
<a href="https://cromwell-intl.com/open-source/google-freebsd-tls/apache-http2-php.html">Protocol</a>: HTTP/2.0<br><a href="https://cromwell-intl.com/open-source/nginx-tls-1.3/">Crypto</a>: TLSv1.3 / X25519 / TLS_AES_256_GCM_SHA384</p>
</aside>

<!-- margin-bottom needed for infolinks ad -->
<p class="fr centered" style="font-size:0.9rem; margin-bottom:120px;">
© by
<a href="https://cromwell-intl.com/contact.html">Bob Cromwell</a>
Mar 2023. Created with
<a href="http://thomer.com/vi/vi.html"><code>vim</code></a>
and
<a href="https://www.imagemagick.org/">ImageMagick</a>,
hosted on
<a href="https://www.freebsd.org/">FreeBSD</a>
with
<a href="https://nginx.org/">Nginx</a>.
<br>
As an Amazon Associate, I earn from qualifying purchases.
<br>
<a href="https://cromwell-intl.com/contact.html">Contact</a> |
<a href="https://cromwell-intl.com/cybersecurity/privacy-policy.html">Privacy policy</a> |
<a href="https://cromwell-intl.com/cybersecurity/root-password.html">Root password</a>
</p>

</nav>


</footer>
</article>

<!-- moved to footer for speed, get JavaScript from CDN -->
<!-- get integrity="..." strings from https://www.srihash.org/ -->
<script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/modernizr.min.js" integrity="sha512-3n19xznO0ubPpSwYCRRBgHh63DrV+bdZfHK52b1esvId4GsfwStQNPJFjeQos2h3JwCmZl0/LgLxSKMAI55hgw==" crossorigin="anonymous"></script>
<script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/jquery-3.6.1.slim.min.js" integrity="sha384-MYL22lstpGhSa4+udJSGro5I+VfM13fdJfCbAzP9krCEoK5r2EDFdgTg2+DGXdj+" crossorigin="anonymous"></script>
<script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


<!--	Use this to "lazy-load" images as: <img data-src="...
<script async src="/js/jquery.lazyloadxt.js"></script>
-->

<!-- social media button support -->

<!-- twitter support -->
<!--
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
-->

<!-- facebook support -->
<!--
<div id="fb-root"></div>
<script>(function(d, s, id) {
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) return;
js = d.createElement(s); js.id = id;
js.src = "https://connect.facebook.net/en_US/all.js#xfbml=1";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
-->

<!-- pinterest -->
<!--
<script>
(function(d){
var f = d.getElementsByTagName('SCRIPT')[0], p = d.createElement('SCRIPT');
p.type = 'text/javascript';
p.async = true;
p.src = '//assets.pinterest.com/js/pinit.js';
f.parentNode.insertBefore(p, f);
}(document));
</script>
-->

<!-- Infolinks ad support -->
<script>   var infolinks_pid = 3267443;   var infolinks_wsid = 0; </script> <script async="" src="NFS%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/infolinks_main.js"></script>
<!-- end of footer.html -->


</body></html>