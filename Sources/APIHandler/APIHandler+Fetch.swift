//
//  APIHandler+Fetch.swift
//  Collection
//
//  Created by Dave Coleman on 16/1/2025.
//

import Foundation

extension APIHandler {

  public static func requestAndFetch<T: Decodable>(
    url: URL?,
    body: (any Encodable)? = nil,
    headers: [String: String] = [:],
    dto: T.Type,
    isDebugMode: Bool = false
  ) async throws -> T {

    if isDebugMode {

      print(
        """

        /// Request & Fetch ///

        DTO: \(dto)

        # Request
        URL: \(url?.absoluteString ?? "nil")
        Body: \(body ?? "nil")
        Headers: \(headers.prettyPrinted())

        """)
    }

    let request = try createRequest(
      url: url,
      body: body,
      headers: headers
    )
    let response: T = try await fetch(
      request: request,
      isDebugMode: isDebugMode
    )

    print(
      """

      # Fetched Response
        
        

      """)

    return response
  }

  // MARK: - Generic API fetch
  /// Makes a network request — Does NOT decode the response
  public static func fetch<T: Decodable>(
    request: URLRequest,
    /// This produces more verbose print statements
    isDebugMode: Bool = false
  ) async throws -> T {

    do {

      let (data, response) = try await URLSession.shared.data(for: request)

      /// Ensure the response is valid
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse(response.debugDescription)
      }

      try checkContentTypeIsJSON(data: data, response: response)
      

      switch httpResponse.statusCode {
        case 200 ... 299:

          print(
            "Looks like the fetch request worked. This function will now send the raw data to be processed."
          )
          do {
            // Pretty print the raw response data for debugging
            if isDebugMode {
              do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(
                  withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
                let prettyString = String(data: prettyData, encoding: .utf8)
                print("Raw response data:\n\(prettyString ?? "Couldn't pretty print JSON")")

              } catch {
                // Fallback to raw string if JSON parsing fails
                if let responseString = String(data: data, encoding: .utf8) {
                  print("Raw response data (not valid JSON):\n\(responseString)")
                }
              }
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase  // If needed

            do {
              return try decoder.decode(T.self, from: data)
            } catch let decodingError as DecodingError {
              switch decodingError {
                case .dataCorrupted(let context):
                  print(
                    """
                    DTO: \(T.self)
                    Data corrupted error:
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    Underlying error: \(String(describing: context.underlyingError))
                    Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
                    """)

                case .keyNotFound(let key, let context):
                  print(
                    """
                    DTO: \(T.self)
                    Key not found error:
                    Missing key: \(key.stringValue)
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    """)

                case .typeMismatch(let type, let context):
                  print(
                    """
                    DTO: \(T.self)
                    Type mismatch error:
                    Expected type: \(type)
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    """)

                case .valueNotFound(let type, let context):
                  print(
                    """
                    DTO: \(T.self)
                    Value not found error:
                    Expected type: \(type)
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    """)

                @unknown default:
                  print("Unknown decoding error: \(decodingError)")
              }
              throw APIError.decodingError(decodingError)
            }
          } catch {
            print("Unexpected error during decoding: \(error)")
            throw APIError.decodingError(error)
          }

        //
        //          print("Looks like the fetch request worked. This function will now send the raw data to be processed.")
        //          do {
        //            let decoder = JSONDecoder()
        //            return try decoder.decode(T.self, from: data)
        //          } catch {
        //            print("Decoding error: \(error)")
        //            throw APIError.decodingError(error)
        //          }
        //


        //          return try handleSuccessfulResponse(data: data, isDebugMode: isDebugMode)

        case 400:
          print("Bad Request: \(String(data: data, encoding: .utf8) ?? "")")
          throw APIError.badRequest(data)
        case 401:
          throw APIError.unauthorized(httpResponse.description)
        case 403:
          throw APIError.forbidden
        case 404:
          throw APIError.notFound
        case 500 ... 599:
          throw APIError.serverError(httpResponse.statusCode)
        default:
          print("Unknown status code: \(httpResponse.statusCode)")
          throw APIError.unknownStatusCode(httpResponse.statusCode)
      }
    } catch let apiError as APIError {
      throw apiError
    } catch {
      throw APIError.otherError(error)
    }
  }  // END API fetch


  static func checkContentTypeIsJSON(
    data: Data,
    response: URLResponse
  ) throws {

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.couldNotCastAsHTTPURLResponse
    }
    
    guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
      throw APIError.couldNotGetContentTypeHeader
    }

    guard contentType.contains("application/json") else {
      print(printNonJSONData(data: data))
      throw APIError.invalidContentType(contentType)
    }
  }

  static func printNonJSONData(data: Data) -> String {
    guard let dataAsString = String(data: data, encoding: .utf8) else {
      return "nil"
    }
    return dataAsString
  }

  //  static func handleSuccessfulResponse<T: Decodable>(
  //    data: Data,
  //    isDebugMode: Bool
  //  ) throws -> T {
  //    print(
  //      "Looks like the fetch request worked. This function will now send the raw data to be processed."
  //    )
  //
  //    if isDebugMode {
  //
  //      do {
  //        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
  //        let prettyData = try JSONSerialization.data(
  //          withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
  //        let prettyString = String(data: prettyData, encoding: .utf8)
  //        print("Raw response data:\n\(prettyString ?? "Couldn't pretty print JSON")")
  //
  //      } catch {
  //        // Fallback to raw string if JSON parsing fails
  //        if let responseString = String(data: data, encoding: .utf8) {
  //          print("Raw response data (not valid JSON):\n\(responseString)")
  //        }
  //        throw
  //      }
  //
  //      return try decodeResponse(data)
  //
  //    } else {
  //
  //      return try decodeResponse(data)
  //    }
  //
  //  }
  //
  //
  //  static func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
  //
  //    do {
  //      let decoder = JSONDecoder()
  //      return try decoder.decode(T.self, from: data)
  //
  //    } catch let decodingError as DecodingError {
  //      switch decodingError {
  //        case .dataCorrupted(let context):
  //          print(
  //            """
  //            DTO: \(T.self)
  //            Data corrupted error:
  //            Debug description: \(context.debugDescription)
  //            Coding path: \(context.codingPath)
  //            Underlying error: \(String(describing: context.underlyingError))
  //            Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
  //            """)
  //
  //        case .keyNotFound(let key, let context):
  //          print(
  //            """
  //            DTO: \(T.self)
  //            Key not found error:
  //            Missing key: \(key.stringValue)
  //            Debug description: \(context.debugDescription)
  //            Coding path: \(context.codingPath)
  //            """)
  //
  //        case .typeMismatch(let type, let context):
  //          print(
  //            """
  //            DTO: \(T.self)
  //            Type mismatch error:
  //            Expected type: \(type)
  //            Debug description: \(context.debugDescription)
  //            Coding path: \(context.codingPath)
  //            """)
  //
  //        case .valueNotFound(let type, let context):
  //          print(
  //            """
  //            DTO: \(T.self)
  //            Value not found error:
  //            Expected type: \(type)
  //            Debug description: \(context.debugDescription)
  //            Coding path: \(context.codingPath)
  //            """)
  //
  //        @unknown default:
  //          print("Unknown decoding error: \(decodingError)")
  //      }
  //    } catch {
  //      print("Unexpected error during decoding: \(error)")
  //      throw APIError.decodingError(error)
  //    }
  //  }

}
