import AWSDynamoDB

public func extractOptionalDouble(_ attribute: DynamoDBClientTypes.AttributeValue?)
  throws -> Double?
{
  guard let attribute else {
    return nil
  }
  return try extractDouble(attribute)
}

public func extractDouble(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Double {
  guard let attribute else {
    throw ExtractAttributeError.attributeIsNull
  }
  return try extractDouble(attribute)
}

public func extractDouble(_ attribute: DynamoDBClientTypes.AttributeValue) throws -> Double {
  guard case .n(let text) = attribute else {
    throw ExtractAttributeError.invalidType
  }
  guard let value = Double(text) else {
    throw ExtractAttributeError.invalidDouble
  }
  return value
}
