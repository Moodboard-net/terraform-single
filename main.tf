terraform {
  required_providers {
    proxmox = {
      source = "Terraform-for-Proxmox/proxmox"
      version = "0.0.1"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "vm" {
  vmid = 120
  name = "demo-vm"
  target_node = "vm"

  clone = "ubuntu-noble"
  full_clone = true

  os_type = "cloud-init"
  cloudinit_cdrom_storage = "local-lvm"

  ciuser = var.ci_user
  cipassword = var.ci_password

  cores = 1
  vcpus = 1
  memory = 1024
  agent = 1

  bootdisk = "scsi0"
  scsihw = "virtio-scsi-pci"
  ipconfig0 = "ip=dhcp"

  disk {
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [ 
        network
     ]
  }
}