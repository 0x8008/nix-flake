{ config, pkgs, lib, ... }:

let
  # Patched EDK2 — AutoVirt AMD patch applied on top of edk2-stable202602
  patchedEdk2 = pkgs.edk2.overrideAttrs (old: {
    patches = (old.patches or []) ++ [ ../../edk2.patch ];
  });

  # Patched OVMF built from the patched EDK2
  patchedOVMF = pkgs.OVMF.override {
    edk2 = patchedEdk2;
    secureBoot = true;
  };

in
{
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" ];

      qemu = {
        package = pkgs.qemu_kvm.overrideAttrs (old: {
          patches = (old.patches or []) ++ [ ../../qemu.patch ];
          postPatch = (old.postPatch or "") + ''
            # kvm-pv-enforce-cpuid: force GP fault on KVM paravirtual MSR reads
            sed -i '/kvm-pv-enforce-cpuid/{n;s/false)/true)/}' target/i386/cpu.c
            # FEAT_6_ECX: add adjust_feat_level call after FEAT_6_EAX
            sed -i '/x86_cpu_adjust_feat_level.*FEAT_6_EAX/a\        x86_cpu_adjust_feat_level(cpu, FEAT_6_ECX);' target/i386/cpu.c
          '';
          # Replace stock OVMF firmware symlinks with patched EDK2 builds
          postInstall = (old.postInstall or "") + ''
            ln -sf ${patchedOVMF.fd}/FV/OVMF_CODE.fd $out/share/qemu/edk2-x86_64-secure-code.fd
            ln -sf ${patchedOVMF.fd}/FV/OVMF_CODE.fd $out/share/qemu/edk2-x86_64-code.fd
            ln -sf ${patchedOVMF.fd}/FV/OVMF_VARS.fd $out/share/qemu/edk2-i386-vars.fd
          '';
        });
        runAsRoot = true;
        swtpm.enable = true;
      };
      hooks.qemu = {
        "vfio-passthrough" = pkgs.writeShellScript "vfio-passthrough" ''
          GUEST_NAME="$1"
          OPERATION="$2"
          SUB_OPERATION="$3"

          if [ "$GUEST_NAME" != "win11" ]; then exit 0; fi

          if [ "$OPERATION" == "prepare" ] && [ "$SUB_OPERATION" == "begin" ]; then
            systemctl stop display-manager.service

            echo 0 > /sys/class/vtconsole/vtcon0/bind || true
            echo 0 > /sys/class/vtconsole/vtcon1/bind || true
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true

            sleep 5

            modprobe -r amdgpu || true
            modprobe -r snd_hda_intel || true
            modprobe vfio_pci
            modprobe vfio_iommu_type1
          fi

          if [ "$OPERATION" == "release" ] && [ "$SUB_OPERATION" == "end" ]; then
            modprobe -r vfio_pci
            modprobe -r vfio_iommu_type1

            modprobe amdgpu
            modprobe snd_hda_intel || true

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
    acpica-tools  # for recompiling .dsl tables if needed
  ];
}
