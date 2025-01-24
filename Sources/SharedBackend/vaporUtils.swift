
import Vapor

/// For some reason decode and encode strategy are different for the Date type
/// with this configuration both have the same strategy `millisecondsSince1970`.
/// Sets the key strategy to only use snakeCase on the json output
public func setVaporWithCompanyStandardJSONEncoderDecoder() {
  let encoder = getCompanyStandardJSONEncoder()
  ContentConfiguration.global.use(encoder: encoder, for: .json)
  let decoder = getCompanyStandardJSONDecoder()
  ContentConfiguration.global.use(decoder: decoder, for: .json)
}

public func getCompanyStandardJSONEncoder() -> JSONEncoder {
  let encoder = JSONEncoder()
  encoder.dateEncodingStrategy = .millisecondsSince1970
  encoder.keyEncodingStrategy = .convertToSnakeCase
  return encoder
}

public func getCompanyStandardJSONDecoder() -> JSONDecoder {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .millisecondsSince1970
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  return decoder
}

extension Request {
  public var environmentShortName: String {
    get throws {
      switch self.application.environment {
      case .production:
        return "prod"
      case .development:
        return "dev"
      case .testing:
        return "test"
      default:
        throw RuntimeError("env not supported")
      }
    }
  }
}

/// Expects `CORS_ORIGINS` to be defined as an env variable with the list of valid origins
public func configureCors(_ app: Application) throws {
  guard let corsOriginsString = Environment.get("CORS_ORIGINS") else {
    throw RuntimeError("CORS_ORIGINS not defined")
  }
  let origins = corsOriginsString.split(separator: ",").map({ $0.trim() })
  
  let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .any(origins),
    allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
    allowedHeaders: [
      .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
      .accessControlAllowOrigin, .setCookie, .setCookie2,
    ],
    allowCredentials: true
  )
  let cors = CORSMiddleware(configuration: corsConfiguration)
  // cors middleware should come before default error middleware using `at: .beginning`
  app.middleware.use(cors, at: .beginning)
}
