# MinIO

MinIO is an object storage solution that provides an Amazon Web Services S3-compatible API and supports all core S3 features. MinIO is built to deploy anywhere - public or private cloud, baremetal infrastructure, orchestrated environments, and edge infrastructure.

- [Deploy (Linux - Single Server)](https://min.io/docs/minio/linux/operations/install-deploy-manage/deploy-minio-single-node-single-drive.html#minio-snsd)
- [Network Encryption (TLS)](https://min.io/docs/minio/linux/operations/network-encryption.html)
- [MinIO with Veeam](https://min.io/docs/minio/linux/integrations/using-minio-with-veeam.html)
    - Veeam integration requires TLS certificate to be installed to the minio server, and that cert be in use by the minio service. A caveat I noticed is that the private key and public key must be explicitly named `private.key` and `public.crt`
    - Specify cert location in minio config or place in `/.minio/cert` directory of the account running the minio service (by default this is `minio-user`)