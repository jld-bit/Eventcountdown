# Event Countdown (SwiftUI iOS App)

Event Countdown is an original SwiftUI iOS app for creating personal event countdowns with colorful cards, large countdown numbers, local Core Data persistence, reminder notifications, and a home screen widget.

## Features
- Create events with title + date.
- Live countdown display in days, hours, and minutes.
- Event list with colorful cards.
- Local notifications for upcoming events.
- Widget showing your nearest event.
- In-App Purchases:
  - `com.eventcountdown.unlimitedevents` unlocks unlimited events.
  - `com.eventcountdown.widgetthemes` unlocks premium widget themes.

## Architecture
- **SwiftUI** for UI.
- **Core Data** for local storage (programmatic Core Data model, no `.xcdatamodeld` required).
- **UserNotifications** for reminders.
- **StoreKit 2** for monetization.
- **WidgetKit** for home screen widgets.

## Notes
- This implementation uses unique naming, structure, and visual design to avoid copying existing countdown apps.
- To run on device, configure:
  - Bundle IDs for app and widget.
  - App Group capability (shared between app + widget).
  - In-App Purchase products in App Store Connect.
  - Notification permissions and signing.
