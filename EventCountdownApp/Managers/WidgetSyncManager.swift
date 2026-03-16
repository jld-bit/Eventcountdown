import Foundation
import WidgetKit

struct WidgetSyncManager {
    static let appGroupID = "group.com.eventcountdown.shared"
    static let keyTitle = "widget_next_title"
    static let keyDate = "widget_next_date"
    static let keyColorHex = "widget_next_color"

    static func sync(upcomingEvent: EventItem?) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }

        if let upcomingEvent {
            defaults.set(upcomingEvent.title, forKey: keyTitle)
            defaults.set(upcomingEvent.date.timeIntervalSince1970, forKey: keyDate)
            defaults.set(upcomingEvent.colorHex, forKey: keyColorHex)
        } else {
            defaults.removeObject(forKey: keyTitle)
            defaults.removeObject(forKey: keyDate)
            defaults.removeObject(forKey: keyColorHex)
        }

        WidgetCenter.shared.reloadAllTimelines()
    }
}
