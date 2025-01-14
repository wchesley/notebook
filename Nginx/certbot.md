[back](./README.md)

# How To Acquire a Let's Encrypt Certificate Using DNS Validation with acme-dns-certbot on Ubuntu 18.04

### [Introduction](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#introduction)

The majority of [Let’s Encrypt](https://letsencrypt.org/) certificates are issued using HTTP validation, which allows for the easy installation of certificates on a single server. However, HTTP validation is not always suitable for issuing certificates for use on load-balanced websites, nor can it be used to issue [wildcard certificates](https://en.wikipedia.org/wiki/Wildcard_certificate).

DNS validation allows for certificate issuance requests to be verified using DNS records, rather than by serving content over HTTP. This means that certificates can be issued simultaneously for a cluster of web servers running behind a load balancer, or for a system that isn’t directly accessible over the internet. Wildcard certificates are also supported using DNS validation.

The [acme-dns-certbot](https://github.com/joohoi/acme-dns-certbot-joohoi) tool is used to connect [Certbot](https://certbot.eff.org/) to a third-party DNS server where the certificate validation records can be set automatically via an API when you request a certificate. The advantage of this is that you don’t need to integrate Certbot directly with your DNS provider account, nor do you need to grant it unrestricted access to your full DNS configuration, which is beneficial to security.

Delegated [DNS zones](https://www.digitalocean.com/community/tutorials/an-introduction-to-dns-terminology-components-and-concepts#zone-files) are used in order to redirect lookups for the certificate verification records to the third-party DNS service, so once the initial setup has been completed, you can request as many certificates as you want without having to perform any manual validation.

Another key benefit of acme-dns-certbot is that it can be used to issue certificates for individual servers that may be running behind a load balancer, or are otherwise not directly accessible over HTTP. Traditional HTTP certificate validation cannot be used in these cases, unless you set the validation files on each and every server. The acme-dns-certbot tool is also useful if you want to issue a certificate for a server that isn’t accessible over the internet, such as an internal system or staging environment.

In this tutorial, you will use the acme-dns-certbot hook for Certbot to issue a Let’s Encrypt certificate using DNS validation.

## [Prerequisites](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#prerequisites)

To complete this tutorial, you will need:

- An Ubuntu 18.04 server set up by following the [Initial Server Setup with Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04), including a sudo non-root user.
- A domain name for which you can acquire a TLS certificate, including the ability to add DNS records. In this particular example, we will use `your-domain` and `subdomain.your-domain`, as well as `*.your-domain` for a wildcard certificate. However this can be adjusted for other domain, subdomains, or wildcards if required.

Once you have these ready, log in to your server as your non-root user to begin.

## [Step 1 — Installing Certbot](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#step-1-installing-certbot)

In this step, you will install Certbot, which is a program used to issue and manage Let’s Encrypt certificates.

Certbot is available within the official Ubuntu Apt repositories, however, it is instead recommended to use the repository maintained by the Certbot developers, as this always has the most up-to-date version of the software.

Begin by adding the Certbot repository:

You’ll need to press `ENTER` to accept the prompt and add the new repository to your system.

Next, install the Certbot package:

Once the installation has completed, you can check that Certbot has been successfully installed:

This will output something similar to the following:

```
Outputcertbot 0.31.0
```

In this step you installed Certbot. Next, you will download and install the acme-dns-certbot hook.

## [Step 2 — Installing acme-dns-certbot](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#step-2-installing-acme-dns-certbot)

Now that the base Certbot program has been installed, you can download and install acme-dns-certbot, which will allow Certbot to operate in DNS validation mode.

Begin by downloading a copy of the script:

Once the download has completed, mark the script as executable:

Then, edit the file using your favorite text editor and adjust the first line in order to force it to use Python 3:

Add a `3` to the end of the first line:

acme-dns-certbot.py

```
#!/usr/bin/env python3
. . .
```

This is required in order to ensure that the script uses the latest supported version of Python 3, rather than the legacy Python version 2.

Once complete, save and close the file.

Finally, move the script into the Certbot Let’s Encrypt directory so that Certbot can load it:

In this step, you downloaded and installed the acme-dns-certbot hook. Next, you can begin the setup process and work toward issuing your first certificate.

## [Step 3 — Setting Up acme-dns-certbot](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#step-3-setting-up-acme-dns-certbot)

In order to begin using acme-dns-certbot, you’ll need to complete an initial setup process and issue at least one certificate.

Start by running Certbot to force it to issue a certificate using DNS validation. This will run the acme-dns-certbot script and trigger the initial setup process:

You use the `--manual` argument to disable all of the automated integration features of Certbot. In this case you’re just issuing a raw certificate, rather than automatically installing it on a service as well.

You configure Certbot to use the acme-dns-certbot hook via the `--manual-auth-hook` argument. You run the `--preferred-challenges` argument so that Certbot will give preference to DNS validation.

You must also tell Certbot to pause before attempting to validate the certificate, which you do with the `--debug-challenges` argument. This is to allow you to set the DNS `[CNAME` record(s)](https://www.digitalocean.com/community/tutorials/an-introduction-to-dns-terminology-components-and-concepts#record-types) required by acme-dns-certbot, which is covered later in this step. Without the `--debug-challenges` argument, Certbot wouldn’t pause, so you wouldn’t have time to make the required DNS change.

Remember to substitute each of the domain names that you wish to use using `-d` arguments. If you want to issue a wildcard certificate, make sure to escape the asterisk (`*`) with a backslash (`\`).

After following the standard Certbot steps, you’ll eventually be prompted with a message similar to the following:

```
Output...
Output from acme-dns-auth.py:
Please add the following CNAME record to your main DNS zone:
_acme-challenge.your-domain CNAME a15ce5b2-f170-4c91-97bf-09a5764a88f6.auth.acme-dns.io.
Waiting for verification...
...
```

You’ll need to add the required DNS `CNAME` record to the DNS configuration for your domain. This will delegate control of the `_acme-challenge` subdomain to the ACME DNS service, which will allow acme-dns-certbot to set the required DNS records to validate the certificate request.

If you’re using DigitalOcean as your DNS provider, you can set the DNS record within your control panel:

!https://assets.digitalocean.com/articles/acme_dns_certbot_1804/CNAME.png

It is recommended to set the TTL (time-to-live) to around 300 seconds in order to help ensure that any changes to the record are propagated quickly.

Once you have configured the DNS record, return to Certbot and press `ENTER` to validate the certificate request and complete the issuance process.

This will take a few seconds, and you’ll then see a message confirming that the certificate has been issued:

```
Output...
Congratulations! Your certificate and chain have been saved at:
/etc/letsencrypt/live/your-domain/fullchain.pem
Your key file has been saved at:
/etc/letsencrypt/live/your-domain/privkey.pem
...
```

You’ve run acme-dns-certbot for the first time, set up the required DNS records, and successfully issued a certificate. Next you’ll set up automatic renewals of your certificate.

## [Step 4 — Using acme-dns-certbot](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#step-4-using-acme-dns-certbot)

In this final step, you will use acme-dns-certbot to issue more certificates and renew existing ones.

Firstly, now that you’ve successfully issued at least one certificate using acme-dns-certbot, you can continue to issue certificates for the same DNS names without having to add another DNS `CNAME` record. However, if you wish to acquire a certificate for a different subdomain or entirely new domain name, you will be prompted to add another `CNAME` record.

For example, you could issue another standalone wildcard certificate without having to perform the verification again:

However, if you were to attempt to issue a certificate for a subdomain, you would be prompted to add a `CNAME` record for the subdomain:

This will show an output similar to the initial setup that you carried out in Step 3:

```
Output...
Please add the following CNAME record to your main DNS zone:
_acme-challenge.subdomain.your-domain CNAME 8450fb54-8e01-4bfe-961a-424befd05088.auth.acme-dns.io.
Waiting for verification...
...
```

Now that you’re able to use acme-dns-certbot to issue certificates, it’s worth considering the renewal process as well.

Once your certificates are nearing expiry, Certbot can automatically renew them for you:

The renewal process can run start-to-finish without user interaction, and will remember all of the configuration options that you specified during the initial setup.

To test that this is working without having to wait until nearer the expiry date, you can trigger a dry run. This will simulate the renewal process without making any actual changes to your configuration.

You can trigger a dry run using the standard `renew` command, but with the `--dry-run` argument:

This will output something similar to the following, which will provide assurance that the renewal process is functioning correctly:

```
Output...
Cert not due for renewal, but simulating renewal for dry run
Plugins selected: Authenticator manual, Installer None
Renewing an existing certificate
Performing the following challenges:
dns-01 challenge for your-domain
dns-01 challenge for your-domain
Waiting for verification...
Cleaning up challenges
...
```

In this final step, you issued another certificate and then tested the automatic renewal process within Certbot.

## [Conclusion](https://www.digitalocean.com/community/tutorials/how-to-acquire-a-let-s-encrypt-certificate-using-dns-validation-with-acme-dns-certbot-on-ubuntu-18-04#conclusion)

In this article you set up Certbot with acme-dns-certbot in order to issue certificates using DNS validation. This unlocks the possibility of using wildcard certificates as well as managing a large estate of distinct web servers that may be sitting behind a load balancer.

Make sure to keep an eye on the [acme-dns-certbot repository](https://github.com/joohoi/acme-dns-certbot-joohoi) for any updates to the script, as it’s always recommended to run the latest supported version.

If you’re interested in learning more about acme-dns-certbot, you may wish to review the documentation for the acme-dns project, which is the server-side element of acme-dns-certbot:

- [acme-dns on GitHub](https://github.com/joohoi/acme-dns#acme-dns)

The acme-dns software can also be self-hosted, which may be beneficial if you’re operating in high-security or complex environments.

Alternatively, you could dig into the technical details of ACME DNS validation by reviewing the relevant section of the official RFC document which outlines how the process works:

- [RFC8555 - Section 8.4](https://tools.ietf.org/html/rfc8555#section-8.4)