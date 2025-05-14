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
  guard hasContent(attribute) else {
    return nil
  }

  return try extractDate(attribute)
}

///
/// - Parameter attribute: assumes the date is saved as ms
/// - Throws:
/// - Returns: Date
public func extractDate(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Date {
  guard let attribute else {
    throw ExtractAttributeError.attributeIsNull
  }

  return try extractDate(attribute)
}

///
/// - Parameter attribute: assumes the date is saved as ms
/// - Throws:
/// - Returns: Date
public func extractDate(_ attribute: DynamoDBClientTypes.AttributeValue) throws -> Date {
  let iso = try extractString(attribute)
  let newFormatter = ISO8601DateFormatter()
  let date = newFormatter.date(from: iso)
  guard let date else {
    throw ExtractAttributeError.invalidType
  }
  return date
}
