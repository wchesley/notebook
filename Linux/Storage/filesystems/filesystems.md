# Filesystems

Copied from: https://cromwell-intl.com/open-source/performance-tuning/file-systems.html

<!DOCTYPE html>
<html xml:lang="en" class=" js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="UTF-8">
<title>File Systems — Performance Tuning on Linux</title>
<meta name="description" content="How to optimize Linux file system performance with appropriate file system choice and tuning of its parameters and mount options.">
<!-- start of standard header -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- style -->
<link rel="stylesheet" href="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.css">
<link rel="stylesheet" href="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/style.css">

<link rel="icon" type="image/png" href="https://cromwell-intl.com/pictures/favicon.png">
<!-- Safari -->
<link rel="apple-touch-icon" href="https://cromwell-intl.com/pictures/touch-icon-iphone-152x152.png">

<!-- Facebook, Twitter -->
<link rel="canonical" href="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">
<meta property="og:title" content="File Systems — Performance Tuning on Linux">
<meta name="twitter:title" content="File Systems — Performance Tuning on Linux">
<meta name="twitter:description" content="How to optimize Linux file system performance with appropriate file system choice and tuning of its parameters and mount options.">
<meta property="og:description" content="How to optimize Linux file system performance with appropriate file system choice and tuning of its parameters and mount options.">
<meta property="fb:admins" content="bob.cromwell.10">
<meta property="fb:app_id" content="9869919170">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">
<meta property="og:site_name" content="Bob Cromwell: Travel, Linux, Cybersecurity">
<meta name="twitter:url" content="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:creator" content="@ToiletGuru">

<!-- Google Page-level ads for mobile -->
<!-- Note: only need the adsbygoogle.js script this
one time in the header, not in every ad -->
<script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/googlesyndication_adsbygoogle.js"></script>
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
<meta itemprop="headline" content="File Systems — Performance Tuning on Linux">
<meta itemprop="datePublished" content="2022-10-01">
<meta itemprop="dateModified" content="2022-10-01">
<meta itemprop="mainEntityOfPage" content="https://cromwell-intl.com/open-source/performance-tuning/file-systems.html">
<!-- end of schema.org microdata -->
<meta itemprop="about" content="Linux">
<meta itemprop="about" content="performance tuning">
<meta itemprop="about" content="storage">
<header>
<div>
<img src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/servers-083040-banner.jpg" alt="Linux servers.">
</div>
<h1>Performance Tuning on Linux — File Systems</h1>
<div class="centered top-banner">
<ins class="adsbygoogle top-banner" style="display:inline-block; width:100%;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
</header>

<section>
<h2 class="centered">
Create and Tune File Systems </h2>

<p>
<strong>Divide your overall storage hierarchy across multiple
file systems to improve performance, support better
security choices, and make upgrades and expansions
easier.</strong>
We will see how to do that, properly sizing the volumes
to avoid fragmentation.
Then choose a file system type — Ext4, XFS, or Btrfs,
and make sure to create it with appropriate parameters
and use its journal appropriately.
Then mount the system system with options that can improve
performance.
</p>

<p>
The classic practical study is
<a href="http://www.eecs.harvard.edu/~keith/papers/tr94.ps.gz">
<em>File Layout and File System Performance</em></a>
by Keith Smith and Margo Seltzer at Harvard University.
It's from 1994 and is based on a study of FFS or the
BSD Fast File System, but their measurements are still
appropriate and their analysis relevant.
</p>

</section>
<section>
<h2> Use Multiple File Systems </h2>

<p>
Improve performance through balanced I/O
and security through finer granularity of
file system attributes.
Create independent file systems on separate physical volumes.
</p>

<p>
Use a separate one for <code>/home</code> on a file server
holding user data — create multiple ones for
<code>/home1</code>, <code>/home2</code>, etc., with home
directories symbolically linked from <code>/home</code>
as the number of users and their file I/O increases.
Use a separate one for <code>/var</code> or subdirectories
like <code>/var/www</code> on web servers,
<code>/var/spool</code> on mail and print servers,
and <code>/var/log</code> on centralized log servers,
the last of those possibly even on busy servers
logging lots of data locally.
Create one for <code>/opt</code> if you are using Oracle or
other software that uses that area,
or any other local specialized data stores you need.
Consider making <code>/tmp</code> a separate file system,
but you might make it a RAM-based file system as simply
as making <code>/tmp</code> a symbolic link to
<code>/dev/shm</code>.
</p>

<p>
These separate file systems can be mounted with different
options for security as
<a href="https://cromwell-intl.com/open-source/file-system.html">described here</a>.
</p>

<p>
Multiple file systems can limit integrity loss caused
by a disk crash.
Then it will be time to restore from backup, and both backups
and restores will have been made more efficient with multiple
independent file systems.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_1" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame1"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> Choose a File System Type </h2>

<p>
Current appropriate choices are Ext4 (default in RHEL/CentOS 6),
XFS (RHEL/CentOS 7), and Btrfs.
</p>
<p>
<strong>Ext4</strong> is still adequate for many organizations,
but <strong>XFS</strong> brings advantages in
scale and performance.
</p>

<p>
Oracle bought Sun Microsystems so you could buy your Oracle
database, the Solaris operating system, and the UltraSPARC
platform on which it all runs in a single purchase.
But they were soon advocating running Solaris on x86,
and soon after that their recommendation was to run Linux
on x86_64/AMD64 hardware.
</p>
<p>
They bought the manufacturer of the Solaris OS and the
UltraSPARC platform but before long they were suggesting
a free operating system on someone else's hardware.
So why did Oracle buy Sun?
</p>
<p>
My theory was that Oracle was buying the
<strong>ZFS</strong> file system and
Solaris and UltraSPARC was the package it came in.
</p>

<p>
Now Oracle is supporting the development of the
<a href="https://btrfs.wiki.kernel.org/index.php/Main_Page">
<strong>Btrfs</strong></a>
file system, which promises to be an alternative to ZFS
with similar promise of true enterprise scale,
performance, and feature set. 
</p>

<p>
When Red Hat Enterprise Linux 7 came out in mid 2014,
it used XFS by default and featured Btrfs as a
"technology preview".
Other distributions have followed suit.
Theodore T'so, the principal developer of the Ext3 and
Ext4 file systems has stated that while Ext4 was an
improvement in performance and feature set, it is a
"stop-gap" on the way to Btrfs.
</p>

<p>
Meanwhile there is the
<a href="http://zfsonlinux.org/">ZFS on Linux project</a>.
Ubuntu 16.04 was released with ZFS, see the
<a href="https://insights.ubuntu.com/2016/02/16/zfs-is-the-fs-for-containers-in-ubuntu-16-04/">
announcement</a>
and the
<a href="https://wiki.ubuntu.com/ZFS">support page</a>.
</p>

</section>
<section>
<h2> Create File Systems </h2>

<p>
There are tools to convert one file system into another
in place, or at least to convert Ext3 into Ext4
and to convert Ext3 or Ext4 into XFS in place.
<strong>However, you should back up your data and create a
fresh file system of the newer type in order to
better optimize metadata layout and take advantage
of the newer file system's performance
improvements.</strong>
Backup and restore into a fresh file system also eliminates
much of the fragmentation that will have crept into due to
modifications, deletions, and additions to the existing
file system.
</p>

<p>
<strong>Match the block size of the underlying storage
or a multiple thereof.</strong>
Other than block size, you probably don't want
to adjust anything when creating any of these file systems.
Maybe add a label and/or UUID, but that's it in most cases.
</p>

<p>
By default Ext4 uses heuristics to select a block size of
1024, 2048, or 4096 bytes, although it will be 4096 on all
file systems over 512 MBytes in size unless over-ridden
by <code>/etc/mke2fs.conf</code> or command-line options.
</p>

<pre style="clear: both;"># mkfs.ext4 -b 4096 /dev/sde1 </pre>

<p>
XFS allows you to specify block size and defaults to 4096-byte
blocks.
</p>

<pre># mkfs.xfs -b size=8192 /dev/sde1 </pre>

<p>
With Btrfs it's the node size or tree block size.
The default is the system page size or 16 kbytes (16384),
whichever is larger.
Specify if you want.
</p>

<pre># mkfs.btrfs -n 65536 /dev/sde1 </pre>

<p>
If your storage is RAID, create file systems with matching
block sizes so aligned full stripe writes can be written
directly to the disk.
This is where it gets complicated.
See the manual page for
<a href="http://linux.die.net/man/8/mkfs.ext4">
<code>mkfs.ext4</code></a>
for an example of calculating the correct
<code>stride_size</code>
and
<code>stripe_width</code>.
On XFS, it's <code>sunit</code> or strip unit size as the
number of 512-byte sectors.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_2" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame2"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> Limit Fragmentation </h2>

<p>
When you start with a nearly empty file system, new files
can be stored in an optimal way.
An individual file can be stored as a contiguous series
of extents (or allocated blocks), and when you install a
package or otherwise extract an archive the component
files will probably be stored close to each other.
Later access to multiple files from that package or archive
can be done with minimal head motion.
</p>

<p>
The problem is that as you delete or truncate existing files,
new "holes" of free space appear.
<em>Free space is becoming fragmented.</em>
</p>
<p>
When you append data to an existing file, it is often
the case that the following blocks are already in use so
a new extent must be created somewhere else within the
file system.
<em>Individual files are becoming fragmented.</em>
</p>
<p>
As you add new files, there is no longer space to store them
at physical locations close to the other files in the same
directories.
<em>Files are being scattered across the volume.</em>
</p>

<p>
<strong>These problems become worse as the file system ages, and
<em>especially so as it becomes more full.</em></strong>
</p>

<h3> Preëmptive Techniques for Limiting Fragmentation </h3>

<p>
Many of the modern file systems preallocate longer extents
to files that are being appended to.
Ext4, XFS, and Btrfs do <em>delayed allocation</em> or
<em>allocate-on-flush,</em> which holds data in memory
until it must be flushed.
This groups block or extent allocation into larger groups,
and reduces both fragmentation and CPU interruption.
</p>

<p>
Btrfs includes what it calls automatic on-line defragmentation,
although it's really fragmentation avoidance.
Mount the file system with the <code>autodefrag</code> option.
It will detect small random writes into files and queue them
for the defrag process.
This works well for small files.
However, it hurts performance with workloads of large
databases or virtual machine disk images as those situations
have many small writes that are within one large file.
</p>

<p>
Careful design of applications can help.
A common example is a BitTorrent client which gradually fills
in a large file one small piece at a time in a random order,
or a media processing program that takes a lot of time to
create a large file sequentially but you know its eventual
size in advance.
The <code>fallocate()</code> or <code>posix_fallocate()</code>
system call can pre-allocate the file to its expected file,
minimizing its fragmentation.
</p>

<h3> Retroactive Techniques for Reducing Fragmentation </h3>

<p>
Many file systems have defragmentation tools to reorder
the extents of files, and some of them can reduce file
scattering.
</p>
<p>
<strong>The easiest and fastest way to get a less fragmented
file system is to back up all your data to another
volume.
Then create a new file system within the old volume
and copy the data back into place.</strong>
But to measure fragmentation and work to defragment it
in place:
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_3" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame3"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

<h3> Ext4 Fragmentation and Defragmentation </h3>

<p>
You can measure the fragmentation of free space with
<code>e2freefrag</code>.
It displays an overview and a histogram of free extent sizes.
</p>

<pre># e2freefrag /dev/sdb1          
Device: /dev/sdb1
Blocksize: 4096 bytes
Total blocks: 244190390
Free blocks: 92461513 (37.9%)

Min. free extent: 4 KB 
Max. free extent: 2064256 KB
Avg. free extent: 91568 KB
Num. free extent: 4039

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
4K...    8K-  :           237           237    0.00%
8K...   16K-  :           130           286    0.00%
16K...   32K-  :            77           386    0.00%
32K...   64K-  :            77           938    0.00%
64K...  128K-  :           132          3254    0.00%
128K...  256K-  :           152          6707    0.01%
256K...  512K-  :           540         51111    0.06%
512K... 1024K-  :           972        145906    0.16%
1M...    2M-  :           542        169617    0.18%
2M...    4M-  :           223        155107    0.17%
4M...    8M-  :           243        415689    0.45%
8M...   16M-  :            32         89916    0.10%
16M...   32M-  :            13         72453    0.08%
32M...   64M-  :            26        323374    0.35%
64M...  128M-  :           309       7572979    8.19%
128M...  256M-  :            78       3249618    3.51%
256M...  512M-  :            70       6185074    6.69%
512M... 1024M-  :            40       7921928    8.57%
1G...    2G-  :           146      66096934   71.49% </pre>


<p>
Use <code>filefrag</code> to display the number of extents
into which a file has been fragmented.
</p>

<pre># filefrag CentOS-x86_64.iso 
CentOS-x86_64.iso: 28 extents found </pre>

<p>
Use <code>e4defrag</code> with the <code>-c</code> option
for a report of how fragmented the file system is.
</p>

<pre># e4defrag -c /home
&lt;Fragmented files&gt;                             now/best       size/ext
1. /home/vmware/RHEL6/RHEL6-1-s007.vmdk          2/1              6 KB
2. /home/vmware/Solaris-10/Solaris-10-s003.vmdk
                            2/1             32 KB
3. /home/vmware/Solaris-10/Solaris-10-s002.vmdk
                            2/1             32 KB
4. /home/vmware/Solaris-10/Solaris-10-s004.vmdk
                            2/1             32 KB
5. /home/vmware/Solaris-10/Solaris-10-s001.vmdk
                            2/1             32 KB

Total/best extents                             59433/50512
Average size per extent                        9950 KB
Fragmentation score                            0
[0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
This directory (/home) does not need defragmentation.
Done. </pre>

<p>
You can use <code>e4defrag</code> without <code>-c</code>
if you decide it's worth what will be a <em>long</em> wait
to defragment the file system.
</p>

<h3> XFS Fragmentation and Defragmentation </h3>

<p>
Measure the current level of fragmentation with <code>xfs_db</code>.
</p>

<pre># xfs_db -c frag -r /dev/sdb1 </pre>

<p>
Defragment XFS with <code>xfs_fsr</code>.
</p>

<pre># xfs_fsr /dev/sdb1 </pre>

<h3> Btrfs Fragmentation and Defragmentation </h3>

<p>
You use the <code>btrfs</code> command to do most everything
with Btrfs.
For example, you can defragment a file system or
individual files and directories.
</p>

<pre># btrfs filesystem defragment /home
# btrfs filesystem defragment /usr/local/ISOs/*.iso </pre>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_4" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame4"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h2> Choose Appropriate Mount Options </h2>

<p>
<strong>The easiest way to get significant performance
improvements is to disable access times.</strong>
This can make an especially large improvement on workstations,
where various components of the graphical desktop are doing
all sorts of searching and indexing behind the scenes.
</p>

<p>
Every file has <em>three</em> timestamps:
<strong>modify</strong> is when its content was changed,
<strong>change</strong> is when its metadata
(e.g., permissions) was changed, and
<strong>access</strong> is it was last read.
So, a command like <code>find</code> can cause an enormous
amount of writing to a file system, not modifying any files
or directories but updating all the access times of the
directories.
</p>

<p>
Use the mount options <code>noatime</code> and
<code>nodiratime</code> to disable updating the access times
of the files and directories, respectively.
This disables something needed for POSIX compliance,
but there are few uses for it.
</p>

<p>
There are warnings that disabling access times can
confuse some applications, it seems that
the Mutt text-based e-mail client is the standard example.
But...
Mutt's last stable release was in June 2007.
The last development release was in 2013 and there have
been nothing but bug fixes since then.
The latest entry on its
<a href="http://www.mutt.org/news.html">news page</a>
is about a bug fix release in June 2009.
</p>

<div class="fr max50">
<p class="caption" style="max-width: 310px; margin-left: 2em;">
This worry about Mutt reminds me of the
<a href="http://www.snopes.com/history/american/gauge.asp">
urban legend</a>
claiming that railway gauge and therefore Space Shuttle
solid-rocket booster diameter were both derived from a
long series of standards going back to
Roman chariot axle length.
</p>
</div>

<p>
An even less critical warning is that once you disable
access times, you can no longer tell which files your
users are actually using.
Some organizations will inform their users,
<em>"Here is a list of files you don't seem to have used
within the past year.  We would like to move these
off the systems to an archive."</em>
</p>

<p>
Reasonably clever users will simply do the following once
in a while to make all their files seem important:
</p>
<pre style="clear: right;">$ find ~ -type f -exec cp {} /dev/null \; </pre>

<p>
To be safe, use <code>nodiratime</code> to disable directory
access times plus <code>relatime</code> to only change
the access time when the modify or change time is updated.
So something like this:
</p>

<pre style="clear: both;"># cat /etc/fstab
UUID=62dfc4a4-86c2-4ebf-aaa3-442ecc740122 / ext4 nodiratime,relatime 1 1
LABEL=/boot     /boot   ext4    nodiratime,relatime 1 2
LABEL=/home     /home   ext4    nodiratime,relatime 1 2
LABEL=/var      /var    ext4    nodiratime,relatime 1 2
/dev/cdrom /media/cdrom auto umask=0,users,iocharset=utf8,noauto,ro,exec 0 0
none /proc proc defaults 0 0
UUID=12e71ecd-833d-45ea-adfd-1eca8c27d912 swap swap defaults 0 0 </pre>

<h3>Leave write barriers in place.</h3>
<p>
Journaling file system use write barriers to ensure that
data has been written onto the physical media.
It is possible to mount a file system with write barriers
disabled (<code>barrier=0</code> option on Ext4,
<code>nobarrier</code> on XFS and Btrfs),
but it is a <em>very</em>
bad idea unless you are absolutely certain that your storage
subsystem has a perfectly reliable battery-backed power supply.
Even if you think it is safe, any performance improvement
should be negligible.
</p>

<div class="centered cb">
<ins class="adsbygoogle responsive" style="display:block;" data-full-width-responsive="true" data-ad-client="ca-pub-5845932372655417" data-ad-slot="4849215406"><iframe id="aswift_5" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame5"></iframe></iframe></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>

</section>
<section>
<h3> Select an Appropriate Journal Mode </h3>

<p>
Ext4 gives you a choice of journaling modes which you can
select when mounting the file system, as options to
the <code>mount</code> command when experimenting and
then as settings recorded in <code>/etc/fstab</code>.
</p>

<p>
<strong><code>data=ordered</code></strong> is the default,
it only journals the metadata.
Data blocks are written to the file system first,
then metadata.
</p>

<p>
<strong><code>data=writeback</code></strong>
may provide some performance improvement,
<em>but at severe security risk on a multi-user system.</em>
It only journals the metadata, and then data and metadata
may be written to the disk in any order.
The risk is that if a system crashes while appending to a file,
if it happens that the metadata had been committed (allocating
additional data blocks to the file) before the data had been
written (overwriting data blocks with new contents), then after
the journal recovery that file may contain data blocks with
contents from previously deleted files from any user on that
file system.
<strong>If you are tempted to use <code>data=writeback</code>
for performance on file systems like <code>/tmp</code>,
disable the journal instead with:</strong><br>
<code>tune2fs -O ^has_journal /dev/sde1</code>
</p>

<p>
<strong><code>data=journal</code></strong>
writes <em>all</em> data twice:
first to the journal and then to the data and metadata blocks.
This will slightly improve the integrity of the data blocks,
but with a serious degradation in performance.
</p>

<p>
<strong>Given the relatively low probability of losing data
blocks during a system crash, most organizations would
be better served by verifying again that their backup
and recovery processes are trustworthy, and then using
the default <code>data=ordered</code>.</strong>
</p>


<h2> And next... </h2>

<p>
Now that we have optimized our disk I/O as best we can,
let's move on to networking.
<strong>We will start at the bottom and
<a href="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html">
tune Ethernet performance across the LAN</a>.</strong>
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
<a href="https://cromwell-intl.com/open-source/performance-tuning/ethernet.html" class="btn btn-lg btn-success btn-block">
<strong>Next:</strong>
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
<div id="amzn-assoc-ad-ef2fcc8e-0ac6-4a12-8f2b-bfcaa5e8eb58"></div><script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs_002"></script><!-- end Amazon related ads -->

<!-- Amazon oneTag script -->
<script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/onejs"></script>

<!-- Google matched content -->
<p style="font-size:0.8rem; text-align:left; margin:0; padding:2px;">
Now some lurid advertisements from Google AdSense:
</p>
<div class="centered">
<ins class="adsbygoogle" style="display:block;" data-ad-client="ca-pub-5845932372655417" data-ad-slot="9123376601" data-ad-format="autorelaxed"><iframe id="aswift_6" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame6"></iframe></iframe></ins>
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
<a href="https://validator.w3.org/nu/?showsource=yes&amp;doc=https://cromwell-intl.com/open-source/performance-tuning/file-systems.html"><img src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/html5-badge-h-css3-semantics.png" alt="Valid HTML 5.  Validate it here." loading="lazy" style="padding: 0; margin: 0;"></a>
<br>
<a href="https://jigsaw.w3.org/css-validator/check/referer">
<img src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/valid-css.png" alt="Valid CSS.  Validate it here." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:12%;">
<a href="https://www.unicode.org/">
<img src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/unicode.png" alt="Valid Unicode." loading="lazy" style="padding: 8px 0 0 0; margin: 0;"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://nginx.org/">
<img src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/nginx_logo-70pc.png" alt="Nginx" loading="lazy"></a>
</div>
<div class="fr" style="max-width:25%;">
<a href="https://www.freebsd.org/">
<img src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/powerlogo.gif" alt="FreeBSD" loading="lazy"></a>
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
<script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/modernizr.min.js" integrity="sha512-3n19xznO0ubPpSwYCRRBgHh63DrV+bdZfHK52b1esvId4GsfwStQNPJFjeQos2h3JwCmZl0/LgLxSKMAI55hgw==" crossorigin="anonymous"></script>
<script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/jquery-3.6.1.slim.min.js" integrity="sha384-MYL22lstpGhSa4+udJSGro5I+VfM13fdJfCbAzP9krCEoK5r2EDFdgTg2+DGXdj+" crossorigin="anonymous"></script>
<script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


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
<script>   var infolinks_pid = 3267443;   var infolinks_wsid = 0; </script> <script async="" src="File%20Systems%20%E2%80%94%20Performance%20Tuning%20on%20Linux_files/infolinks_main.js"></script>
<!-- end of footer.html -->


</body></html>