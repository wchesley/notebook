# Download and install the influx CLI

The influx command line interface (CLI) includes commands to manage many aspects of InfluxDB, including buckets, organizations, users, tasks, etc.

## Download and Install: 

Direct Download link adm64 for v2.7.5: https://download.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-amd64.tar.gz

I don't run anything with ARM but for the sake of completeness: https://download.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-arm64.tar.gz

1. [**Download from the command line**](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#download-from-the-command-line)

```bash
# amd64
wget https://download.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-amd64.tar.gz

# arm
wget https://download.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-arm64.tar.gz`
```
  

2. **Unpackage the downloaded package.**
***Note:** The following commands are examples. Adjust the filenames, paths, and utilities if necessary.*

```bash
# amd64 
tar xvzf path/to/influxdb2-client-2.7.5-linux-amd64.tar.gz

# arm
tar xvzf path/to/influxdb2-client-2.7.5-linux-arm64.tar.gz`
```  

3. **(Optional) Place the unpackaged `influx` executable in your system `$PATH`.**

```bash 
# amd64
sudo cp influxdb2-client-2.7.5-linux-amd64/influx /usr/local/bin/

# arm
sudo cp influxdb2-client-2.7.5-linux-arm64/influx /usr/local/bin/`
```  

> If you do not move the `influx` binary into your `$PATH`, prefix the executable
`./` to run it in place.


## [Provide required authentication credentials](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#provide-required-authentication-credentials)

To avoid having to pass your InfluxDB **host**, **API token**, and **organization**
with each command, store them in an `influx` CLI configuration (config).
`influx` commands that require these credentials automatically retrieve these
credentials from the active config.

Use the [`influx config create` command](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/config/create/)
to create an `influx` CLI config and set it as active:

```
influx config create --config-name <config-name> \
  --host-url https://us-west-2-1.aws.cloud2.influxdata.com \
  --org <your-org> \
  --token <your-auth-token> \
  --active

```

[InfluxDB Cloud Region](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#)

For more information about managing CLI configurations, see the
[`influx config` documentation](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/config/).

### [Credential precedence](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#credential-precedence)

There are three ways to provide the necessary credentials to the `influx` CLI,
which uses the following precedence when retrieving credentials:

1. Command line flags (`-host`, `-org -o`, `-token -t`)
2. Environment variables (`INFLUX_HOST`, `INFLUX_ORG`, `INFLUX_TOKEN`)
3. CLI configuration file

## [Usage](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#usage)

```
influx [flags]
influx [command]

```

## [Commands](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#commands)

| Command | Description |
| --- | --- |
| [apply](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/apply/) | Apply an InfluxDB template |
| [auth](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/auth/) | API token management commands |
| [backup](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/backup/) | Back up data *(InfluxDB OSS only)* |
| [bucket](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/bucket/) | Bucket management commands |
| [bucket-schema](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/bucket-schema/) | Manage InfluxDB bucket schemas *(InfluxDB Cloud only)* |
| [completion](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/completion/) | Generate completion scripts |
| [config](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/config/) | Configuration management commands |
| [dashboards](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/dashboards/) | List dashboards |
| [delete](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/delete/) | Delete points from InfluxDB |
| [export](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/export/) | Export resources as a template |
| [help](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/help/) | Help about any command |
| [org](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/org/) | Organization management commands |
| [ping](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/ping/) | Check the InfluxDB `/health` endpoint |
| [query](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/query/) | Execute a Flux query |
| [restore](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/restore/) | Restore backup data *(InfluxDB OSS only)* |
| [scripts](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/scripts) | Scripts management commands *(InfluxDB Cloud only)* |
| [secret](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/secret/) | Manage secrets |
| [setup](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/setup/) | Create default username, password, org, bucket, etc. *(InfluxDB OSS only)* |
| [stacks](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/stacks/) | Manage InfluxDB stacks |
| [task](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/task/) | Task management commands |
| [telegrafs](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/telegrafs/) | Telegraf configuration management commands |
| [template](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/template/) | Summarize and validate an InfluxDB template |
| [user](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/user/) | User management commands |
| [v1](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/v1/) | Work with the v1 compatibility API |
| [version](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/version/) | Print the influx CLI version |
| [write](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/write/) | Write points to InfluxDB |

## [Flags](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#flags)

| Flag |  | Description |
| --- | --- | --- |
| `-h` | `--help` | Help for the `influx` command |

### [Flag patterns and conventions](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#flag-patterns-and-conventions)

The `influx` CLI uses the following patterns and conventions:

- [Mapped environment variables](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#mapped-environment-variables)
- [Shorthand and longhand flags](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#shorthand-and-longhand-flags)
- [Flag input types](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#flag-input-types)

### [Mapped environment variables](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#mapped-environment-variables)

`influx` CLI flags mapped to environment variables are listed in the **Mapped to**
column of the Flags table in each command documentation.
Mapped flags inherit the value of the environment variable.
To override environment variables, set the flag explicitly in your command.

View mapped environment variables

### [Shorthand and longhand flags](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#shorthand-and-longhand-flags)

Many `influx` CLI flags support both shorthand and longhand forms.

- **shorthand:** a shorthand flag begins with a single hyphen followed by a single letter (for example: `c`).
- **longhand:** a longhand flag starts with two hyphens followed by a multi-letter,
hyphen-spaced flag name (for example: `-active-config`).

Commands can use both shorthand and longhand flags in a single execution.

### [Flag input types](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#flag-input-types)

`influx` CLI flag input types are listed in each the table of flags for each command.
Flags support the following input types:

### [string](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#string)

Text string, but the flag can be used **only once** per command execution.

### [stringArray](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#stringarray)

Single text string, but the flag can be used **multiple times** per command execution.

### [integer](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#integer)

Sequence of digits representing an integer value.

### [duration](https://docs.influxdata.com/influxdb/cloud/reference/cli/influx/?t=Linux#duration)

Length of time represented by an integer and a duration unit
(`1ns`, `1us`, `1µs`, `1ms`, `1s`, `1m`, `1h`, `1d`, `1w`).