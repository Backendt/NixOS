{ pkgs, ... }:

{
    # Set microphone as mono input
    services.pipewire.wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-mono-microphone.conf" ''
            monitor.alsa.rules = [
                {
                    matches = [
                        {
                            node.name = "~alsa_input.*"
                        }
                    ]
                    actions = {
                        update-props = {
                            audio.position = "MONO"
                            audio.channels = "1"
                            node.description = "PCM2902 Audio Codec Analog Mono"
                        }
                    }
                }
            ]
          '')
    ];
}
