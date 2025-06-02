{ pkgs, ... }:

{
    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server

        extraCompatPackages = [ pkgs.proton-ge-bin ];

        #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        #localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
        r2modman # Unity modding
        prismlauncher # Minecraft launcher
        dotnet-sdk_8 # tModLoader dependency
    ];
}

