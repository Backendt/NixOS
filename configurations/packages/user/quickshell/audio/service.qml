import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: service

    readonly property real step: 0.05 // Volume change per scroll tick

    // The default sink is null until Pipewire is ready, and its audio data is only
    // valid once the tracker below has bound it, hence all the null checks
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink?.ready === true && sink?.audio != null
    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready && sink.audio.muted

    readonly property string icon: {
        if (!ready) return "󰖁";
        if (muted || volume <= 0) return "󰝟";
        if (volume < 0.34) return "󰕿";
        if (volume < 0.67) return "󰖀";
        return "󰕾";
    }

    readonly property PwObjectTracker tracker: PwObjectTracker {
        objects: service.sink ? [service.sink] : []
    }

    function setVolume(value) {
        if (!ready) return;
        sink.audio.muted = false;
        sink.audio.volume = Math.max(0, Math.min(value, 1));
    }

    function toggleMute() {
        if (ready) sink.audio.muted = !sink.audio.muted;
    }
}
