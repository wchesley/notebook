# Veeam Object Storage

## MinIO

ref: https://min.io/docs/minio/linux/integrations/using-minio-with-veeam.html

Using MinIO with Veeam is fairly simple, create a bucket with object lock enabled. That's the only setting that has to be set aside from the name of the bucket. Enabling object lock is required for Veeam backups with immutability, Veeam will manage the retention settings for the bucket, do not enable retention from MinIO's console or it will break Veeam's ability to backup to the repository. I don't know this for sure, but I think that setting retention from minIO's console will override veeam's access level, at that point veeam can't override the locks, conflict ensues and Veeam loses and the backup job fails as a result. Should retention settings be set in minIO's console Veeam's backups will fail with the following error: 

```log
9/26/2024 4:33:53 PM :: Error: Unable to use backup immutability: the default retention is not supported.  
```