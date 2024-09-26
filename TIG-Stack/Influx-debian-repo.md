# Influx debian repo

> ## Important!
> The information below still applies to influxdb v2.x + However, as of 09-26-2024, influxdb 1.7 is in Debian (bookworm) 12's deafult repository and can be added with `apt install influxdb influxdb-client`
>
> For influxdb 2.x + installation see: https://docs.influxdata.com/influxdb/v2/install/#install-influxdb-as-a-service-with-systemd 

Column: https://docs.influxdata.com/influxdb/v1.7/introduction/installation/

have to add keys to TIG repo for updates: 

[Updating InfluxDB repo Keys](https://www.influxdata.com/blog/linux-package-signing-key-rotation/)

[Influxdb Repo](https://repos.influxdata.com/)

[Installing InfluxDB OSS](https://docs.influxdata.com/influxdb/v1.7/introduction/installation/)



## Update: Linux Package Signing Key Rotation
https://www.influxdata.com/blog/linux-package-signing-key-rotation/ 
By Barbara Nelson / Jan 24, 2023 / Community, Trust

UPDATE 2023-01-26: As of 2023-01-26, InfluxData’s Linux packaging signing key has been rotated. Users should update their configuration to use the new key.

Original 2023-01-24: On January 4th, CircleCI issued an alert recommending that all CircleCI users rotate their secrets. InfluxData is a customer of CircleCI, and so, out of an abundance of caution, we are proactively rotating all secrets stored in CircleCI.

InfluxData uses CircleCI for various products and the Linux packaging signing key with fingerprint `05CE 1508 5FC0 9D18 E99E FB22 684A 14CF 2582 E0C5` was stored in CircleCI during the time of the exposure. InfluxData will be rotating this signing key and as a result, Linux DEB and RPM users must configure their systems to use the new key.

Official InfluxData repositories have not been compromised, and InfluxData has verified that the software signed by this key and retrievable via official repositories has not been modified. Furthermore, while a hypothetical attacker could use this key to sign binaries that look like they come from InfluxData, the attacker does not have access to the official repositories to deliver them to your hosts.

We are rotating the key signing keys in two phases:

    On 2023-01-26 we will start using the new Linux package signing key with fingerprint
    9D53 9D90 D332 8DC7 D6C8 D3B9 D8FF 8E1F 7DF8 B07E
    On 2023-04-27 we will revoke the the old Linux package signing key with fingerprint
    05CE 1508 5FC0 9D18 E99E FB22 684A 14CF 2582 E0C5

Once the new key is rolled out to official InfluxData repositories, DEB and RPM-based Linux systems will no longer be able to download and/or verify software coming from InfluxData repositories until the following configuration changes are made. InfluxData will provide an update to this post indicating when the new key is in place.
Configuring Linux hosts to use the new signing key

The fingerprint for the new key is 9D53 9D90 D332 8DC7 D6C8 D3B9 D8FF 8E1F 7DF8 B07E.
## DEB-based systems

    Obtain and verify the new key:

    $ wget -q https://repos.influxdata.com/influxdata-archive_compat.key
    $ gpg --with-fingerprint --show-keys ./influxdata-archive_compat.key
    pub   rsa4096 2023-01-18 [SC] [expires: 2026-01-17]
      	9D53 9D90 D332 8DC7 D6C8  D3B9 D8FF 8E1F 7DF8 B07E
    uid                  	InfluxData Package Signing Key <support@influxdata.com>
    Copy

    Install the new key:

    $ cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
    Copy

    Update your APT sources to use the new key:

    $ echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
    Copy

    Cleanup the old key:

    $ sudo rm -f /etc/apt/trusted.gpg.d/influxdb.gpg
    Copy

    Confirm that sudo apt-get update returns no errors for https://repos.influxdata.com

The above specifies paths to files and configuration from the most recent documentation. Users who use a different file than /etc/apt/sources.list.d/influxdata.list need to update the file to use signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg. Similarly, users who installed the old key in a different location than /etc/apt/trusted.gpg.d/influxdb.gpg need to use that location to remove the old key.
## RPM-based systems

    Update your YUM repos configuration to use the new key:

    $ cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
    [influxdata]
    name = InfluxData Repository - Stable
    baseurl = https://repos.influxdata.com/stable/\$basearch/main
    enabled = 1
    gpgcheck = 1
    gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
    EOF
    Copy

    The next YUM operation that pulls from the repo will update the key:

    $ sudo yum update && sudo yum install telegraf
    Importing GPG key 0x7DF8B07E:
     Userid     : "InfluxData Package Signing Key <support@influxdata.com>"
     Fingerprint: 9D53 9D90 D332 8DC7 D6C8 D3B9 D8FF 8E1F 7DF8 B07E
     From       : https://repos.influxdata.com/influxdata-archive_compat.key
    Is this ok [y/N]: y
    Copy

    Clean up the old key:

    $ sudo rpm --erase gpg-pubkey-2582e0c5-56099b04
    Copy

The above specifies the configuration path from the most recent documentation. Users who use a different file than /etc/yum.repos.d/influxdata.repo need to update the file to use gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key.
Frequently asked questions

Has customer data been compromised?

After a careful investigation, we have no evidence that InfluxData customer data has been compromised as a result of the CircleCI incident.

Was InfluxData source code or binaries modified?

After a careful investigation, we have not found any evidence of unauthorized modification of InfluxData source code or binaries.

What is the difference between influxdata-archive.key and influxdata-archive_compat.key?

The influxdata-archive.key signing key utilizes a modern primary/subkey approach that will be incorporated into future Linux packaging updates. The influxdata-archive_compat.key can verify packages signed with the influxdata-archive.key and has the widest APT and RPM compatibility. Please use the influxdata-archive_compat.key at this time.
