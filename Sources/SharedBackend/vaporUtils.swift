import JWT
import Vapor

public final class AppUtils {

  private let app: Application

  public init(_ app: Application) {
    self.app = app
  }

  /// For some reason decode and encode strategy are different for the Date type
  /// with this configuration both have the same strategy `millisecondsSince1970`.
  /// Sets the key strategy to only use snakeCase on the json output
  public func setCompanyStandardJSONEncoderDecoder() {
    let encoder = getCompanyStandardJSONEncoder()
    ContentConfiguration.global.use(encoder: encoder, for: .json)
    let decoder = getCompanyStandardJSONDecoder()
    ContentConfiguration.global.use(decoder: decoder, for: .json)
  }

  /// Expects `CORS_ORIGINS` to be defined as an env variable with the list of valid origins
  public func configureCors() throws {
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

  /// Expects `PUBLIC_KEY` to be defined as a env variable, new lines characters should be escaped as `\n`
  public func configurePublicKey() async throws {
    guard let oneLinePublicKeyString = Environment.get("PUBLIC_KEY") else {
      throw RuntimeError("PUBLIC_KEY not defined")
    }

    let publicKeyString = oneLinePublicKeyString.replacingOccurrences(of: "\\n", with: "\n")
    
    // ECDSA - es256
    let publicKey = try ES256PublicKey(pem: publicKeyString)
    await app.jwt.keys.add(ecdsa: publicKey, kid: "public")
  }

  public func configurePrivateKey() async throws {
    guard let oneLinePrivateKeyString = Environment.get("PRIVATE_KEY") else {
      throw RuntimeError("PRIVATE_KEY not defined")
    }
    let privateKeyString = oneLinePrivateKeyString.replacingOccurrences(of: "\\n", with: "\n")
    
    // ECDSA - es256
    let privateKey = try ES256PrivateKey(pem: privateKeyString)
    await app.jwt.keys.add(ecdsa: privateKey, kid: "private")
  }

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
