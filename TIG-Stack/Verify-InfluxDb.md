# Verify InfluxDB Repository:

## Choose the InfluxData key-pair for your OS version

*Before running the installation steps, substitute the InfluxData key-pair compatible
with your OS version:*

For newer releases (for example, Ubuntu 20.04 LTS and newer, Debian Buster
and newer) that support subkey verification:

- Private key file: [`influxdata-archive.key`](https://repos.influxdata.com/influxdata-archive.key)
- Public key: `943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515`

For older versions (for example, CentOS/RHEL 7, Ubuntu 18.04 LTS, or Debian
Stretch) that don’t support subkeys for verification:

- Private key file: [`influxdata-archive_compat.key`](https://repos.influxdata.com/influxdata-archive_compat.key)
- Public key: `393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c`

## Verify download integrity using SHA-256

For each released binary, InfluxData publishes the SHA checksum that
you can use to verify that the downloaded file is intact and hasn’t been corrupted.

To use the SHA checksum to verify the downloaded file, do the following:

1. In the [downloads page](https://www.influxdata.com/downloads),
select the **Version** and **Platform** for your download, and then copy
the **SHA256:** checksum value.
2. Compute the SHA checksum of the downloaded file and compare it to the
published checksum–for example, enter the following command in your terminal.

```bash
# Use 2 spaces to separate the checksum from the filename
echo "9cb54d3940c37a8c2a908458543e629412505cc71db55094147fd39088b99c6c
  influxdb2-2.7.10_linux_amd64.tar.gz" \
| sha256sum --check -

```

Replace the following:

- `9cb54d3940c37a8c2a908458543e629412505cc71db55094147fd39088b99c6c`:
the **SHA256:** checksum value that you copied from the downloads page

If the checksums match, the output is the following; otherwise, an error message.

```
influxdb2-2.7.10_linux_amd64.tar.gz: OK

```

## Verify file integrity and authenticity using GPG

InfluxData uses [GPG (GnuPG)](https://www.gnupg.org/software/) to sign released software and provides
public key and encrypted private key (`.key` file) pairs that you can use to
verify the integrity of packages and binaries from the InfluxData repository.

Most operating systems include `gpg` by default.
*If `gpg` isn’t available on your system, see
[GnuPG download](https://gnupg.org/download/) and install instructions.*

The following steps guide you through using GPG to verify InfluxDB
binary releases:

1. [Choose the InfluxData key-pair for your OS version](https://docs.influxdata.com/influxdb/v2/install/?t=Linux#choose-the-influxdata-key-pair-for-your-system).
2. Download and import the InfluxData public key.
    
    `gpg --import` outputs to stderr.
    The following example shows how to import the key, redirect the output to stdout,
    and then check for the expected key name:
    

```
curl --silent --location \
https://repos.influxdata.com/influxdata-archive.key
 \
 | gpg --import - 2>&1 \
 | grep 'InfluxData Package Signing Key <support@influxdata.com>'

```

Replace the following:

- `https://repos.influxdata.com/influxdata-archive.key`:
the InfluxData private key file compatible with your OS version

If successful, the output is the following:

```
gpg: key 7C3D57159FC2F927: public key "InfluxData Package Signing Key <support@influxdata.com>" imported

```

1. Download the signature file for the release by appending `.asc` to the download URL,
and then use `gpg` to verify the download signature–for example, enter the
following in your terminal:
    
    ```
    curl --silent --location \
    https://download.influxdata.com/influxdb/releases/influxdb2-2.7.10_darwin_amd64.tar.gz.asc \
    | gpg --verify - ~/Downloads/influxdb2-2.7.10_darwin_amd64.tar.gz \
    2>&1 | grep 'InfluxData Package Signing Key <support@influxdata.com>'
    
    ```
    
    - `curl --silent --location`: Follows any server redirects and fetches the
    signature file silently (without progress meter).
    - `gpg --verify -`: Reads the signature from stdin and uses it to verify the
    the downloaded `influxdbv2` binary.
    
    If successful, the output is the following:
    
    ```
    gpg: Good signature from "InfluxData Package Signing Key <support@influxdata.com>" [unknown]
    
    ```
    

*For security, InfluxData periodically rotates keys and publishes the new key pairs.*