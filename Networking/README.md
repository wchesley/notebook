# Networking

- [Ethernet Performance tuening - Linux](./ethernet_performance_linux/ethernet_performance_linux.md)
- [TCP Performance Tuening](./tcp_per<!DOCTYPE html>
<html xml:lang="en" class=" js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta charset="UTF-8">
		<title>Ethernet — Performance Tuning on Linux</title>
		<meta name="description" content="How to tune the Linux kernel to optimize Ethernet performance, supporting high performance TCP and NFS in a data center.">
				<!-- start of standard header -->
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<!-- style -->
		<link rel="stylesheet" href="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.css">
		<link rel="stylesheet" href="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/style.css">

		<link rel="icon" type="image/png" href="https://cromwell-intl.com/pictures/favicon.png">
		<!-- Safari -->
		<link rel="apple-touch-icon" href="https://cromwell-intl.com/pictures/touch-icon-iphone-152x152.png">

		<!-- Facebook, Twitter -->
		<link rel="canonical" href="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html">
		<meta property="og:title" content="Ethernet — Performance Tuning on Linux">
		<meta name="twitter:title" content="Ethernet — Performance Tuning on Linux">
		<meta name="twitter:description" content="How to tune the Linux kernel to optimize Ethernet performance, supporting high performance TCP and NFS in a data center.">
		<meta property="og:description" content="How to tune the Linux kernel to optimize Ethernet performance, supporting high performance TCP and NFS in a data center.">
		<meta property="fb:admins" content="bob.cromwell.10">
				<meta property="fb:app_id" content="9869919170">
		<meta property="og:type" content="website">
		<meta property="og:url" content="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html">
		<meta property="og:site_name" content="Bob Cromwell: Travel, Linux, Cybersecurity">
		<meta name="twitter:url" content="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html">
		<meta name="twitter:card" content="summary_large_image">
                <meta name="twitter:creator" content="@ToiletGuru">

		<!-- Google Page-level ads for mobile -->
		<!-- Note: only need the adsbygoogle.js script this
			one time in the header, not in every ad -->
		<script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/googlesyndication_adsbygoogle.js"></script>
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
		<meta itemprop="headline" content="Ethernet — Performance Tuning on Linux">
		<meta itemprop="datePublished" content="2022-10-01">
		<meta itemprop="dateModified" content="2022-10-01">
		<meta itemprop="mainEntityOfPage" content="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html">
	<!-- end of schema.org microdata -->
		<meta itemprop="about" content="Linux">
		<meta itemprop="about" content="performance tuning">
		<meta itemprop="about" content="networking">
		<meta itemprop="about" content="Ethernet">
		<header>
		<div>
		<img src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/servers-083052-banner.jpg" alt="Linux servers.">
		</div>
		<h1>Performance Tuning on Linux — Ethernet</h1>
		<div class="centered top-banner">
<ins class="adsbygoogle top-banner" style="display:inline-block; width:100%;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
		</header>

		<section>
		<h2 class="centered">
			Tune Ethernet Performance </h2>

		<h2> Capacity Planning </h2>

		<p>
		<strong>You are considering upgrading to 10 Gbps Ethernet, but:</strong>
		Does the motherboard and its system bus have the speed to
		fill a 10 Gbps network?
		You are probably communicating file system data,
		can your disk and file system I/O keep up?
		</p>

		<p>
		The switch backplane needs bandwidth equal to
		2 times the number of ports times the speed.
		A switch with 20 ports running at 10 Gbps full-duplex needs a
		20×2×10&nbsp;=&nbsp;400 Gbps
		bus backplane to be non-blocking.
		</p>

		<h3> Bonding, or Not </h3>

		<p>
		You can bond multiple Ethernet adapters together and
		<em>potentially</em> multiply your throughput.
		However...
		</p>

		<a href="https://www.kernel.org/doc/Documentation/networking/bonding.txt" class="fr btn btn-danger btn-sm">
			Kernel <br>
			documentation <br>
			on bonding</a>

		<p>
		You have a choice of several bonding algorithms, see
		<a href="https://www.kernel.org/doc/Documentation/networking/bonding.txt">here</a>
		for details.
		However, all of them will send all packets of a flow of
		data between two endpoints through the same interface.
		<em>Bonding will <strong>not</strong> increase the
			throughput between a pair of hosts, as each host
			will use just one physical interface to send
			every frame to the other host.</em>
		</p>

		<p>
		Bonding is only helpful <em><strong>if</strong></em> your
		data flow topology looks more like a star
		or a fairly complete mesh.
		For example, a file server with several concurrent clients.
		</p>

		<p>
		<em>If</em> you have the appropriate data flow patterns,
		then bonding multiple 1 Gbps adapters makes sense
		compared to the price of upgrading to 10 Gbps hardware.
		</p>

		<p>
		Bonding multiple 10 Gbps adapters gets expensive quickly,
		and the CPU is already awfully busy working to keep just
		the one 10 Gbps link filled.
		</p>

		<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_1" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame1"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

		</section>
		<section>
		<h2> Measure Recent and Current Utilization </h2>

		<p>
		Get link-layer statistics for all interfaces:
		</p>

		<pre># ip -s link
[...]
1: enp0s1: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc fq_codel state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 00:11:95:1e:8e:b6 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    8028989029 31573824 0       0       0       0       
    TX: bytes  packets  errors  dropped carrier collsns 
    3272273796 15088848 0       0       0       0
[...] </pre>

		<table class="bordered" style="max-width:45em;">
			<tbody><tr class="centered">
				<td> <strong>Field</strong> </td>
				<td> <strong>Meaning of Non-Zero Values</strong> </td>
			</tr>

			<tr>
				<td><code>errors</code></td>
				<td> Poorly or incorrectly negotiated mode and
					speed, or damaged network cable. </td>
			</tr>

			<tr>
				<td><code style="white-space:nowrap;">dropped</code></td>
				<td> Possibly due to <code>iptables</code>
					or other filtering rules, more likely
					due to lack of network buffer memory. </td>
			</tr>

			<tr>
				<td><code style="white-space:nowrap;">overrun</code></td>
				<td> Number of times the network interface
					ran out of buffer space. </td>
			</tr>

			<tr>
				<td><code style="white-space:nowrap;">carrier</code></td>
				<td> Damaged or poorly connected network cable,
					or switch problems.  </td>
			</tr>

			<tr>
				<td><code style="white-space:nowrap;">collsns</code></td>
				<td> Number of collisions, which should always
					be zero on a switched LAN.
					Non-zero indicates problems negotiating
					appropriate duplex mode.
					A small number that never grows means
					it happened when the interface came up
					but hasn't happened since.  </td>
			</tr>

		</tbody></table>

		<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_2" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame2"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

		</section>
		<section>
		<h2> Enable Jumbo Frames </h2>

		<p>
		The example of <em>protocol overhead</em> came up back on the
		<a href="https://cromwell-intl.com/open-source/performance-tuning/">introductory page</a>.
		Every Ethernet frame needs a standard header.
		Due to design optimization decisions made years ago,
		the default MTU or maximum Ethernet frame length allows for
		1500 bytes of payload.
		The maximum frame length limits latency, the amount of time
		a host has to wait to transmit their packet,
		but that limit of 1500 bytes of payload plus header and CRC
		was specified when Ethernet ran at 10 Mbps.
		With 1,000 times the speed, the frames could be much longer
		in bytes and still have far lower latency.
		Also, the CPU would be interrupted less often.
		</p>
		<p>
		A <strong>jumbo frame</strong> is an Ethernet frame
		with more than 1500 bytes of payload.
		A 9000-byte MTU reduces the protocol overhead and
		CPU interrupts by a factor of six.
		Much modern Ethernet equipment can support frames up to
		9,216 bytes,
		<em><strong>but make sure to verify that every device on
				the LAN supports your desired jumbo frame size
				before making any changes.</strong></em>
		</p>

		<p>
		Set this interactively with the <code>ip</code> command:
		</p>

		<pre># ip link set enp0s2 mtu 9000 </pre>

		<p>
		Make the setting persistent by adding <code>MTU=9000</code>
		to <code>/etc/sysconfig/network-scripts/ifcfg-enp0s2</code>.
		</p>

		<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_3" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame3"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

		</section>
		<section>
		<h2> Performance Tuning With <code>ethtool</code> </h2>

		<p>
		Be aware that interface names have changed, it's no longer
		<code>eth0</code>,
		<code>eth1</code>,
		and so on, but names that encode physical location like
		<code>enp0s2</code>.
		<a href="https://cromwell-intl.com/networking/commands.html">
			Details on network interface names</a>
			can be found
		<a href="https://cromwell-intl.com/networking/commands.html">
			here</a>.
		</p>

		<p>
		Not every option will supported on a given network interface,
		and even if its chipset supports something it's possible that
		the current Linux driver doesn't.
		So, don't expect all of the following to work on your system:
		</p>

		<h3> Using <code>ethtool</code> </h3>

		<p>
		Get current settings including speed and duplex mode and
		whether a link beat signal is detected,
		get driver information,
		and get statistics:
		</p>

		<pre># ethtool enp0s2
# ethtool -i enp0s2
# ethtool -S enp0s2 </pre>

		<p class="fr caption" style="max-width: 310px; padding: 3px;">
		With most of these options, lower-case options query
		and display current settings,
		upper-case options change settings.
		For help: <code>ethtool&nbsp;-h</code>
		</p>

		<h4>Interrupt Coalesce</h4>

		<p>
		Several packets in a rapid sequence can be coalesced into
		one interrupt passed up to the CPU,
		providing more CPU time for application processing.
		</p>

		<pre style="clear: right;"># ethtool -c enp0s2 </pre>

		<h4>Ring Buffer</h4>

		<p>
		The ring buffer is another name for the driver queue.
		Get the maximum receive and transmit buffer lengths and
		their current settings.
		<code>RX</code> and <code>TX</code> report the number of
		frames in the buffer, the buffer contains pointers to
		frame data structures.
		Change the settings to the maximum to optimize for throughput
		while possibly increasing latency.
		On a busy system the CPU will have fewer opportunities to
		add packets to the queue, increasing the likelihood that
		the hardware will drain the buffer before more packets
		can be queued.
		</p>

		<pre># ethtool -g enp0s2
Ring parameters for enp0s2:
Pre-set maximums:
RX:             4096
RX Mini:        0
RX Jumbo:       0
TX:             4096
Current hardware settings:
RX:             512
RX Mini:        0
RX Jumbo:       0
TX:             512
# ethtool -G enp0s2 rx 4096 tx 4096
# ethtool -g enp0s2
Ring parameters for enp0s2:
Pre-set maximums:
RX:             4096
RX Mini:        0
RX Jumbo:       0
TX:             4096
Current hardware settings:
RX:             4096
RX Mini:        0
RX Jumbo:       0
TX:             4096 </pre>

		<!--	TO DO: show support for jumbo frames here,
			show how to turn them on. -->

		<p>
		<strong>Beware: This is appropriate for servers on high-speed
			LANs, <em>not</em> for personal systems with
			lower-speed connections.</strong>
		Let's say you have 256 packets of buffer.
		At 1,500 bytes each that's 384,000 bytes or 3,072.000 bits.
		Over a 1 Mbps WLAN or ISP connection, that's over 3 seconds
		of latency.
		It would be six times worse with 9,000 byte jumbo frames.
		</p>

		<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_4" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame4"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

		<h4>Flow Control</h4>

		<p>
		Turn on flow control, allowing the host and the switch to
		pace their transmission based on current receive capability
		at the other end.
		This will reduce packet loss and it may provide a significant
		improvement on high-speed networks.
		</p>

		<pre># ethtool -A enp0s2 rx on
# ethtool -A enp0s2 tx on </pre>

		<h4>Processing Offload</h4>

		<p>
		Offload all possible processing from kernel software into
		hardware.
		</p>

		<pre># ethtool -k enp0s2
# ethtool -K tx-checksum-ipv4 on
# ethtool -K tx-checksum-ipv6 on </pre>

		<h4>Segmentation Offload: TSO, USO, LSO, GSO</h4>

		<p>
		It may be possible to offload TCP segmentation.
		The kernel gives a large segment, maybe 64 kbytes,
		to the NIC.
		There is some intelligence in the NIC to use a template
		from the kernel's TCP/IP stack to segment the data and
		add the TCP, UDP, IP, and Ethernet headers.
		This appears under multiple names:
		TSO or TCP Segmentation Offload,
		USO or UDP Segmentation Offload,
		LSO or Large Segment Offload,
		GSO or Generic Segmentation Offload.
		It would be done with <code>ethtool&nbsp;-k</code>.
		<strong>Beware: segmentation offload should improve performance
			across a high speed LAN, but it is likely to hurt
			performance across a multi-hop WAN path.</strong>
		For more details see:<br>
		<a href="https://en.wikipedia.org/wiki/Large_segment_offload" class="btn btn-info">
			Description of LSO</a>
		<a href="http://www.linuxfoundation.org/collaborate/workgroups/networking/gso" class="btn btn-info">
			Linux Foundation on GSO</a>
		<a href="http://kb.pert.geant.net/PERTKB/PerformanceCaseStudies" class="btn btn-info">
			Performance Case Studies</a>
		<a href="http://kb.pert.geant.net/PERTKB/LargeSendOffloadLSO" class="btn btn-info">
			Issues with LSO</a>
		</p>

		<h4 id="bufferbloat"> Bufferbloat </h4>

		<p>
		There has been a general trend toward larger and larger
		buffers at many places in protocol stacks across the Internet,
		hurting both latency and throughput.
		As Vint Cerf put it,
		<em>"The key issue we've been talking about is that all this
			excessive buffering ends up breaking many of the
			timeout mechanisms built into our network protocols."</em>
		See these articles for background: <br>
		<a href="http://cacm.acm.org/magazines/2012/1/144810-bufferbloat/fulltext" class="btn btn-info">
			"Bufferbloat: Dark Buffers in the Internet"<br>
			CACM Vol 55 No 1 pp 57-65</a>
		<a href="http://cacm.acm.org/magazines/2012/2/145415-bufferbloat-whats-wrong-with-the-internet/fulltext" class="btn btn-info">
			"BufferBloat: What's Wrong With the Internet?"<br>
			CACM Vol 55 No 2 pp 40-47</a>
		<a href="https://queue.acm.org/detail.cfm?id=2209336" class="btn btn-info">
			"Controlling Queue Delay"<br>
			ACM Queue Vol 10 No 5</a>
		</p>
		<p>
		The Byte Queue Limits or BQL algorithm has been added
		to deal with this.
		Kernel data structures in
		<code>/sys/class/net/<em>interface</em>/queues/tx-0/byte_queue_limits/</code>
		control this.
		It's self tuning, you probably don't want to mess with this,
		but to improve latency on low speed nets you might put a
		smaller value in <code>limit_max</code>.
		</p>

		<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_5" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame5"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

		</section>
		<section>
		<h3> Making <code>ethtool</code> Settings Permanent </h3>

		<p>
		You could simply put the appropriate sequence of
		<code>ethtool</code> commands into
		<code>/etc/rc.d/rc.local</code>.
		That is my preferred method, the actual commands appear there
		in order and I can insert comments before each one to explain
		what it's doing and why.
		</p>
		<p>
		With the boot scripts you find on Red Hat, you <em>could</em>
		list them in the interface configuration file.
		It's used as a shell script, so we can built the string
		a piece at a time instead of one monster line.
		</p>

		<pre># cat /etc/sysconfig/network-scripts/ifcfg-enp0s2
DEVICE=enp0s2
BOOTPROTO=static
IPADDR=10.1.1.100
NETMASK=255.255.255.0
<span class="highlighter">ETHTOOL_OPTS="-s enp0s2 speed 1000 duplex full autoneg off</span>
<span class="highlighter">ETHTOOL_OPTS="$ETHTOOL_OPTS ; -K enp0s2 tx off rx off"</span>
<span class="highlighter">ETHTOOL_OPTS="$ETHTOOL_OPTS ; -G enp0s2 rx 4096 tx 4096"</span> </pre>

		</section>
		<section>
		<h2> Kernel Parameters for Core Networking </h2>

		<p>
		The "core" networking parameters for the kernel
		are accessible in <code>/proc/sys/net/core/*</code>.
		</p>

		<p>
		A single input packet queue length is set in
		<code>/proc/sys/net/core/netdev_max_backlog</code>.
		That queue length is per core.
		Increase it to reduce the number of packets dropped
		during high inbound network loads.
		Output queues are set individually for each interface
		with the <code>ip</code> command.
		</p>

		<p>
		First, do the math and consider that this will be a tradeoff
		increasing total throughput while increasing latency.
		Let's say you have one 1000 Mbps interface, you are using
		the default 1500 byte maximum packet size, and you decide
		that 0.1 second of latency would be acceptable:
		</p>
		<p>
		1000 Mbps = 125,000,000 bytes/s <br>
		125,000,000 bytes/second / 1500 bytes/frame = 83,333 frames/second <br>
		83,333 frames/second × 0.1 second = 8,333 frames <br>
		maximum queue of 8,333 1500-byte frames
		</p>

		<pre style="clear: both;"># echo 8333 &gt; /proc/sys/net/core/netdev_max_backlog
# ip link set enp0s2 txqueuelen 8333 </pre>

		<p>
		If you have upgraded to 10 Gbps and 9000-byte jumbo frames:
		</p>
		<p>
		10,000 Mbps = 1,250,000,000 bytes/s <br>
		1,250,000,000 bytes/second / 9000 bytes/frame = 138,888 frames/second <br>
		138,888 frames/second × 0.1 second = 13,888 frames <br>
		maximum queue of 13,888 9000-byte frames
		</p>

		<pre># echo 13888 &gt; /proc/sys/net/core/netdev_max_backlog
# ip link set enp0s2 txqueuelen 13888 </pre>

		<p>
		<strong>However,</strong> as discussed
		<a href="http://www.coverfire.com/articles/queueing-in-the-linux-network-stack/">here</a>,
		it seems that the interface-specific value is only used
		as a default queue length for <em>some</em> of
		the available queue disciplines (or QDiscs) that can be
		manipulated with
		<a href="http://www.lartc.org/howto/">
			Linux Advanced Routing and Traffic Control</a>
		and the <code>tc</code> command.
		</p>

		<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_6" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame6"></iframe></iframe></ins>
<script>
	(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

		</section>
		<section>
		<h3> Making Kernel Parameter Tuning Permanent </h3>

		<p>
		The kernel value <code>netdev_max_backlog</code>
		could be set in a file like
		<code>/etc/sysctl.d/02-netIO.conf</code>,
		while the <code>ip&nbsp;link</code> command(s)
		would go in <code>/etc/rc.d/rc.local</code>.
		</p>
		<p>
		On Red Hat derived systems you can create a script
		<code>/sbin/ifup-local</code> which will be executed
		as interfaces are brought up.<br>
		Positive: Runs automatically and no need
		to re-run <code>rc.local</code>.<br>
		Negative: Specific to Red Hat.
		</p>

		<p>
		Any parameters to pass to the module at load time go into
		a file <code>/etc/modprobe.d/*.conf</code>, based on the
		output of <code>modinfo</code> for that module and a
		careful reading of
		<code>/usr/src/linux/Documentation/networking/<em>drivername</em>.txt</code>
		and/or the source code.
		Some parameter values will be Boolean 0 versus 1,
		some will be numbers, some will be strings.
		</p>

		<pre># cat /etc/modprobe.d/01-ethernet.conf
options dl2k jumbo=1 mtu=9000 tx_flow=1 rx_flow=1 rx_coalesce=100 tx_coalesce=40 </pre>

		<h2> And next... </h2>

		<p>
		For more see this <em>Linux Journal</em> article:
		<a href="http://www.coverfire.com/articles/queueing-in-the-linux-network-stack/" class="btn btn-info">
			Queueing in the Linux Network Stack</a>
		</p>

		<p>
		There is nothing about IP to tune for performance,
		although some security improvements are discussed
		<a href="https://cromwell-intl.com/cybersecurity/stack-hardening.html">here</a>.
		<strong>The next step up the protocol stack is to
			<a href="https://cromwell-intl.com/open-source/performance-tuning/tcp.html">
				tune TCP performance</a>.</strong>
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
			<a href="https://cromwell-intl.com/open-source/performance-tuning/tcp.html" class="btn btn-lg btn-success btn-block">
				<strong>Next:</strong>
				<strong>TCP tuning</strong><br>
				Memory management,
				TCP options,
				initial window sizes
				</a>
			</div>

			<div class="col-12 col-md-4">
			<a href="https://cromwell-intl.com/open-source/performance-tuning/nfs.html" class="btn btn-lg btn-info btn-block">
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
<div id="amzn-assoc-ad-ef2fcc8e-0ac6-4a12-8f2b-bfcaa5e8eb58"></div><script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs_002"></script><!-- end Amazon related ads -->

<!-- Amazon oneTag script -->
<script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs"></script>

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
<a href="https://validator.w3.org/nu/?showsource=yes&amp;doc=https://cromwell-intl.com/open-source/performance-tuning/ethernet.html"><img src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/html5-badge-h-css3-semantics.png" alt="Valid HTML 5.  Validate it here." loading="lazy" style="padding: 0; margin: 0;"></a>
<br>
<a href="https://jigsaw.w3.org/css-validator/check/referer">
<img src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/valid-css.png" alt="Valid CSS.  Validate it here." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:12%;">
<a href="https://www.unicode.org/">
<img src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/unicode.png" alt="Valid Unicode." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://nginx.org/">
<img src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nginx_logo-70pc.png" alt="Nginx" loading="lazy"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://www.freebsd.org/">
<img src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/powerlogo.gif" alt="FreeBSD" loading="lazy"></a>
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
<script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/modernizr.min.js" integrity="sha512-3n19xznO0ubPpSwYCRRBgHh63DrV+bdZfHK52b1esvId4GsfwStQNPJFjeQos2h3JwCmZl0/LgLxSKMAI55hgw==" crossorigin="anonymous"></script>
<script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/jquery-3.6.1.slim.min.js" integrity="sha384-MYL22lstpGhSa4+udJSGro5I+VfM13fdJfCbAzP9krCEoK5r2EDFdgTg2+DGXdj+" crossorigin="anonymous"></script>
<script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


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
 <script>   var infolinks_pid = 3267443;   var infolinks_wsid = 0; </script> <script async="" src="Ethernet%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/infolinks_main.js"></script>
<!-- end of footer.html -->
	

</body></html>formance/tcp_performance.md)
- 