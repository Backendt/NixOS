import QtQuick
import Quickshell.Services.Pipewire

Text {
    font.pointSize: root.fontSize
    font.family: root.fontFamily
    
    color: {
        let sink = pw.objects[0];
        if(sink && sink.audio && sink.audio.muted)
            return theme.base08
        return theme.base05
    }
    text: {
        let sink = pw.objects[0];
        if (sink === undefined || sink.audio === undefined)
            return "󰖁"
        let vol = Math.round(sink.audio.volume * 100)
        if(sink.audio.muted) {
            return "󰝟 0%";
        }
        return "󰕾 " + vol + "%";
    }

    PwObjectTracker {
        id: pw
        objects: [ Pipewire.defaultAudioSink ]
    }
}
