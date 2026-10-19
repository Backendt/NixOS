import QtQuick
import Quickshell
import Quickshell.Services.Notifications

QtObject {
    id: service

    readonly property int defaultTimeout: 5000 // In milliseconds

    property bool centerOpen: false
    property var popups: []
    property var receivedAt: ({})

    readonly property var list: server.trackedNotifications.values
    readonly property int count: list.length

    readonly property NotificationServer server: NotificationServer {
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true;
            service.receivedAt[notif.id] = new Date();
            notif.closed.connect(() => service.removePopup(notif));
            if (!service.centerOpen)
                service.popups = [notif, ...service.popups];
        }
    }

    function removePopup(notif) {
        popups = popups.filter(n => n !== notif);
    }

    // -1 means "server default", 0 means "never"
    function timeoutFor(notif) {
        if (notif.urgency === NotificationUrgency.Critical || notif.expireTimeout === 0)
            return 0;
        return notif.expireTimeout > 0 ? notif.expireTimeout * 1000 : defaultTimeout;
    }

    function toggleCenter() {
        centerOpen = !centerOpen;
        if (centerOpen)
            popups = [];
    }

    function clearAll() {
        list.slice().forEach(n => n.dismiss());
    }
}
