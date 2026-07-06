{
    virtualisation = {
        virtualbox.host = {
            enable = true;
            enableExtensionPack = true;
        };
        libvirtd.enable = true;
    };
    programs.virt-manager.enable = true;
}
