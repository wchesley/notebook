# Aaron Toponce : Install ZFS on Debian GNU/Linux

Created: June 16, 2021 6:44 PM
URL: https://pthree.org/2012/04/17/install-zfs-on-debian-gnulinux/

## Table of Contents

**UPDATE (May 06, 2012)**: I apologize for mentioning it supports encryption. Pool version 28 is the latest source that the Free Software community has. Encryption was not added until pool version 30. So, encryption is not supported natively with the ZFS on Linux project. However, you can use LUKS containers underneath, or you can use Ecryptfs for the entire filesystem, which would still give you all the checksum, scrubbing and data integrity benefits of ZFS. Until Oracle gets their act together, and releases the current sources of ZFS, crypto is not implemented.

Quick post on installing ZFS as a kernel module, not FUSE, on Debian GNU/Linux. The documents already exist for getting this going, I'm just hoping to spread this to a larger audience, in case you are unaware that it exists.

First, the [Lawrence Livermore National Laboratory](https://www.llnl.gov/) has been working on porting the native Solaris ZFS source to the Linux kernel as a kernel module. So long as the project remains under contract by the Department of Defense in the United States, I'm confident there will be continuous updates. You can track the progress of that porting at [http://zfsonlinux.org](http://zfsonlinux.org/).

**UPDATE (May 05, 2013)**: I've updated the installation instructions. The old instructions included downloading the source and installing from there. At the time, that was all that was available. Since then, the ZFS on Linux project has created a proper Debian repository that you can use to install ZFS. Here is how you would do that:

```
$ su -
# wget http://archive.zfsonlinux.org/debian/pool/main/z/zfsonlinux/zfsonlinux_2%7Ewheezy_all.deb
# dpkg -i zfsonlinux_2~wheezy_all.deb
# apt-get update
# apt-get install debian-zfs
```

And that's it!

If you're running Ubuntu, which I know most of you are, you can install the packages from the Launchpad PPA [https://launchpad.net/~zfs-native](https://launchpad.net/~zfs-native).

**UPDATE (May 05, 2013)**: The following instructions may not be relevant for fixing the manpages. If they are, I've left them in this post, just struck out.

**A word of note:** the manpages get installed to /share/man/. I found this troubling. You can modify your $MANPATH variable to include /share/man/man8/, or by creating symlinks, which is the approach I took:

```
# cd /usr/share/man/man8/
# ln -s /share/man/man8/zdb.8 zdb.8
# ln -s /share/man/man8/zfs.8 zfs.8
# ln -s /share/man/man8/zpool.8 zpool.8
```

Now, make your zpool, and start playing:

```
$ sudo zpool create test raidz sdd sde sdf sdg sdh sdi
```

It is stable enough to run a ZFS root filesystem on a GNU/Linux installation for your workstation as something to play around with. It is copy-on-write, supports compression, deduplication, file atomicity, off-disk caching, encryption, and much more. At this point, unfortunately, I'm convinced that ZFS as a Linux kernel module will become "stable" long before Btrfs will be stable in the mainline kernel. Either way, it doesn't matter to me. Both are Free Software, and both provide the long needed features we've needed with today's storage needs. Competition is healthy, and I love having choice. Right now, that choice might just be ZFS.