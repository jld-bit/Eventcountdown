import Foundation
import CoreData

@objc(EventItem)
public final class EventItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventItem> {
        NSFetchRequest<EventItem>(entityName: "EventItem")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var createdAt: Date
    @NSManaged public var colorHex: String

    var isUpcoming: Bool {
        date > Date()
    }

    var countdownComponents: DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: date)
    }
}
