
import Foundation

extension Date {
  public var millisecondsSince1970: Double {
    return timeIntervalSince1970 * 1000
  }
}
