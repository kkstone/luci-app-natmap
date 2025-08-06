# LuCI App for NATMap (`luci-app-natmap`)

[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-19.07%2B-blue.svg)](https://openwrt.org/)

A LuCI web interface for the powerful `natmap` utility, allowing for easy configuration of Full-Cone NAT (NAT-1) port mapping directly from the OpenWrt web interface.

This application provides a user-friendly way to manage multiple `natmap` instances, monitor their status, and integrate custom scripts, without needing to access the command line.

## Overview

The core `natmap` tool by [heiher](https://github.com/heiher/natmap) is a command-line utility designed to establish and maintain port mappings on routers with Full-Cone NAT. This LuCI application provides a seamless graphical interface to configure and manage it.

The interface is divided into two main sections:
*   **Instance Running Status**: A live, auto-refreshing view of all active `natmap` instances, showing their real-time public IP and port mappings.
*   **NATMap Instances**: A configuration section to create, edit, and delete `natmap` instances with all their parameters.

## Features

*   **Full GUI Configuration**: Manage all `natmap` instances without touching configuration files.
*   **Multi-Instance Support**: Run multiple independent `natmap` processes for different ports and protocols.
*   **Live Status Monitoring**: An auto-refreshing status panel shows which instances are running and their mapped public IP/port.
*   **Robust Process Management**: Uses OpenWrt's `procd` to ensure `natmap` instances are started reliably and respawned on failure.
*   **Complete Parameter Support**: The interface supports all key `natmap` parameters, including:
    *   IP Family (`-4`, `-6`)
    *   Network Interface (`-i`)
    *   Keep-alive Interval (`-k`)
    *   Forwarding Mode (`-t`, `-p`)
*   **Custom Script Integration**: Easily specify a custom command or script to be executed upon a successful port mapping, with all `natmap` parameters passed directly to it.
*   **Internationalization (i18n)**: Supports multiple languages (English and Chinese included).

## Dependencies

*   An OpenWrt-based router.
*   The `natmap` binary must be installed. This package should list `natmap` as a dependency. You can find the original project here: [heiher/natmap](https://github.com/heiher/natmap).

## Installation

You can install `luci-app-natmap` in one of two ways.

### 1. From Pre-compiled Package (`.ipk`)

If you have a pre-compiled `.ipk` package, you can install it via the LuCI web interface or command line.

1.  Upload the `.ipk` file to your router's `/tmp` directory (using SCP or a tool like WinSCP).
2.  Connect to your router via SSH and run the following command:
    ```bash
    opkg install /tmp/luci-app-natmap_*.ipk
    ```
3.  The `natmap` package, if not already installed, should be installed automatically as a dependency.

### 2. Compiling from Source

To compile this application as part of your own OpenWrt build:

1.  Clone this repository into your OpenWrt build environment's `package` directory:
    ```bash
    cd <your-openwrt-buildroot>/package/
    git clone <this-repository-url> luci-app-natmap
    ```
2.  Run `make menuconfig` and navigate to `LuCI` -> `3. Applications` -> `luci-app-natmap`. Mark it with `<*>` to include it in your build.
3.  Run the build command: `make`

## Configuration

After installation, navigate to **Services -> NATMap** in the LuCI web interface.

### Instance Running Status

This section is at the top of the page and shows the real-time status of your enabled instances. It will automatically refresh every 5 seconds.

*   **Configuration Name**: The name of the instance section from the configuration below.
*   **Running Status**: Shows `● Running` for active processes.
*   **Public IP**: The mapped public IPv4 address. Will show `Getting...` until the mapping is established.
*   **Public Port**: The mapped public port.

### NATMap Instances

This is where you configure your `natmap` instances. Click "Add" to create a new one, or "Edit" to modify an existing one.

| Parameter                      | Description                                                                                                        |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| **Enabled**                    | A master switch to enable or disable this specific instance.                                                       |
| **Description**                | A user-friendly name for this instance (e.g., "Web Server Port").                                                  |
| **IP Family**                  | Choose whether to force IPv4 (`-4`) or IPv6 (`-6`), or leave it on Auto.                                             |
| **Network Interface**          | (Optional) Bind `natmap` to a specific network interface or IP address (`-i`).                                       |
| **Transport Protocol**         | The protocol to map: TCP or UDP (`-u`).                                                                            |
| **Local Bind Port**            | The local port or port range for `natmap` to use. Examples: `8080`, `9000-9100`. **(Required)**                        |
| **STUN Server**                | The address and port of the STUN server. Example: `stun.l.google.com:19302`. **(Required)**                        |
| **HTTP Keep-alive Server**     | The address and port of a public HTTP server to maintain the NAT session. Example: `www.google.com:80`. **(Required)** |
| **Keep-alive Interval**        | (Optional) Seconds between each keep-alive packet (`-k`).                                                          |
| **Forward Target Address**     | (Forward Mode Only) The internal IP/host to forward traffic to (`-t`).                                               |
| **Forward Target Port**        | (Forward Mode Only) The internal port to forward traffic to (`-p`).                                                |
| **Execute command on success** | (Optional) A custom command or script to run after a mapping is successful. All parameters from `natmap` (`$1`, `$2`, `$3`, etc.) will be passed directly to your script. Example: `/root/update_ddns.sh` |

After making changes, click **Save & Apply**. The `natmap` service will be restarted to apply the new configuration.

## Troubleshooting

If the "Instance Running Status" section shows "No running natmap instances" even after you've enabled a configuration, the `natmap` process likely failed to start.

The most common reason for failure is a misconfiguration or network issue. To diagnose the problem, check the system log for errors from `natmap`:

```bash
logread | grep natmap
```

This will show any error messages, such as failure to resolve a STUN server or inability to bind to a port.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

A big thank you to [heiher](https://github.com/heiher) for creating the powerful and efficient natmap utility that makes this all possible.
