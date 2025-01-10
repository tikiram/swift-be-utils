import AWSDynamoDB
import Foundation
import Vapor

extension Request {
  var dynamoDBClient: DynamoDBClient {
    get async throws {
      return try await DynamoDBClient()
    }
  }
  
  func getDynamoDbClient(region: String) throws -> DynamoDBClient {
    return try DynamoDBClient(region: region)
  }
}

public func getStringFromAttribute(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> String {
  guard let attribute else {
    throw RuntimeError("attribute is null")
  }
  guard case .s(let value) = attribute else {
    throw RuntimeError("invalid attribute")
  }
  return value
}

public func getIntFromAttribute(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Int {
  guard let attribute else {
    throw RuntimeError("attribute is null")
  }
  guard case .n(let text) = attribute else {
    throw RuntimeError("invalid attribute")
  }

  guard let value = Int(text) else {
    throw RuntimeError("attribute is not a valid Int")
  }

  return value
}

public func getDoubleFromAttribute(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Double {
  guard let attribute else {
    throw RuntimeError("attribute is null")
  }
  guard case .n(let text) = attribute else {
    throw RuntimeError("invalid attribute")
  }

  guard let value = Double(text) else {
    throw RuntimeError("attribute is not a valid Double")
  }

  return value
}

public func getDateFromAttribute(_ attribute: DynamoDBClientTypes.AttributeValue?) throws -> Date {
  // assumes the date is saved as ms
  let ms = try getDoubleFromAttribute(attribute)

  return Date(timeIntervalSince1970: TimeInterval(ms / 1000))
}
