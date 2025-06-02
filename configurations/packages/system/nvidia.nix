{ config, pkgs, ...}:

{ 
    # Install vaapi driver
    environment.systemPackages = [ pkgs.unstable.nvidia-vaapi-driver ];    

    # Switch to unstable linux kernel to have latest nvidia drivers
    boot.kernelPackages = pkgs.unstable.linuxPackages;

    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true;
        };

        nvidia = {
            # Modesetting is required
            modesetting.enable = true;
          
            # Nvidia power management. Experimental, can cause sleep/suspend to fail.
            # Enable this if you have graphical corruption issues or application crashes after waking up from sleep.
            # This fixes it by saving the entire VRAM memory to /tmp/ instead of just the bare essentials.
            powerManagement.enable = false;

            # Fine-grained power management. Turns off GPU when not in use.
            # Experimental and only works on modern GPUs (Turing or newer)
            powerManagement.finegrained = false;

            # Enable to use the open source kernel module (not to be confused with the "nouveau" open source driver)
            # Supports Turing and later architectures. Only available from driver 515.43.04+
            # Currently in alpha-quality/buggy, so false is currently the recommanded setting.
            open = false;

            # Enable the settings menu accessible via `nvidia-settings`.
            nvidiaSettings = true;

            # Optionally, you may need to select the driver version for your GPU.
            package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
    };

    # Load driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    # Load kernel module
    boot.initrd.kernelModules = [ "nvidia" ];
    #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
}
