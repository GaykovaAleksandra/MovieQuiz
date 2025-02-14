import Foundation

extension Date {
    var dateTimeString: String {
        return DateFormatter.defaultDateTime.string(from: self)
    }
}

extension DateFormatter {
    static var defaultDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy HH:mm"
        return formatter
    }()
}
