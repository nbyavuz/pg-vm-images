variable "bucket" { type = string }
variable "gcp_project" { type = string }
variable "image_date" { type = string }
variable "image_name" { type = string }

variable "prefix" {
  type = string
  default = ""
}

source "qemu" "qemu-gce-builder" {

  boot_command            = [
    "S<enter><wait>",
    "cat <<EOF >>install.conf<enter>",
    "System hostname = openbsd70<enter>",
    "Password for root = packer<enter>",
    "Allow root ssh login = yes<enter>",
    "What timezone are you in = Etc/UTC<enter>",
    "Do you expect to run the X Window System = no<enter>",
    "Set name(s) = -man* -game* -x*<enter>",
    "Directory does not contain SHA256.sig. Continue without verification = yes<enter>",
    "EOF<enter>",
    "install -af install.conf && reboot<enter>"
    ]

  boot_wait               = "120s"
  cpus                    = 2
  disk_size               = 25600
  memory                  = 1024
  headless                = true
  iso_checksum            = "sha256:d3a7c5b9bf890bc404304a1c96f9ee72e1d9bbcf9cc849c1133bdb0d67843396"
  iso_urls                = [
    "install70.iso",
    "https://cdn.openbsd.org/pub/OpenBSD/7.1/amd64/install71.iso"
    ]
  shutdown_command        = "halt -p"
  ssh_username            = "root"
  ssh_password            = "packer"
  ssh_port                = 22
  ssh_wait_timeout        = "900s"
  format                  = "raw"
  vm_name                 = "disk.raw"
  output_directory        = "output"
}

build {
  name="openbsd-vanilla"
  sources = ["source.qemu.qemu-gce-builder"]

  provisioner "shell" {
    script = "scripts/bsd/openbsd-prep-gce.sh"
  }

  provisioner "file" {
    source = "files/bsd/rc.local.sh"
    destination = "/etc/rc.local"
  }

  provisioner "file" {
    source = "files/bsd/rc.shutdown.sh"
    destination = "/etc/rc.shutdown"
  }

  provisioner "shell" {
    inline = ["chmod 744 /etc/rc.local && chmod 744 /etc/rc.shutdown"]
  }

  # clear ssh keys
  provisioner "shell" {
    inline = ["rm -rf /home/* && rm -rf /root/.ssh/"]
  } 

  post-processors {
    post-processor "compress" {
      output = "output/openbsd71.tar.gz"
    }

    post-processor "googlecompute-import" {
      gcs_object_name   = "packer-${var.image_name}-${var.image_date}.tar.gz"
      bucket            = "${var.bucket}"
      image_family      = "pg-ci-${var.image_name}"
      image_name        = "${var.prefix}pg-ci-${var.image_name}-${var.image_date}"
      project_id        = "${var.gcp_project}"
    }
  }
}