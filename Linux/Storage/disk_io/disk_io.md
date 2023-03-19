# Disk IO

Copied from: https://cromwell-intl.com/open-source/performance-tuning/disks.html


<!DOCTYPE html>
<html xml:lang="en" class=" js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="UTF-8">
<title>Disk I/O — Performance Tuning on Linux</title>
<meta name="description" content="How to optimize the Linux kernel disk I/O performance with queue algorithm selection, memory management and cache tuning.">
<!-- start of standard header -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- style -->
<link rel="stylesheet" href="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.css">
<link rel="stylesheet" href="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/style.css">

<link rel="icon" type="image/png" href="https://cromwell-intl.com/pictures/favicon.png">
<!-- Safari -->
<link rel="apple-touch-icon" href="https://cromwell-intl.com/pictures/touch-icon-iphone-152x152.png">

<!-- Facebook, Twitter -->
<link rel="canonical" href="https://cromwell-intl.com/open-source/performance-tuning/disks.html">
<meta property="og:title" content="Disk I/O — Performance Tuning on Linux">
<meta name="twitter:title" content="Disk I/O — Performance Tuning on Linux">
<meta name="twitter:description" content="How to optimize the Linux kernel disk I/O performance with queue algorithm selection, memory management and cache tuning.">
<meta property="og:description" content="How to optimize the Linux kernel disk I/O performance with queue algorithm selection, memory management and cache tuning.">
<meta property="fb:admins" content="bob.cromwell.10">
<meta property="fb:app_id" content="9869919170">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cromwell-intl.com/open-source/performance-tuning/disks.html">
<meta property="og:site_name" content="Bob Cromwell: Travel, Linux, Cybersecurity">
<meta name="twitter:url" content="https://cromwell-intl.com/open-source/performance-tuning/disks.html">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:creator" content="@ToiletGuru">

<!-- Google Page-level ads for mobile -->
<!-- Note: only need the adsbygoogle.js script this
one time in the header, not in every ad -->
<script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/googlesyndication_adsbygoogle.js"></script>
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
<meta name="twitter:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083040.jpg">
<meta property="og:image" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083040.jpg">
</head>

<body>
<article itemscope="" itemtype="http://schema.org/Article" class="container-fluid">
<!-- start of schema.org microdata included in all pages -->
<span itemprop="image" itemscope="" itemtype="https://schema.org/imageObject">
<meta itemprop="url" content="https://cromwell-intl.com/open-source/pictures/servers-20151014_083040.jpg">
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
<meta itemprop="headline" content="Disk I/O — Performance Tuning on Linux">
<meta itemprop="datePublished" content="2022-10-01">
<meta itemprop="dateModified" content="2022-10-01">
<meta itemprop="mainEntityOfPage" content="https://cromwell-intl.com/open-source/performance-tuning/disks.html">
<!-- end of schema.org microdata -->
<meta itemprop="about" content="Linux">
<meta itemprop="about" content="performance tuning">
<meta itemprop="about" content="file systems">
<meta itemprop="about" content="disk I/O">
<header>
<div>
<img src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/servers-083040-banner.jpg" alt="Storage array.">
</div>
<h1>Performance Tuning on Linux — Disk I/O</h1>
<div class="centered top-banner">
<ins class="adsbygoogle top-banner" style="display:inline-block; width:100%;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</header>

<section>
<h2 class="centered">
Tune Disk I/O </h2>

<p>
<strong>Disks are <em>block</em> devices and we can
access related kernel data structures through
<a href="https://cromwell-intl.com/open-source/sysfs.html">Sysfs</a>.</strong>
We can use the kernel data structures under <code>/sys</code>
to select and tune I/O queuing algorithms for the block
devices.
"Block" and "character" are misleading names for device types. 
The important distinction is that unbuffered "character"
devices provide direct access to the device,
while buffered "block" devices are accessed through
a buffer which can greatly improve performance.
Contradicting their common names,
"character" devices can enforce block boundaries, and you
can read or write "block" devices in blocks of any size
including one byte at a time.
</p>

<p>
The operating system uses RAM for both <em>write buffer</em>
and <em>read cache.</em>
The idea is that data to be stored is written into the
write buffer, where it can be sorted or grouped.
A mechanical disk needs its data sorted into order so
a sequence of write operations can happen as the arm moves
in one direction across the platter, instead of
seeking back and forth and greatly increasing overall time.
If the storage system is RAID, then the data should be
grouped by RAID stripe so that one stripe can be written in
one operation.
</p>

<p>
As for reading, recently-read file system data is stored in RAM.
If the blocks are "clean", unmodified since the last read,
then the data can be read directly from cache RAM instead of
accessing the much slower mechanical disks.
Reading is made more efficient by appropriate decisions
about which blocks to store and which to discard.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_1" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame1"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> Disk Queuing Algorithms </h2>

<p>
Pending I/O events are scheduled or sorted by
a queuing algorithm also called an <em>elevator</em>
because analogous algorithms can be used
to most efficiently schedule elevators.
There is no single best algorithm, the choice depends
some on your hardware and more on the work load.
</p>
<p>
Tuning is done by disk, not by partition,
so if your first disk has partitions containing
<code>/</code>,
<code>/boot</code>, and
<code>/boot/efi</code>,
all three file systems must be handled the same way.
Since things under <code>/boot</code> are needed only
infrequently after booting, if ever, then consider your
use of your root partition to select an algorithm
for all of <code>/dev/sda</code>.
This foreshadows the coming file system discussion where
we want to limit the I/O per physical device.
</p>

<p>
Tuning is done with the kernel object
<code>/sys/block/sd*/queue/scheduler</code>.
You can read its current contents with <code>cat</code>
or similar.
The output lists all queuing algorithms supported by the kernel.
The one currently in use is surrounded by square brackets.
</p>

<pre># grep . /sys/block/sd*/queue/scheduler
/sys/block/sda/queue/scheduler:noop deadline [cfq] 
/sys/block/sdb/queue/scheduler:noop deadline [cfq] 
/sys/block/sdc/queue/scheduler:noop deadline [cfq] 
/sys/block/sdd/queue/scheduler:noop deadline [cfq] </pre>

<p>
You can modify the kernel object contents
and change the algorithm with <code>echo</code>.
</p>

<pre># cat /sys/block/sdd/queue/scheduler 
noop deadline [cfq] 
# echo deadline &gt; /sys/block/sdd/queue/scheduler 
# cat /sys/block/sdd/queue/scheduler 
noop [deadline] cfq
</pre>

<p class="caption fr" style="max-width: 160px; margin-left: 2em;">
If you're looking for information on the Anticipatory I/O
scheduler, you are using some old references.
<a href="http://www.linux-mag.com/id/7724/">
It was removed</a>
from the 2.6.33 kernel.
</p>

<p>
<strong>The shortest explanation: Use Deadline
for interactive systems and
NOOP for unattended computation.</strong>
But read on for details on why, and other parameters to tune.
</p>

</section>
<section>
<h3> Deadline Scheduler </h3>

<p>
The <strong>deadline</strong> algorithm attempts to limit
the maximum latency and keep the humans happy.
Every I/O request is assigned its own deadline and
it should be completed before that timer expires.
</p>
<p>
Two queues are maintained per device, one sorted by
sector and the other by deadline.
As long as no deadlines are expiring, the I/O requests
are done in sector order to minimize head motion and
provide best throughput.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_2" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame2"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

<p>
<strong>Reasons to use the deadline scheduler include:</strong>
</p>
<p>
<strong>1: People use your system interactively.</strong>
Your work load is dominated by interactive
applications, either users who otherwise may
complain of sluggish performance
or databases with many I/O operations.
</p>
<p>
2: Read operations happen significantly more often
than write operations, as applications are more
likely to block waiting to read data.
</p>
<p>
3: Your storage hardware is a SAN (Storage Area Network)
or RAID array with deep I/O buffers.
</p>
<p>
Red Hat uses deadline by default for non-SATA disks
starting at RHEL 7.
IBM System z uses deadline by default for all disks.
</p>

</section>
<section>
<h3> CFQ Scheduler </h3>

<p>
The <strong>CFQ</strong> or Completely Fair Queuing algorithm
first divides processes into the three classes of Real Time,
Best Effort, and Idle.
Real Time processes are served before Best Effort processes,
which in turn are served before Idle processes.
Within each class, the kernel attempts to give every thread
the same number of time slices.
Processes are assigned to the Best Effort class by default,
you can change the I/O priority for a process with
<code>ionice</code>.
The kernel uses recent I/O patterns to anticipate whether
an application will issue more requests in the near future,
and if more I/O is anticipated, the kernel will wait
even though other processes have pending I/O.
</p>
<p>
CFQ can improve throughput at the cost of worse latency.
Users are sensitive to latency and will not like the result
when their applications are bound by CFQ.
</p>
<p>
<strong>Reasons to use the CFQ scheduler:</strong>
</p>
<p>
<strong>1: People do not use your system interactively,
at least not much.</strong>
Throughput is more important than latency,
but latency is still important enough that you
don't want to use NOOP.
</p>
<p>
<strong>2: You are not using XFS.</strong>
<a href="http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E">
According to xfs.org</a>,
the CFQ scheduler defeats much of the parallelization in XFS.
</p>
<p>
Red Hat uses this by default for SATA disks
starting at RHEL 7.
<em>And</em> they use XFS by default...
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_3" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame3"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h3> NOOP Scheduler </h3>

<p>
The <strong>NOOP</strong> scheduler does nothing to change
the order or priority, it simply handles the requests in
the order they were submitted.
</p>
<p>
This can provide the best throughput, especially on storage
subsystems that provide their own queuing such as
solid-state drives, intelligent RAID controllers with their
own buffer and cache, and Storage Area Networks.
</p>
<p>
This usually makes for the worst latency, so it would be
a poor choice for interactive use.
</p>
<p>
<strong>Reasons to use the noop scheduler include:</strong>
</p>
<p>
<strong>1: Throughput is your dominant concern,
you don't care about latency.</strong>
Users don't use the system interactively.
</p>
<p>
<strong>2: Your work load is CPU-bound: most of the time we're
waiting for the CPU to finish something, I/O events are
relatively small and widely spaced.</strong>
</p>
<p>
Both of those suggest that you are doing
high-throughput unattended jobs such as data mining,
scientific high-performance computing, or rendering.
</p>

</section>
<section>
<h3> Tuning the Schedulers </h3>

<p style="margin-bottom: 1px;">
Recall (or <a href="https://cromwell-intl.com/open-source/sysfs.html">learn here</a>)
that Sysfs is the hierarchy under <code>/sys</code> and it
maps internal kernel constructs to a file system so that:
</p>
<ul style="margin-top: 1px;">
<li>
Directories represent kernel objects,
</li>
<li>
Files represent attributes of those objects, and
</li>
<li>
Symbolic links represent relationships (usually
identity) between objects
</li>
</ul>

<p>
Different files (attributes) appear in the
<code>queue/iosched</code> subdirectory (object)
when you change the content (setting)
of the <code>queue/scheduler</code> file (attribute).
It's easier to look at than to explain.
The directories for the disks themselves contain the same
files and subdirectories, including the file
<code>queue/scheduler</code> and the subdirectory
<code>queue/iosched/</code>:
</p>

<pre># ls -F /sys/block/sdb/
alignment_offset  discard_alignment  holders/  removable  stat
bdi@              events             inflight  ro         subsystem@
capability        events_async       power/    sdb1/      trace/
dev               events_poll_msecs  queue/    size       uevent
device@           ext_range          range     slaves/

# ls -F /sys/block/sdb/queue
add_random           max_hw_sectors_kb       optimal_io_size
discard_granularity  max_integrity_segments  physical_block_size
discard_max_bytes    max_sectors_kb          read_ahead_kb
discard_zeroes_data  max_segment_size        rotational
hw_sector_size       max_segments            rq_affinity
iosched/             minimum_io_size         scheduler
iostats              nomerges                write_same_max_bytes
logical_block_size   nr_request </pre>

<p>
Let's assign three different schedulers and see what tunable
parameters appear in their <code>queue/iosched</code>
subdirectories:
</p>

<pre># echo cfq &gt; /sys/block/sdb/queue/scheduler 
# echo deadline &gt; /sys/block/sdc/queue/scheduler 
# echo noop &gt; /sys/block/sdd/queue/scheduler 

# ls -F /sys/block/sd[bcd]/queue/iosched/
/sys/block/sdb/queue/iosched/:
back_seek_max      fifo_expire_sync  quantum         slice_idle
back_seek_penalty  group_idle        slice_async     slice_sync
fifo_expire_async  low_latency       slice_async_rq  target_latency

/sys/block/sdc/queue/iosched/:
fifo_batch  front_merges  read_expire  write_expire  writes_starved

/sys/block/sdd/queue/iosched/: </pre>

<p>
So we see that the cfq scheduler has twelve readable
and tunable parameters,
the deadline scheduler has five,
and the noop scheduler has none (which makes sense
as it's the not-scheduler).
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_4" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame4"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h4> Tuning The CFQ Scheduler </h4>

<p>
Remember that this is for mostly to entirely non-interactive
work where latency is of lower concern.
You care some about latency, but your main concern is
throughput.
</p>

<table class="bordered">
<tbody><tr class="centered">
<td> <strong> Attribute </strong> </td>
<td> <strong> Meaning and suggested tuning </strong> </td>
</tr>

<tr>
<td> <code>fifo_expire_async</code> </td>
<td> Number of milliseconds an asynchronous
request (buffered write) can remain
unserviced.
<br>
<strong>If lowered buffered write
    latency is needed, either
    decrease from default 250 msec
    or consider switching to
    deadline scheduler.</strong>
</td>
</tr>

<tr>
<td> <code>fifo_expire_sync</code> </td>
<td> Number of milliseconds a synchronous
request (read, or O_DIRECT unbuffered
write) can remain unserviced.
<br>
<strong>If lowered read latency
    is needed, either decrease
    from default 125 msec or
    consider switching to
    deadline scheduler.</strong>
</td>
</tr>

<tr>
<td> <code>low_latency</code> </td>
<td>	0=disabled:
Latency is ignored, give each process
a full time slice.
<br>
1=enabled:
Favor fairness over throughput,
enforce a maximum wait time of
300 milliseconds for each process
issuing I/O requests for a device.
<br>
<strong>Select this if using CFQ with
    applications requiring it,
    such as real-time media
    streaming.</strong>
</td>
</tr>

<tr>
<td> <code>quantum</code> </td>
<td> Number of I/O requests sent to a device
at one time, limiting the queue depth.
request (read, or O_DIRECT unbuffered
write) can remain unserviced.
<br>
<strong>Increase this to improve
    throughput on storage hardware
    with its own deep I/O buffer
    such as SAN and RAID,
    at the cost of increased
    latency.</strong>
</td>
</tr>

<tr>
<td> <code>slice_idle</code> </td>
<td> Length of time in milliseconds that cfq
will idle while waiting for further
requests.
<br>
<strong>Set to 0 for solid-state drives
    or for external RAID with its
    own cache.
    Leave at default of 8
    milliseconds for internal
    non-RAID storage to reduce
    seek operations.
    </strong>
</td>
</tr>

</tbody></table>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_5" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame5"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h4> Tuning The Deadline Scheduler </h4>

<p>
Remember that this is for interactive work where latency
above about 100 milliseconds will really bother your users.
Throughput would be nice, but we must keep the latency down.
</p>

<table class="bordered">
<tbody><tr class="centered">
<td> <strong> Attribute </strong> </td>
<td> <strong> Meaning and suggested tuning </strong> </td>
</tr>

<tr>
<td> <code>fifo_batch</code> </td>
<td> Number of read or write operations to
issue in one batch.
<br>
<strong>Lower values may further
    reduce latency.</strong>
<br>
Higher values can increase throughput
on rotating mechanical disks,
but at the cost of worse latency.
<br>
<strong>You selected the deadline
    scheduler to limit latency,
    so you probably don't want to
    increase this, at least not
    by very much.</strong>
</td>
</tr>

<tr>
<td> <code>read_expire</code> </td>
<td> Number of milliseconds within which a
read request should be served.
<br>
<strong>Reduce this from the default
    of 500 to 100 on a system with
    interactive users.</strong>
</td>
</tr>

<tr>
<td> <code>write_expire</code> </td>
<td> Number of milliseconds within which a
write request should be served.
<br>
<strong>Leave at default of 5000, let
    write operations be done
    asynchronously in the background
    unless your specialized application
    uses many synchronous writes.
    </strong>
</td>
</tr>

<tr>
<td> <code>writes_starved</code> </td>
<td> Number read batches that can be processed
before handling a write batch.
<br>
<strong>Increase this from default of 2
    to give higher priority to
    read operations.</strong>
</td>
</tr>

</tbody></table>

</section>
<section>
<h4> Tuning The NOOP Scheduler </h4>

<p>
Remember that this is for entirely non-interactive work where
throughput is all that matters.
Data mining, high-performance computing and rendering,
and CPU-bound systems with fast storage.
</p>
<p>
The whole point is that NOOP <em>isn't</em> a scheduler,
I/O requests are handled strictly first come, first served.
All we can tune are some block layer parameters in
<code>/sys/block/sd*/queue/*</code>, which could also be
tuned for other schedulers, so...
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_6" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame6"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h4> Tuning General Block I/O Parameters </h4>

<p>
These are in <code>/sys/block/sd*/queue/</code>.
</p>

<table class="bordered">
<tbody><tr class="centered">
<td> <strong> Attribute </strong> </td>
<td> <strong> Meaning and suggested tuning </strong> </td>
</tr>

<tr>
<td> <code>max_sectors_kb</code> </td>
<td> Maximum allowed size of an I/O request
in kilobytes, which must be within
these bounds:
<br>
Min value = max(1, <code>logical_block_size</code>/1024)
<br>
Max value = <code>max_hw_sectors_kb</code>
</td>
</tr>

<tr>
<td> <code>nr_requests</code> </td>
<td> Maximum number of read and write requests
that can be queued at one time before
the next process requesting a read or
write is put to sleep.
Default value of 128 means 128 read
requests <em>and</em> 128 write
requests can be queued at once.
<br>
<strong>Larger values may increase
    throughput for workloads
    writing many small files,
    smaller values increase
    throughput with larger
    I/O operations.</strong>
<br>
<strong>You <em>could</em> decrease
    this if you are using
    latency-sensitive applications,
    but then you shouldn't be using
    NOOP if latency is sensitive!</strong>
</td>
</tr>

<tr>
<td> <code>optimal_io_size</code> </td>
<td> If non-zero, the storage device has reported
its own optimal I/O size.
<br>
<strong>If you are developing your
    own applications, make its I/O
    requests in multiples of this
    size if possible.</strong>
</td>
</tr>

<tr>
<td> <code>read_ahead_kb</code> </td>
<td> Number of kilobytes the kernel will read
ahead during a sequential read
operation.
128 kbytes by default, if the disk is
used with LVM the device mapper may
benefit from a higher value.
<br>
<strong>If your workload does a lot
    of large streaming reads,
    larger values may improve
    performance.</strong>
</td>
</tr>

<tr>
<td> <code>rotational</code> </td>
<td> Should be 0 (no) for solid-state disks,
but some do not correctly report
their status to the kernel.
<br>
<strong>If incorrectly set to 1 for
    an SSD, set it to 0 to disable
    unneeded scheduler logic meant
    to reduce number of seeks.</strong>
</td>
</tr>

</tbody></table>

</section>
<section>
<h3> Automatically Tuning the Schedulers </h3>

<p>
Sysfs is an in-memory file system, everything goes back
to the defaults at the next boot.
You could add settings to <code>/etc/rc.d/rc.local</code>:
</p>

<pre>... preceding lines omitted ...

## Added for disk tuning this read-heavy interactive system
for DISK in sda sdb sdc sdd
do
# Select deadline scheduler first
echo deadline &gt; /sys/block/${DISK}/queue/scheduler
# Now set deadline scheduler parameters
echo 100 &gt; /sys/block/${DISK}/queue/iosched/read_expire
echo 4 &gt; /sys/block/${DISK}/queue/iosched/writes_starved
done </pre>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_7" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame7"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>


</section>
<section>
<h2> Tune Virtual Memory Management to Improve I/O Performance </h2>

<p>
This work is done in Procfs, under <code>/proc</code>
and specifically in <code>/proc/sys/vm/*</code>.
You can experiment interactively with <code>echo</code>
and <code>sysctl</code>.
When you have decided on a set of tuning parameters,
create a new file named <code>/etc/sysctl.d/</code>
and enter your settings there.
Leave the file <code>/etc/sysctl.conf</code> with the
distribution's defaults, files you add overwrite those
changes.
</p>
<p>
The new file must be named <code>*.conf</code>, the
recommendation is that its name be two digits, a dash,
a name, and then the required <code>.conf</code>.
So, something like:
</p>

<pre># ls /etc/sysctl*
/etc/sysctl.conf

/etc/sysctl.d:
01-diskIO.conf  02-netIO.conf

# cat /etc/sysctl.d/01-diskIO.conf
vm.dirty_ratio = 6
vm.dirty_background_ratio = 3
vm.vfs_cache_pressure = 50 </pre>

<p>
Now, for the virtual memory data structures we might
constructively manipulate:
</p>

<table class="bordered">
<tbody><tr class="centered">
<td> <strong> Attribute </strong> </td>
<td> <strong> Meaning and suggested tuning </strong> </td>
</tr>

<tr>
<td> <code> dirty_ratio </code> </td>
<td> "Dirty" memory is that waiting to be
written to disk.
<code>dirty_ratio</code> is the number
of memory pages at which a <em>process</em>
will start writing out dirty data,
expressed as a percentage out of the
total free and reclaimable pages.
A default of 20 is reasonable.
<strong>Increase to 40 to improve
    throughput, decrease it to
    5 to 10 to improve latency,
    even lower on systems with
    a lot of memory.</strong>
</td>
</tr>

<tr>
<td> <code> dirty_background_ratio </code> </td>
<td> Similar, but this is the number
of memory pages at which the
<em>kernel background flusher thread</em>
will start writing out dirty data,
expressed as a percentage out of the
total free and reclaimable pages.
Set this lower than <code>dirty_ratio</code>,
<code>dirty_ratio</code>/2 makes sense
and is what the kernel does by default.
<a href="https://sites.google.com/site/sumeetsingh993/home/experiments/dirty-ratio-and-dirty-background-ratio">
    This page</a>
shows that <code>dirty_ratio</code>
has the greater effect.
Tune <code>dirty_ratio</code> for
performance, then set
<code>dirty_background_ratio</code>
to half that value.
</td>
</tr>

<tr>
<td> <code> overcommit_memory </code> </td>
<td> Allows for poorly designed programs which
<code>malloc()</code> huge amounts of
memory "just in case" but never really
use it.
<strong>Set this to 0 (disabled) unless
    you really need it.</strong>
</td>
</tr>

<tr>
<td> <code> vfs_cache_pressure </code> </td>
<td> This sets the "pressure" or the importance
the kernel places upon reclaiming
memory used for caching directory
and inode objects.
The default of 100 or relative "fair"
is appropriate for compute servers.
<strong>Set to lower than 100 for file
    servers on which the cache
    should be a priority.
    Set higher, maybe 500 to 1000,
    for interactive systems.</strong>
</td>
</tr>

</tbody></table>

<p>
There is further information in the
<a href="https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/index.html">
Red Hat Enterprise Linux
Performance Tuning Guide</a>.
</p>

<p>
Also see
<a href="https://www.kernel.org/doc/Documentation/sysctl/vm.txt">
<code>/usr/src/linux/Documentation/sysctl/vm.txt</code></a>.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_8" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame8"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>


</section>
<section>
<h2 id="benchmark"> Measuring Disk I/O </h2>

<p>
Once you have selected and created file systems as
discussed in
<a href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">the next page</a>,
you can have a choice of tools for testing file system I/O.
</p>
<p>
<a href="http://www.textuality.com/bonnie/" class="btn btn-info">
Bonnie</a>
<a href="http://www.coker.com.au/bonnie++/" class="btn btn-info">
Bonnie++</a>
<a href="http://www.iozone.org/" class="btn btn-info">
IOzone benchmark</a>
<a href="http://www.spec.org/sfs2014/" class="btn btn-info">
SPEC SFS 2014</a>
</p>

</section>
<section>
<h2> And next... </h2>

<p>
<strong>The next step is to select appropriate
<a href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">file systems</a>
and their creation and use options.</strong>
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html" class="btn btn-lg btn-success btn-block">
<strong>Next:</strong>
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
<div id="amzn-assoc-ad-ef2fcc8e-0ac6-4a12-8f2b-bfcaa5e8eb58"></div><script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs_002"></script><!-- end Amazon related ads -->

<!-- Amazon oneTag script -->
<script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs"></script>

<!-- Google matched content -->
<p style="font-size:0.8rem; text-align:left; margin:0; padding:2px;">
Now some lurid advertisements from Google AdSense:
</p>
<div class="centered">
<ins class="adsbygoogle" style="display:block;" data-ad-client="ca-pub-5845932372655417" data-ad-slot="9123376601" data-ad-format="autorelaxed"><iframe id="aswift_9" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame9"></iframe></iframe></ins>
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
<a href="https://validator.w3.org/nu/?showsource=yes&amp;doc=https://cromwell-intl.com/open-source/performance-tuning/disks.html"><img src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/html5-badge-h-css3-semantics.png" alt="Valid HTML 5.  Validate it here." loading="lazy" style="padding: 0; margin: 0;"></a>
<br>
<a href="https://jigsaw.w3.org/css-validator/check/referer">
<img src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/valid-css.png" alt="Valid CSS.  Validate it here." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:12%;">
<a href="https://www.unicode.org/">
<img src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/unicode.png" alt="Valid Unicode." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://nginx.org/">
<img src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nginx_logo-70pc.png" alt="Nginx" loading="lazy"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://www.freebsd.org/">
<img src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/powerlogo.gif" alt="FreeBSD" loading="lazy"></a>
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
<script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/modernizr.min.js" integrity="sha512-3n19xznO0ubPpSwYCRRBgHh63DrV+bdZfHK52b1esvId4GsfwStQNPJFjeQos2h3JwCmZl0/LgLxSKMAI55hgw==" crossorigin="anonymous"></script>
<script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/jquery-3.6.1.slim.min.js" integrity="sha384-MYL22lstpGhSa4+udJSGro5I+VfM13fdJfCbAzP9krCEoK5r2EDFdgTg2+DGXdj+" crossorigin="anonymous"></script>
<script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


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
<script>   var infolinks_pid = 3267443;   var infolinks_wsid = 0; </script> <script async="" src="Disk%20I_O%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/infolinks_main.js"></script>
<!-- end of footer.html -->


</body></html>