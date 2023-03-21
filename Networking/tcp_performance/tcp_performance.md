# TCP Performance Tuening 

Copied from: https://cromwell-intl.com/open-source/performance-tuning/tcp.html 

<!DOCTYPE html>
<html xml:lang="en" class=" js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="UTF-8">
<title>TCP — Performance Tuning on Linux</title>
<meta name="description" content="How to tune the Linux kernel TCP performance to optimize data center NFS performance and other network services.">
<!-- start of standard header -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- style -->
<link rel="stylesheet" href="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.css">
<link rel="stylesheet" href="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/style.css">

<link rel="icon" type="image/png" href="https://cromwell-intl.com/pictures/favicon.png">
<!-- Safari -->
<link rel="apple-touch-icon" href="https://cromwell-intl.com/pictures/touch-icon-iphone-152x152.png">

<!-- Facebook, Twitter -->
<link rel="canonical" href="https://cromwell-intl.com/open-source/performance-tuning/tcp.html">
<meta property="og:title" content="TCP — Performance Tuning on Linux">
<meta name="twitter:title" content="TCP — Performance Tuning on Linux">
<meta name="twitter:description" content="How to tune the Linux kernel TCP performance to optimize data center NFS performance and other network services.">
<meta property="og:description" content="How to tune the Linux kernel TCP performance to optimize data center NFS performance and other network services.">
<meta property="fb:admins" content="bob.cromwell.10">
<meta property="fb:app_id" content="9869919170">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cromwell-intl.com/open-source/performance-tuning/tcp.html">
<meta property="og:site_name" content="Bob Cromwell: Travel, Linux, Cybersecurity">
<meta name="twitter:url" content="https://cromwell-intl.com/open-source/performance-tuning/tcp.html">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:creator" content="@ToiletGuru">

<!-- Google Page-level ads for mobile -->
<!-- Note: only need the adsbygoogle.js script this
one time in the header, not in every ad -->
<script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/googlesyndication_adsbygoogle.js"></script>
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
<meta name="twitter:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083052.jpg">
<meta property="og:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083052.jpg">
</head>

<body>
<article itemscope="" itemtype="http://schema.org/Article" class="container-fluid">
<!-- start of schema.org microdata included in all pages -->
<span itemprop="image" itemscope="" itemtype="https://schema.org/imageObject">
<meta itemprop="url" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083052.jpg">
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
<meta itemprop="headline" content="TCP — Performance Tuning on Linux">
<meta itemprop="datePublished" content="2022-10-01">
<meta itemprop="dateModified" content="2022-10-01">
<meta itemprop="mainEntityOfPage" content="https://cromwell-intl.com/open-source/performance-tuning/tcp.html">
<!-- end of schema.org microdata -->
<meta itemprop="about" content="Linux">
<meta itemprop="about" content="performance tuning">
<meta itemprop="about" content="networking">
<header>
<div>
<img src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/servers-083052-banner.jpg" alt="Linux servers.">
</div>
<h1>Performance Tuning on Linux — TCP</h1>
<div class="centered top-banner">
<ins class="adsbygoogle top-banner" style="display:inline-block; width:100%;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</header>

<section>
<h2 class="centered">
Tune TCP </h2>

<p>
<strong>We want to improve the performance of TCP applications.</strong>
Some of what we do here can help our public services,
predominantly HTTP/HTTPS, although performance across the
Internet is limited by latency and congestion
completely outside our control.
But we do have complete control within our data center,
and we must optimize TCP in order to optimize NFS and
other internal services.
</p>

<p>
We will first provide adequate memory for TCP buffers.
Then we will disable two options that are helpful on
WAN links with high latency and variable bandwidth but
degrade performance on fast LANs.
Finally, we will increase the initial congestion window sizes.
</p>

</section>
<section>
<h2> Memory Management for TCP </h2>

<p>
Kernel parameters for TCP are set in
<code>/proc/sys/net/core/[rw]mem*</code> and
<code>/proc/sys/net/ipv4/tcp*</code>,
those apply for both IPv4 and IPv6.
As with all the categories we've seen so far, only a few
of the available kernel parameters let us make useful changes.
Leave the rest alone.
</p>

<p>
Parameters <code>core/rmem_default</code> and
<code>core/wmem_default</code>
are the default receive and send tcp buffer sizes, while
<code>core/rmem_max</code> and <code>core/wmem_max</code>
are the maximum receive and send
buffer sizes that can be set using
<code>setsockopt()</code>, in bytes.
</p>
<p>
Parameters <code>ipv4/tcp_rmem</code> and
<code>ipv4/tcp_wmem</code>
are the amount of memory in bytes for
read (receive) and write (transmit) buffers per open socket.
Each contains three numbers: the minimum, default, and maximum
values.
</p>
<p>
Parameter <code>tcp_mem</code> is the amount of memory
in 4096-byte pages totaled across all TCP applications.
It contains three numbers: the minimum, pressure, and maximum.
The pressure is the threshold at which TCP will start to
reclaim buffer memory to move memory use down toward the
minimum.
You want to avoid hitting that threshold.
</p>

<pre># grep . /proc/sys/net/ipv4/tcp*mem
/proc/sys/net/ipv4/tcp_mem:181419  241895  362838
/proc/sys/net/ipv4/tcp_rmem:4096    87380   6291456
/proc/sys/net/ipv4/tcp_wmem:4096    16384   4194304 </pre>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_1" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame1"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

<p>
Increase the default and maximum for
<code>tcp_rmem</code> and <code>tcp_wmem</code>
on servers and clients when they are on either
a 10 Gbps LAN with latency under 1 millisecond,
or communicating over high-latency low-speed WANs.
In those cases their TCP buffers may
fill and limit throughput, because
the TCP window size can't be made large enough to handle
the delay in receiving ACK's from the other end.
IBM's <a href="https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Welcome%20to%20High%20Performance%20Computing%20%28HPC%29%20Central/page/Linux%20System%20Tuning%20Recommendations">
High Performance Computing page</a>
recommends 4096 87380 16777216.
</p>

<p>
Then, for <code>tcp_mem</code>, set it to twice
the maximum value for <code>tcp_[rw]mem</code>
multiplied by the maximum number of running network
applications divided by 4096 bytes per page.
</p>
<p>
Increase <code>rmem_max</code> and <code>wmem_max</code>
so they are at least as large as the third values of
<code>tcp_rmem</code> and <code>tcp_wmem</code>.
</p>

<!--
Example from GoDaddy hosting:
% ssh toiletguru@toilet-guru.com 'cat /proc/sys/net/ipv4/tcp_mem /proc/sys/net/ipv4/tcp_[rw]mem'
98304   131072  196608
4096    87380   4194304
4096    16384   4194304
-->

<p>
Calculate the <strong>bandwidth delay product,</strong>
the total amount of data in transit on the wire, as the
product of the bandwidth in bytes per second multiplied
by the round-trip delay time in seconds.
A 1 Gbps LAN with 2 millisecond round-trip delay means
125 Mbytes per second times 0.002 seconds or
250 kbytes.
</p>
<p>
If you don't have buffers this large on the hosts,
senders have to stop sending and wait for an acknowledgement,
meaning that the network pipe isn't kept full
and we're not using the full bandwidth.
<strong>Increase the buffer sizes as
the bandwidth delay product increases.</strong>
However, <strong>be careful.</strong>
The bandwidth delay product is the ideal,
although you can't really measure how it fluctuates.
If you provide buffers significantly larger than the
bandwidth delay product for connections outbound from
your network edge, you are just contributing to buffer
congestion across the Internet without making things
any faster for yourself.
</p>
<p>
Internet congestion will get worse as Windows XP machines
are retired.
XP did no window scaling, so it contributed far less
to WAN buffer saturation.
</p>

</section>
<section>
<h2> TCP Options </h2>

<p>
TCP Selective Acknowledgement (TCP SACK), controlled by
the boolean <code>tcp_sack</code>,
allows the receiving side to give the sender more detail
about lost segments, reducing volume of retransmissions.
This is useful on high latency networks, but disable this
to improve throughput on high-speed LANs.
Also disable <code>tcp_dsack</code>, if you aren't sending
SACK you certainly don't want to send duplicates!
Forward Acknowledgement works on top of SACK and will be
disabled if SACK is.
</p>

<p>
There is an option
<code>tcp_slow_start_after_idle</code>
which causes communication to start or resume gradually.
This is helpful <em>if</em> you are on a
variable speed WAN like 3G or 4G (LTE) mobile network.
But on a LAN or across a fixed-bandwidth WAN you want
the connection to start out going as fast as it can.
</p>

<p>
There are several TCP congestion control algorithms,
they are loaded as modules and
<code>/proc/sys/net/ipv4/tcp_available_congestion_control</code>
will list the currently loaded modules.
They are designed to quickly recover from packet loss
on high-speed WANs, so this may or may not be of interest
to you.
Reno is the TCP congestion control algorithm used
by most operating systems.
To learn more about some of the other choices:<br>
<a href="http://www.csc.ncsu.edu/faculty/rhee/export/bitcp/" class="btn btn-info">BIC</a>
<a href="http://www.csc.ncsu.edu/faculty/rhee/export/bitcp/cubic-paper.pdf" class="btn btn-info">CUBIC</a>
<a href="http://www.icir.org/floyd/hstcp.html" class="btn btn-info">High Speed TCP</a>
<a href="http://www.deneholme.net/tom/scalable/" class="btn btn-info">Scalable TCP</a>
<a href="http://www-ece.rice.edu/networks/TCP-LP/" class="btn btn-info">TCP Low Priority</a>
<a href="http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=1177186" class="btn btn-info">TCP Veno</a>
<a href="http://wil.cs.caltech.edu/pfldnet2007/paper/YeAH_TCP.pdf" class="btn btn-info">YeAH TCP</a>
<a href="http://www.ews.uiuc.edu/~shaoliu/tcpillinois/" class="btn btn-info">TCP Illinois</a>
<a href="http://simula.stanford.edu/~alizade/Site/DCTCP_files/dctcp-final.pdf" class="btn btn-info">DataCenter TCP (DCTCP)</a>
</p>

<p>
Use <code>modprobe</code> to load the desired modules and then
<code>echo</code> or <code>sysctl</code> to place the desired
option into <code>tcp_congestion_control</code>.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_2" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame2"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>


</section>
<section>
<h2> Setting Kernel Parameters </h2>

<p>
The following file <code>/etc/sysctl.d/02-netIO.conf</code>
will be used by <code>sysctl</code> at boot time.
</p>

<pre>### /etc/sysctl.d/02-netIO.conf
### Kernel settings for TCP

# Provide adequate buffer memory.
# rmem_max and wmem_max are TCP max buffer size
# settable with setsockopt(), in bytes
# tcp_rmem and tcp_wmem are per socket in bytes.
# tcp_mem is for all TCP streams, in 4096-byte pages.
# The following are suggested on IBM's
# <a href="https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Welcome%20to%20High%20Performance%20Computing%20%28HPC%29%20Central/page/Linux%20System%20Tuning%20Recommendations">High Performance Computing page</a>
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 87380 16777216
# This server might have 200 clients simultaneously, so:
#   max(tcp_wmem) * 2 * 200 / 4096
net.ipv4.tcp_mem = 1638400 1638400 1638400

# Disable TCP SACK (TCP Selective Acknowledgement),
# DSACK (duplicate TCP SACK), and FACK (Forward Acknowledgement)
net.ipv4.tcp_sack = 0
net.ipv4.tcp_dsack = 0
net.ipv4.tcp_fack = 0

# Disable the gradual speed increase that's useful
# on variable-speed WANs but not for us
net.ipv4.tcp_slow_start_after_idle = 0 </pre>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_3" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame3"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> Tune Initial Window Size </h2>

<p>
The header on every TCP segment contains a 16-bit field
advertising its current receive window size, 0 through 65,535,
and a 32-bit field reporting the acknowledgement number.
This means that everything up to the acknowledgement position
in the stream has been received, and the receiver has enough
TCP buffer memory for the sender to transmit up to the
window size in bytes beyond the latest acknowledgement.
</p>

<p>
The idea is to more efficiently stream data by using buffers
along the way to store segments and acknowledgements
"in flight" in either direction.
Across a fast switched LAN the improvement comes from
allowing the receiver to keep filling the buffer while
doing something else, putting off an acknowledgement packet
until the receive buffer starts to fill.
</p>

<p>
Increases in the initial TCP window parameters
can significantly improve performance.
The <em>initial receive window size</em> or
<strong>initrwnd</strong> specifies the receive window size
advertised at the beginning of the connection, in segments,
or zero to force Slow Start.
</p>
<p>
The <em>initial congestion window size</em> or
<strong>initcwnd</strong> limits the number of TCP segments the
server is willing to send at the beginning of the connection
before receiving the first ACK from the client, regardless
of the window size the client advertise.
The server might be overly cautious, only sending a
few kbytes and then waiting for an ACK because its
initial congestion window is too small.
It will send the smaller of the receiver's window size
and the server's initcwnd.
We have to put up with whatever the client says,
but we can crank up the initcwnd value on the server
and usually make for a much faster start.
</p>

<p>
<a href="http://research.google.com/pubs/pub36640.html">
Researchers at Google</a>
studied this.
Browsers routinely open many connections to load a single page
and its components, each of which will otherwise start slow.
They recommend increasing initcwnd to at least 10.
</p>

<p>
CDN Planet has an interesting and much simpler
<a href="http://www.cdnplanet.com/blog/tune-tcp-initcwnd-for-optimum-performance/">
article</a>
showing that increasing initcwnd to 10 cuts the total load
time for a 14 kbyte file to about half the original time.
They also
<a href="http://www.cdnplanet.com/blog/initcwnd-settings-major-cdn-providers/">
found</a>
that many content delivery networks use an initcwnd of 10
and some set it even higher.
</p>

<p>
The initrwnd and initcwnd are specified in the routing table,
so you can tune each route individually.
If specified, they apply to all TCP connections made
via that route.
</p>

<p>
First, look at the routing table.
Let's use this simple example.
This server has an Internet-facing connection on enp0s2
and is connected to an internal LAN through enp0s3.
Let's say it's an HTTP/HTTPS server on the Internet side,
and an client of NFSv4 over TCP on the internal side.
</p>

<pre style="clear: both;"># ip route show
default via 24.13.158.1 dev enp0s2
10.1.1.0/24 dev enp0s3  proto kernel  scope link  src 10.1.1.100 
24.13.158.0/23 dev enp0s2  proto kernel  scope link  src 24.13.159.33  </pre>

<p>
Now we will modify the routes to specify both initcwnd
and initrwnd of 10 segments:
</p>
<pre># ip route change default via 24.13.158.1 dev enp0s2 initcwnd 10 initrwnd 10
# ip route change 10.1.1.0/24 dev enp0s3 proto kernel scope link src 10.1.1.100 initcwnd 10 initrwnd 10
# ip route change 24.13.158.0/23 dev enp0s2 proto kernel scope link src 24.13.159.33 initcwnd 10 initrwnd 10
# ip route show
default via 24.13.158.1 dev enp0s2  <b>initcwnd 10  initrwnd 10</b>
10.1.1.0/24 dev enp0s3  proto kernel  scope link  src 10.1.1.100  <b>initcwnd 10  initrwnd 10</b>
24.13.158.0/23 dev enp0s2  proto kernel  scope link  src 24.13.159.33  <b>initcwnd 10 initrwnd 10</b> </pre>

<p>
The appropriate commands could be added to
<code>/etc/rc.d/rc.local</code> for application
at boot time.
</p>
<p>
Changes to the TCP window size also affect UDP buffering.
On nets faster than 1 Gbps make sure that your applications
use <code>setsockopt()</code> to request larger
<code>SO_SNDBUF</code> and <code>SO_RCVBUF</code>.
</p>

<h2> Going Further </h2>

<p>
Calomel has a great page on
<a href="https://calomel.org/freebsd_network_tuning.html">
performance tuning</a>,
although it is <em>specific to FreeBSD.</em>
But read through their descriptions of how to tune BSD
kernel parameters, and apply what you can to an analysis
and tuning of your server.
</p>

<h2> And next...</h2>

<p>
<strong>Now that we have tuned the networking protocols, we can
<a href="https://cromwell-intl.com/open-source/performance-tuning/nfs.html">
tune NFS file service</a>
running on top of TCP.</strong>
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/nfs.html" class="btn btn-lg btn-success btn-block">
<strong>Next:</strong>
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/applications.html" class="btn btn-lg btn-info btn-block">
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
<div id="amzn-assoc-ad-ef2fcc8e-0ac6-4a12-8f2b-bfcaa5e8eb58"></div><script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs_002"></script><!-- end Amazon related ads -->

<!-- Amazon oneTag script -->
<script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs"></script>

<!-- Google matched content -->
<p style="font-size:0.8rem; text-align:left; margin:0; padding:2px;">
Now some lurid advertisements from Google AdSense:
</p>
<div class="centered">
<ins class="adsbygoogle" style="display:block;" data-ad-client="ca-pub-5845932372655417" data-ad-slot="9123376601" data-ad-format="autorelaxed"><iframe id="aswift_4" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame4"></iframe></iframe></ins>
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
<a href="https://validator.w3.org/nu/?showsource=yes&amp;doc=https://cromwell-intl.com/open-source/performance-tuning/tcp.html"><img src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/html5-badge-h-css3-semantics.png" alt="Valid HTML 5.  Validate it here." loading="lazy" style="padding: 0; margin: 0;"></a>
<br>
<a href="https://jigsaw.w3.org/css-validator/check/referer">
<img src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/valid-css.png" alt="Valid CSS.  Validate it here." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:12%;">
<a href="https://www.unicode.org/">
<img src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/unicode.png" alt="Valid Unicode." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://nginx.org/">
<img src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nginx_logo-70pc.png" alt="Nginx" loading="lazy"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://www.freebsd.org/">
<img src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/powerlogo.gif" alt="FreeBSD" loading="lazy"></a>
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
<script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/modernizr.min.js" integrity="sha512-3n19xznO0ubPpSwYCRRBgHh63DrV+bdZfHK52b1esvId4GsfwStQNPJFjeQos2h3JwCmZl0/LgLxSKMAI55hgw==" crossorigin="anonymous"></script>
<script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/jquery-3.6.1.slim.min.js" integrity="sha384-MYL22lstpGhSa4+udJSGro5I+VfM13fdJfCbAzP9krCEoK5r2EDFdgTg2+DGXdj+" crossorigin="anonymous"></script>
<script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


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
<script>   var infolinks_pid = 3267443;   var infolinks_wsid = 0; </script> <script async="" src="TCP%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/infolinks_main.js"></script>
<!-- end of footer.html -->


</body></html>