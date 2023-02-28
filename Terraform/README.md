# Terraform

* [Terraform Proxmox Provider](https://github.com/Telmate/terraform-provider-proxmox/)
* [Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Gitlab will store state, see https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html
  * that has been somewhat of a nightmare on it's own lol and it's all in the CI/CD pipline where I'm having issues now. 
  * Shockingly [this was helpful](https://blog.ajbothe.com/storing-your-terraform-state-in-gitlab) in getting terraform state setup on gitlab. 

## HTTP variables
Configuration Variables

> Warning: We recommend using environment variables to supply credentials and other sensitive data. If you use -backend-config or hardcode these values directly in your configuration, Terraform will include these values in both the .terraform subdirectory and in plan files. Refer to Credentials and Sensitive Data for details.

The following configuration options / environment variables are supported:

    address / TF_HTTP_ADDRESS - (Required) The address of the REST endpoint
    update_method / TF_HTTP_UPDATE_METHOD - (Optional) HTTP method to use when updating state. Defaults to POST.
    lock_address / TF_HTTP_LOCK_ADDRESS - (Optional) The address of the lock REST endpoint. Defaults to disabled.
    lock_method / TF_HTTP_LOCK_METHOD - (Optional) The HTTP method to use when locking. Defaults to LOCK.
    unlock_address / TF_HTTP_UNLOCK_ADDRESS - (Optional) The address of the unlock REST endpoint. Defaults to disabled.
    unlock_method / TF_HTTP_UNLOCK_METHOD - (Optional) The HTTP method to use when unlocking. Defaults to UNLOCK.
    username / TF_HTTP_USERNAME - (Optional) The username for HTTP basic authentication
    password / TF_HTTP_PASSWORD - (Optional) The password for HTTP basic authentication
    skip_cert_verification - (Optional) Whether to skip TLS verification. Defaults to false.
    retry_max / TF_HTTP_RETRY_MAX – (Optional) The number of HTTP request retries. Defaults to 2.
    retry_wait_min / TF_HTTP_RETRY_WAIT_MIN – (Optional) The minimum time in seconds to wait between HTTP request attempts. Defaults to 1.
    retry_wait_max / TF_HTTP_RETRY_WAIT_MAX – (Optional) The maximum time in seconds to wait between HTTP request attempts. Defaults to 30.