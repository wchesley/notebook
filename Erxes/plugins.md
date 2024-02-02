# Plugins (Self-hosted)

## Issue: Cannot load Marketplace

When I click on the market place tab on self-hosted Erxes, the page never loads, it just spins endlessly

## Resolution

On Erxes [deployment page](https://docs.erxes.io/quickstart#deployment) under 'Addding new plugins to erxes' I noticed that plugins are specified under `configs.json` in a `plugins` block. Using that I was able to add plugins to Erxes self-hosted version. [Issue #3923](https://github.com/erxes/erxes/issues/3923) seemed to validate my issue ~~but no solution is provided there~~ Since I found a solution, I've posted it to this issue. Also see [Issue #4867](https://github.com/erxes/erxes/issues/4867). 

I restarted Erxes after adding the plugins, but they still wouldn't show up in the UI, so I started digging around in the `/erxes/cli` directory. In it's README, they specified an extra arguement for the plugins of `ui: local`, adding that and restarting erxes the plugins appeared in the web UI and were functional. 

# Configs.json sample: 

This is my config file as of 01-25-2024

```json
{
	"jwt_token_secret": "token",
        "dashboard": {
	},
	"client_portal_domains": "",
	"elasticsearch": {},
	"redis": {
		"password": ""
	},
	"mongo": {
		"username": "",
		"password": ""
	},
	"rabbitmq": {
		"cookie": "",
		"user": "",
		"pass": "",
		"vhost": ""
	},
	"plugins": [
		{
			"name": "logs"
		},
		{
			"name": "webbuilder",
			"ui": "local"
		},
		{
			"name": "cards",
			"ui": "local"
		},
		{
			"name": "products"
		},
		{
			"name": "segments"
		}
	]
}
```