import AWSDynamoDB

public func extractOptionalBool(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Bool? {
  guard let attribute else {
    return nil
  }
  guard hasContent(attribute) else {
    return nil
  }
  return try extractBool(attribute)
}

public func extractBool(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Bool {
  guard let attribute else {
    throw ExtractAttributeError.attributeIsNull
  }
  return try extractBool(attribute)
}

public func extractBool(_ attribute: DynamoDBClientTypes.AttributeValue) throws -> Bool {
  guard case .bool(let value) = attribute else {
    throw ExtractAttributeError.invalidType
  }
  return value
}
