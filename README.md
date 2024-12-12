# nixos

run `nix flake lock ` to create flake.lock

if you need to override experimental features `nix --extra-experimental-features 'nix-command flakes' flake lock`

to install **IMPORTANT must run in the same directory as flake.nix file**
`nix --extra-experimental-features 'nix-command flakes' run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake .#generic <user>@<ip>`

to search for packages
nix search nixpkgs <package>

to rebuild packages **IMPORTANT: this assumes you copied the config files to the /etc/nixos file manually. alternatively, use should be done with remote deployment rather than trying to use a git repository**
`sudo nixos-rebuild switch --flake /etc/nixos`
must regenerate the hardware config
`nixos-generate-config`

# Notes

use a deployment method of pushing the file to the system rather than using a remote repository because caching makes it unreliable, and can't write to flake.lock in a remote repo

**Ensure you are running in rescue mode on hetzner**

**If you installed a previous system with raid**

stop all raid arrays
```
mdadm -S --scan
```
purge the drives
```
diskOne=sda
diskTwo=sdb
#diskOne=nvme0n1
#diskTwo=nvme1n1
# Wipe the first 1024MB
dd if=/dev/zero of=/dev/${diskOne} bs=1M count=1024
dd if=/dev/zero of=/dev/${diskTwo} bs=1M count=1024
# Wipe the last 1024MB
start_mb=$(( $(blockdev --getsize64 /dev/${diskOne}) / 1048576 - 1024 ))
dd if=/dev/zero of=/dev/${diskOne} bs=1M seek=$start_mb count=1024
start_mb=$(( $(blockdev --getsize64 /dev/${diskTwo}) / 1048576 - 1024 ))
dd if=/dev/zero of=/dev/${diskTwo} bs=1M seek=$start_mb count=1024

```
remove config file `rm /etc/mdadm/mdadm.conf`

repartition the drives
```
parted /dev/sda mklabel gpt mkpart primary ext4 0% 100%
parted /dev/sdb mklabel gpt mkpart primary ext4 0% 100%
```

reboot into rescue linux again

run install command
