import AWSDynamoDB
import Foundation

///
/// - Parameter attribute: assumes the date is saved as ms
/// - Throws:
/// - Returns: Date
public func extractOptionalDate(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Date? {

  guard let attribute else {
    return nil
  }

  let ms = try extractDouble(attribute)

  return Date(timeIntervalSince1970: TimeInterval(ms / 1000))
}

///
/// - Parameter attribute: assumes the date is saved as ms
/// - Throws:
/// - Returns: Date
public func extractDate(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Date {
  guard let attribute else {
    throw ExtractAttributeError.attributeIsNull
  }

  let ms = try extractDouble(attribute)
  return Date(timeIntervalSince1970: TimeInterval(ms / 1000))
}

///
/// - Parameter attribute: assumes the date is saved as ms
/// - Throws:
/// - Returns: Date
public func extractDate(_ attribute: DynamoDBClientTypes.AttributeValue) throws -> Date {
  let ms = try extractDouble(attribute)

  return Date(timeIntervalSince1970: TimeInterval(ms / 1000))
}
