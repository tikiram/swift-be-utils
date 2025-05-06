import AWSDynamoDB

public func conditionalCheckFailed(_ error: TransactionCanceledException) -> Bool {

  let conditionalCheckFailed = error.properties.cancellationReasons?.contains { reason in
    return reason.code?.contains("ConditionalCheckFailed") ?? false
  }

  return conditionalCheckFailed ?? false
}

public func hasContent(_ attribute: DynamoDBClientTypes.AttributeValue) -> Bool {
  return !isContentNull(attribute)
}

public func isContentNull(_ attribute: DynamoDBClientTypes.AttributeValue) -> Bool {
  if case .null(let value) = attribute {
    return value
  }
  return false
}

