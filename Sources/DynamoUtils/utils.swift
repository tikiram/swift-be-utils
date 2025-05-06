import AWSDynamoDB

public func conditionalCheckFailed(_ error: TransactionCanceledException) -> Bool {

  let conditionalCheckFailed = error.properties.cancellationReasons?.contains { reason in
    return reason.code?.contains("ConditionalCheckFailed") ?? false
  }

  return conditionalCheckFailed ?? false
}
