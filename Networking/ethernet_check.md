- [source](https://linuxconfig.org/how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux)

<div class="inside-article">
<header class="entry-header" aria-label="Content">
<h1 class="entry-title" itemprop="headline">How to detect whether a physical cable is connected to network card slot on Linux</h1> <div class="entry-meta">
<span class="posted-on"><time class="entry-date updated-date" datetime="2021-07-12T00:00:00+10:00" itemprop="dateModified">12 July 2021</time></span> <span class="byline">by <span class="author vcard" itemprop="author" itemtype="https://schema.org/Person" itemscope=""><a class="url fn n" href="https://linuxconfig.org/author/luke" title="View all posts by Luke Reynolds" rel="author" itemprop="url"><span class="author-name" itemprop="name">Luke Reynolds</span></a></span></span> </div>
</header>
<div class="entry-content" itemprop="text">
<p>If you’ve ever needed to know whether a physical cable is connected to a network port on your <a href="linux-download" target="_blank" rel="noopener">Linux system</a>, you don’t necessarily need to be right in front of the computer or server to look and see. There are several methods we can use from the Linux <a href="linux-command-line-tutorial" target="_blank" rel="noopener">command line</a> in order to see if a cable is plugged into a network slot.</p>
<p>There are a few reasons why this could come in handy. For one, it shows you whether the system itself <i>detects</i> that there’s a cable plugged in. This could be an essential troubleshooting step if you know for a fact that the cable is properly plugged in, yet the system is not detecting it. It’s also helpful on remote systems or if you’re just too lazy to look at the back of the computer and see if the cable is plugged in.</p>
<p>Check out some of the examples below where we go over various <a href="linux-commands" target="_blank" rel="noopener">commands</a> that check whether a physical network cable is plugged in or not.</p>
<p><strong>In this tutorial you will learn:</strong></p>
<ul>
<li>How to detect physical network cable connectivity with Bash commands and ethtool</li>
</ul>
<p><span id="more-567"></span></p>
<div class="uk-margin">
<div class="uk-thumbnail uk-thumbnail-expand"> <a href="https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux.png" data-lightbox-type="image" data-uk-lightbox="{group:group1}" title="Various commands used to detect a connected network cable on Linux"><img decoding="async" class=" size-full wp-image-3537" src="https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux.png" alt="Various commands used to detect a connected network cable on Linux" srcset="https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux.png 1919w, https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux-300x152.png 300w, https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux-1024x519.png 1024w, https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux-768x389.png 768w, https://linuxconfig.org/wp-content/uploads/2015/01/01-how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux-1536x779.png 1536w" sizes="(max-width: 1919px) 100vw, 1919px" width="1919" height="973"></a> <p></p>
<div class="uk-thumbnail-caption">Various commands used to detect a connected network cable on Linux</div>
<p></p></div>
<p></p></div>
<table class="uk-table uk-table-striped uk-table-condensed">
<caption>Software Requirements and Linux Command Line Conventions</caption>
<thead>
<tr>
<th>Category</th>
<th>Requirements, Conventions or Software Version Used</th>
</tr>
</thead>
<tbody>
<tr>
<td>System</td>
<td>Any <a href="linux-download" target="_blank" rel="noopener">Linux distro</a></td>
</tr>
<tr>
<td>Software</td>
<td>ethtool</td>
</tr>
<tr>
<td>Other</td>
<td>Privileged access to your Linux system as root or via the <code>sudo</code> command.</td>
</tr>
<tr>
<td>Conventions</td>
<td>
<b>#</b> – requires given <a href="linux-commands" target="_blank" rel="noopener">linux commands</a> to be executed with root privileges either directly as a root user or by use of <code>sudo</code> command<br>
<b>$</b> – requires given <a href="linux-commands" target="_blank" rel="noopener">linux commands</a> to be executed as a regular non-privileged user
</td>
</tr>
</tbody>
</table>
<h2>Detect if a physical cable is connected</h2>
<hr>
<p>Various tools can be used to detected a physical cable carrier state. However, the easiest accomplish this task is by using basic native tools like <code>cat</code> or <code>grep</code> thus to avoid any need for additional software installation. Take a look at the methods below to see how.</p>
<ol class="methods">
<li>Let’s start by testing our <code>eth0</code> network interface for a physical cable connection in a low-level and Linux distro-agnostic way:
<pre># cat /sys/class/net/eth0/carrier 
1
</pre>
<p>The number 1 in the above output means that the network cable is physically connected to your network card’s slot.</p>
</li>
<li>Next, we will test a second network interface <code>eth1</code>:
<pre># cat /sys/class/net/eth1/carrier 
cat: /sys/class/net/eth1/carrier: Invalid argument
</pre>
<p>The above command’s output most likely means the the <code>eth1</code> network interface is in powered down state. This can be confirmed by the following linux command:</p>
<pre># cat /sys/class/net/eth1/operstate 
down
</pre>
<p>The network cable can be connected but there is no way to tell at the moment. Before we can check for a physical cable connection we need to put the interface up:</p>
<pre># ip link set dev eth1 up
</pre>
<p>At this stage we can again check for a network card physical cable connection:</p>
<pre># cat /sys/class/net/eth1/carrier 
0
</pre>
</li>
<hr>
<li>Based on the above output we can say that a physical cable is disconnected from the network card’s slot. Let’s let’s see briefly how we can automate the above procedure to check multiple network interfaces at once. The below command will list all available network interfaces on your Linux system:
<pre># for i in $( ls /sys/class/net ); do echo $i; done
eth0
eth1
lo
wlan0
</pre>
<p>Using a bash for loop we can now check whether a network cable is connected for all network interfaces at once:</p>
<pre># for i in $( ls /sys/class/net ); do echo -n $i: ; cat /sys/class/net/$i/carrier; done
eth0:1
eth1:0
lo:1
wlan0:cat: /sys/class/net/wlan0/carrier: Invalid argument
</pre>
</li>
</ol>
<h2>Test for physical cable connection with ethtool</h2>
<p>Now, if you really want to get fancy you can do the above task using the ethtool command. Here’s how to install the software on major Linux distributions:</p>
<p>To install ethtool on <a href="ubuntu-linux-download" target="_blank" rel="noopener">Ubuntu</a>, <a href="debian-linux-download" target="_blank" rel="noopener">Debian</a>, and <a href="linux-mint-download" target="_blank" rel="noopener">Linux Mint</a>:</p>
<pre>$ sudo apt install ethtool
</pre>
<hr>
<p>To install ethtool on <a href="centos-linux-download" target="_blank" rel="noopener">CentOS</a>, <a href="fedora-linux-download" target="_blank" rel="noopener">Fedora</a>, <a href="almalinux-download" target="_blank" rel="noopener">AlmaLinux</a>, and <a href="red-hat-linux-download" target="_blank" rel="noopener">Red Hat</a>:</p>
<pre>$ sudo dnf install ethtool
</pre>
<p>To install ethtool on <a href="arch-linux-download" target="_blank" rel="noopener">Arch Linux</a> and <a href="manjaro-linux-download" target="_blank" rel="noopener">Manjaro</a>:</p>
<pre>$ sudo pacman -S ethtool
</pre>
<p>Now that it’s installed, you can use one or more of the following commands below to test the network connection of a physical cable.</p>
<ol class="methods">
<li>To check a single network card for a cable connection use the following command. As an example, let’s check the <code>eth1</code> interface:
<pre>#  ethtool eth1 | grep Link\ d
	Link detected: no
</pre>
</li>
<li>Or we can use bash for loop again to check all network interfaces it once:
<pre># for i in $( ls /sys/class/net ); do echo -n $i; ethtool $i | grep Link\ d; done
eth0	Link detected: yes
eth1	Link detected: no
lo	Link detected: yes
wlan0	Link detected: no
</pre>
<p>The only problem with the above ethtool output is that it will not detect a connected cable if your network interface is down. Consider the following example:</p>
<pre># ethtool eth0 | grep Link\ d
        Link detected: yes
# ip link set dev eth0 down
# ethtool eth0 | grep Link\ d
        Link detected: no
</pre>
</li>
</ol>
<hr>
<h2>Closing Thoughts</h2>
<p>In this guide, we saw how to detect whether a physical cable is connected to a network card slot on Linux. This is handy to check the connections on a remote machine or just as a troubleshooting step to see if your system is detecting a physical cable or not. If you have a cable plugged in but your system is not detecting it, it could mean you’re missing a network driver or have a faulty network card altogether.</p>
<div class="crp_related     crp-text-only"><h3>Related Linux Tutorials:</h3><ul><li><a href="https://linuxconfig.org/things-to-install-on-ubuntu-20-04" target="_blank" class="crp_link post-2035"><span class="crp_title">Things to install on Ubuntu 20.04</span></a></li><li><a href="https://linuxconfig.org/things-to-do-after-installing-ubuntu-20-04-focal-fossa-linux" target="_blank" class="crp_link post-2072"><span class="crp_title">Things to do after installing Ubuntu 20.04 Focal Fossa Linux</span></a></li><li><a href="https://linuxconfig.org/things-to-do-after-installing-ubuntu-22-04-jammy-jellyfish-linux" target="_blank" class="crp_link post-14333"><span class="crp_title">Things to do after installing Ubuntu 22.04 Jammy Jellyfish…</span></a></li><li><a href="https://linuxconfig.org/things-to-install-on-ubuntu-22-04" target="_blank" class="crp_link post-14649"><span class="crp_title">Things to install on Ubuntu 22.04</span></a></li><li><a href="https://linuxconfig.org/an-introduction-to-linux-automation-tools-and-techniques" target="_blank" class="crp_link post-17633"><span class="crp_title">An Introduction to Linux Automation, Tools and Techniques</span></a></li><li><a href="https://linuxconfig.org/how-to-use-adb-android-debug-bridge-to-manage-your-android-mobile-phone" target="_blank" class="crp_link post-2297"><span class="crp_title">How to Use ADB Android Debug Bridge to Manage Your Android…</span></a></li><li><a href="https://linuxconfig.org/linux-download" target="_blank" class="crp_link post-2124"><span class="crp_title">Linux Download</span></a></li><li><a href="https://linuxconfig.org/hung-linux-system-how-to-escape-to-the-command-line-and-more" target="_blank" class="crp_link post-2462"><span class="crp_title">Hung Linux System? How to Escape to the Command Line and…</span></a></li><li><a href="https://linuxconfig.org/install-arch-linux-in-vmware-workstation" target="_blank" class="crp_link post-2291"><span class="crp_title">Install Arch Linux in VMware Workstation</span></a></li><li><a href="https://linuxconfig.org/basic-linux-commands" target="_blank" class="crp_link post-17054"><span class="crp_title">Basic Linux Commands</span></a></li></ul><div class="crp_clear"></div></div> </div>
