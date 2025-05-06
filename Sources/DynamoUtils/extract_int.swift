import AWSDynamoDB

public func extractOptionalInt(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Int? {
  guard let attribute else {
    return nil
  }
  guard hasContent(attribute) else {
    return nil
  }
  return try extractInt(attribute)
}

public func extractInt(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Int {
  guard let attribute else {
    throw ExtractAttributeError.attributeIsNull
  }

  return try extractInt(attribute)
}

public func extractInt(_ attribute: DynamoDBClientTypes.AttributeValue) throws -> Int {
  guard case .n(let text) = attribute else {
    throw ExtractAttributeError.invalidType
  }

  guard let value = Int(text) else {
    throw ExtractAttributeError.invalidInt
  }

  return value
}
