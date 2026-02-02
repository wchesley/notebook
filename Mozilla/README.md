<sub>[Back](../README.md)</sub>

# Mozilla Firefox

Firefox is a free web browser backed by Mozilla, a non-profit dedicated to internet health and privacy.

## Policy Templates

Firefox policies can be specified using the Group Policy templates on Windows, Intune on Windows, configuration profiles on macOS, or by creating a file called `policies.json`. On Windows, create a directory called distribution where the EXE is located and place the file there. On Mac, the file goes into `Firefox.app/Contents/Resources/distribution`. On Linux, the file goes into `firefox/distribution`, where firefox is the installation directory for firefox, which varies by distribution or you can specify system-wide policy by placing the file in `/etc/firefox/policies`.

Unfortunately, JSON files do not support comments, but you can add extra entries to the JSON to use as comments. You will see an error in `about:policies`, but the policies will still work properly. For example:

```json
{
  "policies": {
    "Authentication": {
      "SPNEGO": ["mydomain.com", "https://myotherdomain.com"]
    }
    "Authentication_Comment": "These domains are required for us"
  }
}
```

> [!Note]
> The `policies.json` must use the UTF-8 encoding.

[Policy Template Docs](https://mozilla.github.io/policy-templates/)  
[Policy Template Git Repo](https://github.com/mozilla/policy-templates)  