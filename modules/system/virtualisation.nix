{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm.overrideAttrs (old: {
          patches = (old.patches or []) ++ [ ../../qemu.patch ];
        });
        runAsRoot = true;
        swtpm.enable = true;
      };
      hooks.qemu = {
        "vfio-passthrough" = pkgs.writeShellScript "vfio-passthrough" ''
          GUEST_NAME="$1"
          OPERATION="$2"
          SUB_OPERATION="$3"

          if [ "$GUEST_NAME" != "win11fdsgfdgdsdhgghf" ]; then exit 0; fi

          if [ "$OPERATION" == "prepare" ] && [ "$SUB_OPERATION" == "begin" ]; then
            systemctl stop display-manager.service
            
            echo 0 > /sys/class/vtconsole/vtcon0/bind || true
            echo 0 > /sys/class/vtconsole/vtcon1/bind || true
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true
            
            sleep 2
            
            modprobe -r amdgpu
            modprobe vfio_pci
            modprobe vfio_iommu_type1
          fi

          if [ "$OPERATION" == "release" ] && [ "$SUB_OPERATION" == "end" ]; then
            modprobe -r vfio_pci
            modprobe -r vfio_iommu_type1
            
            modprobe amdgpu
            
            echo 1 > /sys/class/vtconsole/vtcon0/bind || true
            echo 1 > /sys/class/vtconsole/vtcon1/bind || true
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind || true
            
            systemctl start display-manager.service
          fi
        '';
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    virtio-win
    win-spice
  ];
}
