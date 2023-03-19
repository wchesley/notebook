# RAM and Disk Storage

Copied from: https://cromwell-intl.com/open-source/performance-tuning/hardware.html

<!DOCTYPE html>
<html xml:lang="en" class=" js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="UTF-8">
<title>Storage Hardware Selection — Performance Tuning on Linux</title>
<meta name="description" content="How to select appropriate RAM, disk controllers, and disk drives for better Linux system performance.">
<!-- start of standard header -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- style -->
<link rel="stylesheet" href="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.css">
<link rel="stylesheet" href="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/style.css">

<link rel="icon" type="image/png" href="https://cromwell-intl.com/pictures/favicon.png">
<!-- Safari -->
<link rel="apple-touch-icon" href="https://cromwell-intl.com/pictures/touch-icon-iphone-152x152.png">

<!-- Facebook, Twitter -->
<link rel="canonical" href="https://cromwell-intl.com/open-source/performance-tuning/hardware.html">
<meta property="og:title" content="Storage Hardware Selection — Performance Tuning on Linux">
<meta name="twitter:title" content="Storage Hardware Selection — Performance Tuning on Linux">
<meta name="twitter:description" content="How to select appropriate RAM, disk controllers, and disk drives for better Linux system performance.">
<meta property="og:description" content="How to select appropriate RAM, disk controllers, and disk drives for better Linux system performance.">
<meta property="fb:admins" content="bob.cromwell.10">
<meta property="fb:app_id" content="9869919170">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cromwell-intl.com/open-source/performance-tuning/hardware.html">
<meta property="og:site_name" content="Bob Cromwell: Travel, Linux, Cybersecurity">
<meta name="twitter:url" content="https://cromwell-intl.com/open-source/performance-tuning/hardware.html">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:creator" content="@ToiletGuru">

<!-- Google Page-level ads for mobile -->
<!-- Note: only need the adsbygoogle.js script this
one time in the header, not in every ad -->
<script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/googlesyndication_adsbygoogle.js"></script>
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
<meta name="twitter:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083148.jpg">
<meta property="og:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083148.jpg">
</head>

<body>
<article itemscope="" itemtype="http://schema.org/Article" class="container-fluid">
<!-- start of schema.org microdata included in all pages -->
<span itemprop="image" itemscope="" itemtype="https://schema.org/imageObject">
<meta itemprop="url" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083148.jpg">
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
<meta itemprop="headline" content="Storage Hardware Selection — Performance Tuning on Linux">
<meta itemprop="datePublished" content="2022-10-01">
<meta itemprop="dateModified" content="2022-10-01">
<meta itemprop="mainEntityOfPage" content="https://cromwell-intl.com/open-source/performance-tuning/hardware.html">
<!-- end of schema.org microdata -->
<meta itemprop="about" content="Linux">
<meta itemprop="about" content="performance tuning">
<header>
<div>
<img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/servers-083148-banner.jpg" alt="Linux servers.">
</div>
<h1>Performance Tuning on Linux — Storage Hardware</h1>
<div class="centered top-banner">
<ins class="adsbygoogle top-banner" style="display:inline-block; width:100%;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</header>

<section>
<h2 class="centered">
Select Appropriate Hardware </h2>

<p>
<strong>Select the appropriate RAM and disk technology
to have a chance of getting the system performance
you want.</strong>
Solid-state "disks" are much faster than rotating
magnetic disks, but for most of us their cost is still
much too high for the amount of long-term storage we want.
We must have some magnetic disk storage, so we must choose
the controller or interface carefully.
Controllers have much higher potential throughput than
rotating disks can fill on average, but there are still
significant performance advantages to using faster
interfaces.
</p>

</section>
<section>
<h2> Storage I/O Rates </h2>

<p>
<strong>RAM is much faster than rotating magnetic disks.</strong>
DDR SDRAM memory is commonly used in servers, desktops,
and notebook computers.
Let's compare the numbers.
</p>

</section>
<section>
<h3> RAM I/O Speeds </h3>

<p class="fr caption" style="max-width: 160px; margin-left: 2em;">
<strong>DDR SDRAM</strong> =
Double Data Rate Synchronous Dynamic Random-Access Memory
</p>

<p>
DDR memory uses "double pumping" to transfer data on both
the leading and falling edges of the clock signal.
The advantage is that the lower clock frequency reduces the
requirements for signal purity in the circuitry connecting
the memory to the controller.
The disadvantage is the requirement for stricter control
of the timing of clock and data signals.
</p>

<p>
The data transfer is 64 bits or 8 bytes wide,
so DDR SDRAM yields a maximum transfer rate of:
</p>
<p class="centered">
DDR transfer rate =
(memory bus clock) ×
(2 transfers/cycle) ×
(8 bytes/transfer)
</p>

<p>
The original DDR SDRAM, now called DDR1, has been followed
by DDR2, DDR3, and DDR4.
The later generations allow higher bus speeds and can make
more transfers per internal clock cycle, so "DDR" is a
misnomer — it's double for DDR and then doubled again
for each successive generation.
</p>
<p class="centered">
DDR2 transfer rate =
(memory bus clock) ×
(2 clock multiplier) ×
(2 transfers/cycle) ×
(8 bytes/transfer)
</p>
<p class="centered">
DDR3 transfer rate =
(memory bus clock) ×
(4 clock multiplier) ×
(2 transfers/cycle) ×
(8 bytes/transfer)
</p>
<p class="centered">
DDR4 transfer rate =
(memory bus clock) ×
(8 clock multiplier) ×
(2 transfers/cycle) ×
(8 bytes/transfer)
</p>

<table class="bordered centered" style="font-size:0.9rem;">
<tbody><tr>
<td> <strong>Name</strong> </td>
<td> <strong>Memory clock<br>(MHz)</strong> </td>
<td> <strong>I/O bus clock<br>(MHz)</strong> </td>
<td> <strong>Peak transfer rate<br>(MB/sec)</strong> </td>
</tr>

<tr>
<td> DDR-200 </td>
<td class="textright"> 100.0 </td>
<td class="textright"> 100.0 </td>
<td class="textright"> 1,600.0 </td>
</tr>

<tr>
<td> DDR-266 </td>
<td class="textright"> 133.3 </td>
<td class="textright"> 133.3 </td>
<td class="textright"> 2,133.3 </td>
</tr>

<tr>
<td> DDR-333 </td>
<td class="textright"> 166.7 </td>
<td class="textright"> 166.7 </td>
<td class="textright"> 2,666.7 </td>
</tr>

<tr>
<td> DDR-400 </td>
<td class="textright"> 200.0 </td>
<td class="textright"> 200.0 </td>
<td class="textright"> 3,200.0 </td>
</tr>

<tr> <td style="background: #80ff80;" colspan="4"></td> </tr>

<tr>
<td> DDR2-400 </td>
<td class="textright"> 100.0 </td>
<td class="textright"> 200.0 </td>
<td class="textright"> 3,200.0 </td>
</tr>

<tr>
<td> DDR2-533 </td>
<td class="textright"> 133.3 </td>
<td class="textright"> 266.7 </td>
<td class="textright"> 4,266.7 </td>
</tr>

<tr>
<td> DDR2-667 </td>
<td class="textright"> 166.7 </td>
<td class="textright"> 333.3 </td>
<td class="textright"> 5,333.3 </td>
</tr>

<tr>
<td> DDR2-800 </td>
<td class="textright"> 200.0 </td>
<td class="textright"> 400.0 </td>
<td class="textright"> 6,400.0 </td>
</tr>

<tr>
<td> DDR2-1066 </td>
<td class="textright"> 266.7 </td>
<td class="textright"> 533.3 </td>
<td class="textright"> 8,533.3 </td>
</tr>

<tr> <td style="background: #80ff80;" colspan="4"></td> </tr>

<tr>
<td> DDR3-800 </td>
<td class="textright"> 100.0 </td>
<td class="textright"> 400.0 </td>
<td class="textright"> 6400.0 </td>
</tr>

<tr>
<td> DDR3-1066 </td>
<td class="textright"> 133.3 </td>
<td class="textright"> 533.3 </td>
<td class="textright"> 8533.3 </td>
</tr>

<tr>
<td> DDR3-1333 </td>
<td class="textright"> 166.7 </td>
<td class="textright"> 666.7 </td>
<td class="textright"> 10,666.7 </td>
</tr>

<tr>
<td> DDR3-1600 </td>
<td class="textright"> 200.0 </td>
<td class="textright"> 800.0 </td>
<td class="textright"> 12,800.0 </td>
</tr>

<tr>
<td> DDR3-1866 </td>
<td class="textright"> 233.3 </td>
<td class="textright"> 933.3 </td>
<td class="textright"> 14,933.3 </td>
</tr>

<tr>
<td> DDR3-2133 </td>
<td class="textright"> 266.7 </td>
<td class="textright"> 1066.7 </td>
<td class="textright"> 17,066.7 </td>
</tr>

<tr> <td style="background: #80ff80;" colspan="4"></td> </tr>

<tr>
<td> DDR4-1600 </td>
<td class="textright"> 200.0 </td>
<td class="textright"> 800.0 </td>
<td class="textright"> 12,800.0 </td>
</tr>

<tr>
<td> DDR4-1866 </td>
<td class="textright"> 233.3 </td>
<td class="textright"> 933.3 </td>
<td class="textright"> 14,933.3 </td>
</tr>

<tr>
<td> DDR4-2133 </td>
<td class="textright"> 266.7 </td>
<td class="textright"> 1,066.7 </td>
<td class="textright"> 17,066.7 </td>
</tr>

<tr>
<td> DDR4-2400 </td>
<td class="textright"> 300.0 </td>
<td class="textright"> 1,200.0 </td>
<td class="textright"> 19,200.0 </td>
</tr>

<tr>
<td> DDR4-2666 </td>
<td class="textright"> 333.3 </td>
<td class="textright"> 1,333.3 </td>
<td class="textright"> 21,333.3 </td>
</tr>

<tr>
<td> DDR4-2933 </td>
<td class="textright"> 366.7 </td>
<td class="textright"> 1,466.7 </td>
<td class="textright"> 23466.7 </td>
</tr>

<tr>
<td> DDR4-3200 </td>
<td class="textright"> 400.0 </td>
<td class="textright"> 1,600.0 </td>
<td class="textright"> 25,600.0 </td>
</tr>

</tbody></table>

<p>
The different generations are physically incompatible,
a motherboard with DDR3 memory slots can use DDR3 DIMMs
<em>only.</em>
The position of the notch varies with the DDR generation,
see the two sides of the DDR3 modules below.
The signal timing and voltages also differ between the types.
</p>

<div class="centered">
<img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/ddr-sdram-093839.jpg" alt="DDR3 SDRAM, 1333 MHz, 4 GB DIMMs" class="bordered" loading="lazy">
</div>

</section>
<section>
<h3> Disk I/O Rates </h3>

<p>
The IDE (or, eventually, PATA) design dates from 1986.
The first PATA disks only had 16 MB/sec peak transfer rates.
That was doubled and later was further increased to as fast
as 167 MB/sec.
PATA use began to decline with the release of SATA in 2003.
In December 2013 Western Digital was the last manufacturer
to end production of general-purpose PATA disks.
</p>

</section>
<section>
<h4> Disk controllers and interfaces </h4>

<p>
The following table lists maximum theoretical speeds of
various controllers and interfaces.
<strong><em>The storage devices themselves will very likely
not be able to utilize the full bandwidth,
especially not under typical use.</em></strong>
Mechanical disks have a maximum performance of about
180 MB/second.
Solid-state drives can do about 225 MB/second in
sequential reads and writes.
However, controller and bus buffering provide several
significant performance advantages to using connection
technology with speeds higher than the maximum raw disk I/O.
</p>

<p>
Realize that a faster controller must be on an adequately
fast bus.
Interfaces like SATA 2.0 or USB 3.0 must be on a
PCI Express (or PCIe) bus.
</p>

<div class="row centered">

<div class="col-12 col-md-6">

<table class="bordered centered">
<tbody><tr>
<td colspan="4"> <strong>Interface</strong> </td>
<td rowspan="2" style="vertical-align: middle;"> <strong>Peak transfer rate<br>(MB/sec)</strong> </td>
</tr>
<tr>
<td> <strong> ATA </strong> </td>
<td> <strong> SCSI </strong> </td>
<td> <strong> SATA </strong> </td>
<td> <strong> USB </strong> </td>
</tr>

<tr>
<td></td> <td></td> <td></td> <td> 1.1 </td>
<td class="textright"> 1.5 </td>
</tr>

<tr>
<td></td> <td> Fast </td> <td></td> <td></td>
<td class="textright"> 10 </td>
</tr>

<tr>
<td> ATA </td> <td></td> <td></td> <td></td>
<td class="textright"> 16.7 </td>
</tr>

<tr>
<td></td> <td> Ultra </td> <td></td> <td></td>
<td class="textright"> 20 </td>
</tr>

<tr>
<td> UDMA 33 </td> <td></td> <td></td> <td></td>
<td class="textright"> 33 </td>
</tr>

<tr>
<td></td> <td> Ultra Wide </td> <td></td> <td></td>
<td class="textright"> 40 </td>
</tr>

<tr>
<td></td> <td> Ultra-2 </td> <td></td> <td></td>
<td class="textright"> 40 </td>
</tr>

<tr>
<td></td> <td></td> <td></td> <td> 2.0 </td>
<td class="textright"> 60 </td>
</tr>

<tr>
<td> UDMA 66 </td> <td></td> <td></td> <td></td>
<td class="textright"> 66.7 </td>
</tr>

<tr>
<td></td> <td> Ultra-2 Wide </td> <td></td> <td></td>
<td class="textright"> 80 </td>
</tr>

<tr>
<td> UDMA 100 </td> <td></td> <td></td> <td></td>
<td class="textright"> 100 </td>
</tr>

<tr>
<td> UDMA 133 </td> <td></td> <td></td> <td></td>
<td class="textright"> 133 </td>
</tr>

<tr>
<td></td> <td></td> <td> 1.0 </td> <td></td>
<td class="textright"> 150 </td>
</tr>

<tr>
<td></td> <td> Ultra-3 </td> <td></td> <td></td>
<td class="textright"> 160 </td>
</tr>

<tr>
<td> UDMA 167 </td> <td></td> <td></td> <td></td>
<td class="textright"> 167 </td>
</tr>

<tr>
<td></td> <td> SAS </td> <td></td> <td></td>
<td class="textright"> 300 </td>
</tr>

<tr>
<td></td> <td></td> <td> 2.0 </td> <td></td>
<td class="textright"> 300 </td>
</tr>

<tr>
<td></td> <td> Ultra-320 </td> <td></td> <td></td>
<td class="textright"> 320 </td>
</tr>

<tr>
<td></td> <td></td> <td> 3.0 </td> <td></td>
<td class="textright"> 600 </td>
</tr>

<tr>
<td></td> <td></td> <td> 3.1 </td> <td></td>
<td class="textright"> 600 </td>
</tr>

<tr>
<td></td> <td> SAS 2 </td> <td></td> <td></td>
<td class="textright"> 600 </td>
</tr>

<tr>
<td></td> <td></td> <td></td> <td> 3.0 </td>
<td class="textright"> 625 </td>
</tr>

<tr>
<td></td> <td> Ultra-640 </td> <td></td> <td></td>
<td class="textright"> 640 </td>
</tr>

<tr>
<td></td> <td> SAS 3 </td> <td></td> <td></td>
<td class="textright"> 1,200 </td>
</tr>

<tr>
<td></td> <td></td> <td></td> <td> 3.1 </td>
<td class="textright"> 1,250 </td>
</tr>

<tr>
<td></td> <td></td> <td> 3.2 </td> <td></td>
<td class="textright"> 1,969 </td>
</tr>

</tbody></table>

</div>

<div class="col-12 col-md-6">
<div class="centered">
<ins class="adsbygoogle skyscraper" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_1" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame1"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>

</div>

<p>
As for SD and Micro SD cards, the class is the minimum
guaranteed sustained write speed in megabytes per second.
Class 10 SD cards can write at a maximum of 10 MB/second.
</p>

</section>
<section>
<h3> Disk performance measures </h3>

<p>
Rotating disks make us wait for two physical movements.
First the heads must move in or out to the correct track.
Then the disk must rotate the needed sector under the heads.
Unless you are doing something very unusual like making
an image for forensic analysis, disk I/O will be random
because user processes make random use of the file system.
That randomness means that the heads usually have to move.
</p>

<p>
<strong>Seek time</strong> is the time required for the
disk to prepare the read/write apparatus.
For solid-state drives, this is simply the time required
to prepare the circuitry to access a specific address.
</p>
<p>
Rotating mechanical disks force us to wait for the
actuator arm to move the head assembly to the
circular track where the data is to be read or written.
We must also wait for the heads to settle into place
so they do not read or write "off track", but this
<strong>settle time</strong> is typically less than
0.1 millisecond and is included in any measurement of
seek time.
</p>

<table class="bordered centered">
<tbody><tr>
<td style="vertical-align: middle;">
<strong>Technology</strong> </td>
<td style="vertical-align: middle;">
<strong> Average seek time,
milliseconds </strong> </td>
</tr>

<tr>
<td> Solid-state drive </td>
<td class="textright"> 0.08 — 0.16 </td>
</tr>

<tr>
<td> High-performance disk for a server </td>
<td class="textright"> &lt; 4 </td>
</tr>

<tr>
<td> Typical desktop </td>
<td class="textright"> ~ 9 </td>
</tr>

<tr>
<td> Laptop </td>
<td class="textright"> ~ 12 </td>
</tr>

</tbody></table>

<p>
<strong>Rotational latency</strong> is the average time
we must wait for the disk to rotate the needed sector
under the read/write head.
The faster the spindle turns, the shorter this is.
The average rotational latency is a little over 7 milliseconds
for a 4,200 rpm risk,
dropping to 3 milliseconds at 10,000 rpm and
2 milliseconds at 15,000 rpm.
Solid-state drives obviously have zero rotational latency.
</p>

<p>
Combining seek time and rotational latency, we're looking
at averages of about 12 milliseconds on desktops and
5–6 milliseconds on servers,
versus about 0.1 millisecond with solid-state drives.
</p>

<div class="row centered">

<div class="col-12 col-md-6 col-lg-5 col-xl-4 textleft">

<p class="caption" style="max-width: 350px; margin-left: 2em; padding: 3px;">
People write
<a href="https://www.google.com/search?safe=off&amp;q=file+system+access+patterns+filetype:pdf&amp;cad=h">
graduate theses and other technical papers</a>
on the topic of modeling typical user file system access
patterns.
Jonathan Grier's paper
<a href="http://www.grierforensics.com/datatheft/Detecting_Data_Theft_Using_Stochastic_Forensics.pdf">
<em>Detecting Data Theft Using Stochastic Forensics</em></a>
describes how to detect data theft through unusual patterns
of file access.
Someone like Bradley Manning or Ed Snowden copies everything,
but on typical systems about 90% of the files aren't used
over the course of a year.
In
<a href="http://www.networkcomputing.com/networking/-how-digital-forensics-detects-insider-theft/d/d-id/1101804">
an interview</a>
Grier said
<em>"When you look at routine usage, you see a nice graph
— a long-tailed pattern — where you use
a few things, but most things gather dust.
When you copy, you break that pattern.
Because when you copy, you don't cherry-pick,
you just get in and get out.
And that has a uniform pattern,
which is going to look unusual."</em>
</p>

</div>

<div class="col-12 col-md-6 col-lg-7 col-xl-8">
<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_2" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame2"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</div>

</div>

</section>
<section>
<h3> Disk performance trends </h3>

<p>
Disk transfer speed has not kept up with disk storage capacity.
Disks have rapidly grown larger.
Meanwhile the I/O speed has increased
but it has not kept up with the growth in capacity.
The result is storage devices that take longer and longer
to fully read, and writing is even slower.
</p>
<p>
Looking closer at speed, seek time is not growing as fast
as transfer rate.
</p>
<p>
Seek time is related to <em>latency</em> —
how long it takes to start the transfer data.
</p>
<p>
Transfer speed is related to <em>throughput</em> —
how much data per second once it starts moving.
</p>

</section>
<section>
<h2> Performance Versus Power Saving </h2>

<p>
Your disks may support Advanced Power Management, which could
spin down a disk to save power and then require a wait for
it to spin back up.
</p>

<p>
Possible settings are 1 through 254, lower being more power
saving and higher being better performance (with 255 meaning
"disable power management", but not understood by all hardware).
</p>

<p>
Similarly, <code>-M</code> queries and sets the Automatic
Acoustic Management setting, with 254 the loudest and fastest
and 128 and lower quiet and slow.
</p>

<p>
Check with the <code>hdparm</code> command and set it
with similar syntax.
</p>

<pre># for DISK in /dev/sd?
&gt; do
&gt;   hdparm -BM $DISK
&gt; done

# for DISK in /dev/sd?
&gt; do
&gt;   hdparm -B 254 -M 254 $DISK
&gt; done </pre>


</section>
<section>
<h2> LVM is not RAID </h2>

<p>
You may accidentally get a performance boost from striping
across physical volumes in your Logical Volume Management
or LVM, but that is not the point.
<strong>If you need RAID for performance or integrity,
use real RAID.</strong>
</p>
<p>
The point of LVM is to make expansion easy, which is not
needed when you can add more disks to a RAID array.
And even without hardware RAID, the Btrfs file system
will make LVM unnecessary.
</p>

</section>
<section>
<h2> And next... </h2>

<p>
<strong>Next we'll
<a href="https://cromwell-intl.com/open-source/performance-tuning/disks.html">
tune the kernel for I/O</a>
on our selected hardware.</strong>
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/disks.html" class="btn btn-lg btn-success btn-block">
<strong>Next:</strong>
<strong>Disk I/O</strong><br>
Elevator sorting algorithms,
tuning the scheduler,
disk memory management,
measuring disk I/O
</a>
</div>

<div class="col-12 col-md-4">
<a href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html" class="btn btn-lg btn-info btn-block">
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html" class="btn btn-lg btn-info btn-block">
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/tcp.html" class="btn btn-lg btn-info btn-block">
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
<div id="amzn-assoc-ad-ef2fcc8e-0ac6-4a12-8f2b-bfcaa5e8eb58"></div><script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs_002"></script><!-- end Amazon related ads -->

<!-- Amazon oneTag script -->
<script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs"></script>

<!-- Google matched content -->
<p style="font-size:0.8rem; text-align:left; margin:0; padding:2px;">
Now some lurid advertisements from Google AdSense:
</p>
<div class="centered">
<ins class="adsbygoogle" style="display:block;" data-ad-client="ca-pub-5845932372655417" data-ad-slot="9123376601" data-ad-format="autorelaxed"><iframe id="aswift_3" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame3"></iframe></iframe></ins>
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
<a href="https://validator.w3.org/nu/?showsource=yes&amp;doc=https://cromwell-intl.com/open-source/performance-tuning/hardware.html"><img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/html5-badge-h-css3-semantics.png" alt="Valid HTML 5.  Validate it here." loading="lazy" style="padding: 0; margin: 0;"></a>
<br>
<a href="https://jigsaw.w3.org/css-validator/check/referer">
<img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/valid-css.png" alt="Valid CSS.  Validate it here." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:12%;">
<a href="https://www.unicode.org/">
<img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/unicode.png" alt="Valid Unicode." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://nginx.org/">
<img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nginx_logo-70pc.png" alt="Nginx" loading="lazy"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://www.freebsd.org/">
<img src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/powerlogo.gif" alt="FreeBSD" loading="lazy"></a>
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
<script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/modernizr.min.js" integrity="sha512-3n19xznO0ubPpSwYCRRBgHh63DrV+bdZfHK52b1esvId4GsfwStQNPJFjeQos2h3JwCmZl0/LgLxSKMAI55hgw==" crossorigin="anonymous"></script>
<script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/jquery-3.6.1.slim.min.js" integrity="sha384-MYL22lstpGhSa4+udJSGro5I+VfM13fdJfCbAzP9krCEoK5r2EDFdgTg2+DGXdj+" crossorigin="anonymous"></script>
<script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


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
<script>   var infolinks_pid = 3267443;   var infolinks_wsid = 0; </script> <script async="" src="Storage%20Hardware%20Selection%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/infolinks_main.js"></script>
<!-- end of footer.html -->


</body></html>