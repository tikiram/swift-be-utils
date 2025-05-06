import AWSDynamoDB
import Foundation

public func toDynamoValue(_ string: String?) -> DynamoDBClientTypes.AttributeValue {
  guard let string else {
    return .null(true)
  }
  return .s(string)
}

public func toDynamoValue(_ bool: Bool?) -> DynamoDBClientTypes.AttributeValue {
  guard let bool else {
    return .null(true)
  }
  return .bool(bool)
}

public func toDynamoValue(_ int: Int?) -> DynamoDBClientTypes.AttributeValue {
  guard let int else {
    return .null(true)
  }
  return .n(int.description)
}

public func toDynamoValue(_ value: Double?) -> DynamoDBClientTypes.AttributeValue {
  guard let value else {
    return .null(true)
  }
  return .n(value.description)
}

public func toDynamoValue(_ date: Date?) -> DynamoDBClientTypes.AttributeValue {
  guard let date else {
    return .null(true)
  }
  return .n((date.timeIntervalSince1970 * 1000).description)
}
