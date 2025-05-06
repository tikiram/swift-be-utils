import AWSDynamoDB

public func extractOptionalString(_ attribute: DynamoDBClientTypes.AttributeValue?)
  throws -> String?
{
  guard let attribute else {
    return nil
  }
  guard hasContent(attribute) else {
    return nil
  }
  return try extractString(attribute)

}

public func extractString(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> String {
  guard let attribute else {
    throw ExtractAttributeError.attributeIsNull
  }
  return try extractString(attribute)
}

public func extractString(_ attribute: DynamoDBClientTypes.AttributeValue) throws -> String {
  guard case .s(let value) = attribute else {
    throw ExtractAttributeError.invalidType
  }
  return value
}
