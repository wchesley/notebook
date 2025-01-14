[back](./README.md)

# Download and install InfluxDB v2

###### [reference docs](https://docs.influxdata.com/influxdb/v2/install/?t=Linux#install-influxdb-as-a-service-with-systemd)

*Recommended*: Before you open and install packages and downloaded files, use SHA
checksum verification and GPG signature verification to ensure the files are
intact and authentic.

InfluxDB installation instructions for some OS versions include steps to
verify downloaded files before you install them. See [Verify InfluxDb Repository](./Verify-InfluxDb.md). 

### [Install InfluxDB as a service with systemd](https://docs.influxdata.com/influxdb/v2/install/?t=Linux#install-influxdb-as-a-service-with-systemd)

1. [Choose the InfluxData key-pair for your OS version](https://docs.influxdata.com/influxdb/v2/install/?t=Linux#choose-the-influxdata-key-pair-for-your-os-version).
2. Run the command for your OS version to install the InfluxData key,
add the InfluxData repository, and install `influxdb`.
    
    *Before running the command, replace the checksum and key filename with the
    key-pair from the preceding step.*
    
    ```bash
    # Ubuntu and Debian
    # Add the InfluxData key to verify downloads and add the repository
    curl --silent --location -O \
    https://repos.influxdata.com/influxdata-archive.key
    echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
    | sha256sum --check - && cat influxdata-archive.key \
    | gpg --dearmor \
    | tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null \
    && echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
    | tee /etc/apt/sources.list.d/influxdata.list
    # Install influxdb
    sudo apt-get update && sudo apt-get install influxdb2
    
    ```
    
    ```bash
    # RedHat and CentOS
    # Add the InfluxData key to verify downloads
    curl --silent --location -O \
    https://repos.influxdata.com/influxdata-archive.key \
    && echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
    | sha256sum --check - && cat influxdata-archive.key \
    | gpg --dearmor \
    | tee /etc/pki/rpm-gpg/RPM-GPG-KEY-influxdata > /dev/null
    
    # Add the InfluxData repository to the repository list.
    cat <<EOF | tee /etc/yum.repos.d/influxdata.repo
    [influxdata]
    name = InfluxData Repository - Stable
    baseurl = https://repos.influxdata.com/stable/${basearch}/main
    enabled = 1
    gpgcheck = 1
    gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-influxdata
    EOF
    
    # Install influxdb
    sudo yum install influxdb2
    
    ```
    
3. Start the InfluxDB service:
    
    ```bash
    sudo service influxdb start
    
    ```
    
    Installing the InfluxDB package creates a service file at `/lib/systemd/system/influxdb.service`
    to start InfluxDB as a background service on startup.
    
4. To verify that the service is running correctly, restart your system and then enter the following command in your terminal:
    
    ```bash
    sudo service influxdb status
    
    ```
    
    If successful, the output is the following:
    
    ```
    ● influxdb.service - InfluxDB is an open-source, distributed, time series database
       Loaded: loaded (/lib/systemd/system/influxdb.service; enabled; vendor preset: enable>
       Active: active (running)
    
    ```
    

For information about where InfluxDB stores data on disk when running as a service,
see [File system layout](https://docs.influxdata.com/influxdb/v2/reference/internals/file-system-layout/?t=Linux#installed-as-a-package).

### [Pass configuration options to the service](https://docs.influxdata.com/influxdb/v2/install/?t=Linux#pass-configuration-options-to-the-service)

You can use systemd to customize [InfluxDB configuration options](https://docs.influxdata.com/influxdb/v2/reference/config-options/#configuration-options) and pass them to the InfluxDB service.

1. Edit the `/etc/default/influxdb2` service configuration file to assign configuration directives to `influxd` command line flags–for example, add one or more `<ENV_VARIABLE_NAME>=<COMMAND_LINE_FLAG>` lines like the following:
    
    ```
    ARG1="--http-bind-address :8087"
    ARG2="--storage-wal-fsync-delay=15m"
    
    ```
    
2. Edit the `/lib/systemd/system/influxdb.service` file to pass the variables to the `ExecStart` value:
    
    ```
    ExecStart=/usr/bin/influxd $ARG1 $ARG2
    
    ```
    

###