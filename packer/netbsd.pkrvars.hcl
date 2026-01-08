name = "netbsd"
boot_command = [
  # Installation messages in English
  "<enter><wait5s>",
  # Keyboard type: unchanged
  "<enter><wait5s>",
  # Install NetBSD to hard disk
  "<enter><wait5s>",
  # Continue: Yes
  "<down><enter><wait5s>",
  # Available disk: Select default
  "<enter><wait5s>",
  # Guid Partition Table (GPT)
  "<enter><wait5s>",
  # This is the correct geometry
  "<enter><wait5s>",
  # Use default partition sizes
  "<down><enter><wait5s>",
  # Partition sizes ok
  "<enter><wait5s>",
  # Continue: Yes
  "<down><enter><wait5s>",
  # Use serial port com0 and continue
  "b<enter><wait5s>x<enter><wait5s>",
  # Installation without X11
  "<down><enter><wait5s>",
  # Install from CD-ROM / DVD / install image media
  "<enter><wait300s>",
  # Continue
  "<enter><wait5s>",
  # Set root password
  "packer<enter><wait5s>",
  # Set root password again
  "packer<enter><wait5s>",
  # Set root password again
  "packer<enter><wait5s>",
  # Skip 'cryptographically strong pseudo random' warning
  "x<enter><wait5s>",
  # Enable sshd
  "g<enter><wait5s>",
  # Finished configuring
  "x<enter><wait5s>",
  # Continue
  "<enter><wait5s>",
  # Reboot the computer
  "d<enter><wait180s>",
  # Login as a root
  "root<enter><wait5s>packer<enter><wait5s>",
  # Allow root username/password login
  "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config<enter><wait5s>",
  # Enable ipv4 network(ipv6 has problems with QEMU)
  "echo '/sbin/dhcpcd -4' > /etc/rc.local<enter><wait5s>",
  "reboot<enter>"
]
iso_checksum = "none"
iso_urls = [
  "NetBSD-10.1_latest-amd64.iso",
  "https://nycdn.netbsd.org/pub/NetBSD-daily/netbsd-10/latest/images/NetBSD-10.1_STABLE-amd64.iso"
]
output_file_name = "output/netbsd10-1.tar.gz"
vanilla_name = [ { name = "netbsd-vanilla" } ]
postgres_name = [ { name = "netbsd-postgres" } ]
