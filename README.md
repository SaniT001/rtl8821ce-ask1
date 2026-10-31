# Realtek RTL8821CE — ASK1

**Experimental Linux Wi-Fi driver with UBSAN fixes.**

> [!WARNING]
> This is a testing version, not a stable release.
> Use at your own risk. Keep a working fallback kernel
> or another way to restore network connectivity.

## Overview

RTL8821CE ASK1 is a modified version of the Realtek RTL8821CE
out-of-tree Linux Wi-Fi driver.

The project focuses on fixing memory-boundary issues reported
by the Linux kernel's Undefined Behavior Sanitizer (UBSAN).

This is an independent community modification.

## Version

- Driver base: v5.5.2_34066.20200325
- DKMS version: v5.5.2_34066.20200325-ask1
- Development status: Testing
- Kernel module: 8821ce

## Changes in ASK1

The initial version introduces defensive checks and fixes
related to out-of-bounds memory access.

Modified source files:

- os_dep/linux/ioctl_cfg80211.c
- core/rtw_wlan_util.c
- core/rtw_mlme_ext.c
- core/rtw_ap.c

The original driver architecture has been retained.

## Tested Environment

- Distribution: Linux Mint 22.3
- Hardware: Realtek RTL8821CE (PCI ID 10ec:c821)
- Kernel: 7.0.0-42-generic
- Build system: DKMS 3.0.11

The driver was successfully compiled, installed and loaded.
Wi-Fi connectivity was confirmed after reboot.

A preliminary 10-minute workload test showed no UBSAN
warnings while the modified driver was loaded.

Extended stability testing is still in progress.

## Kernel Compatibility

The driver was successfully built for:

- Linux 7.0.0-38-generic
- Linux 7.0.0-42-generic

Runtime testing has been performed on 7.0.0-42-generic.
Compatibility with other kernels is not guaranteed.

## Installation Status

The DKMS installation and removal scripts are experimental.

They have passed Bash syntax checks but have not yet been
validated as a complete installation workflow on a clean system.

The installer intentionally refuses to replace an existing
RTL8821CE installation automatically.

Automatic installation for future kernels is currently disabled
in dkms.conf:

AUTOINSTALL="NO"

Please do not assume that updating the kernel will automatically
install this driver.

## Known Limitations

- Extended stability testing is incomplete.
- Automatic DKMS updates are not configured.
- Compatibility with other Linux distributions is unverified.
- Secure Boot configurations may require additional setup.
- Installation over another RTL8821CE version requires care.

## Original Project and Credits

Based on the Realtek RTL8821CE driver maintained by
Tomás Pinho and other contributors.

Original repository:
https://github.com/tomaspinho/rtl8821ce

Original copyright notices are retained in the source files.

This project is not affiliated with or endorsed by Realtek.

## License

GNU General Public License, version 2 (GPLv2).

See the COPYING file and original source notices.

## Project Status

ASK1 is an experimental release.

Additional fixes, testing results and documentation
will be published as development continues.
