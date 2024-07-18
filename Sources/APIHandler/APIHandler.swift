//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import Foundation
import OSLog
import BaseUtilities


public protocol APIResponse: Decodable, Sendable {}

public protocol APIRequestBody: Encodable, Sendable {}

public protocol APIUsage: Decodable, Sendable {}

public protocol StreamedResponse: Decodable, Sendable {
    var responseData: StreamedResponseMessage? { get }
    var usage: StreamedResponseUsage? { get }
}
public extension StreamedResponse {
    var responseData: StreamedResponseMessage? { nil }
    var usage: StreamedResponseUsage? { nil }
}

public protocol StreamedResponseMessage: Decodable, Sendable {
    var text: String? { get }
    var usage: StreamedResponseUsage? { get }
}
public extension StreamedResponseMessage {
    var text: String? { nil }
    var usage: StreamedResponseUsage? { nil }
}

public protocol StreamedResponseUsage: Decodable, Sendable {
    var input_tokens: Int? { get }
    var output_tokens: Int? { get }
}
public extension StreamedResponseMessage {
    var input_tokens: Int? { nil }
}

//@MainActor
//public protocol StreamedDataParser {
//    
//    associatedtype RequestBody: APIRequestBody
////    associatedtype Response: StreamedResponse
//    
//    func parseMessage<T: StreamedResponse>(_ message: String) throws -> T?
//}

@MainActor
public final class APIHandler: Sendable {

    public static func encodeBody<T: Encodable>(_ body: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(body)
            return jsonData
        } catch {
            print("Failed to encode request body: \(error)")
            return nil
        }
    }
    
    public static func makeRequest(
        url: URL?,
        headers: [String : String]
    ) throws -> URLRequest? {
        
        os_log("Let's make a URLRequest — no body needed, just url and headers")
        
        guard let url = url else {
            print("Invalid URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    public static func makeRequest<T: Encodable>(
        url: URL?,
        body: T,
        headers: [String : String]
    ) throws -> URLRequest? {
        
        os_log("Let's make a URLRequest, with a body")
        
        guard let url = url else {
            print("Invalid URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(body)
        request.httpBody = data
        
        os_log("""
        Request Body: \(request.httpBody?.debugDescription ?? "")
        """
        )
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    // MARK: - Generic API fetch
    /// Makes a network request — Does NOT decode the response
    public static func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        os_log("""
        
        "Going to fetch and return Decodable data, using supplied request.
        Request method: \(request.httpMethod?.debugDescription ?? "Can't get HTTP method")
        Request URL: \(request.url?.description ?? "Can't get URL")
        Request Body: \(request.httpBody?.debugDescription ?? "Can't get body")
        Request Headers: \(request.allHTTPHeaderFields?.prettyPrinted(keyPaths: [\.key, \.value]) ?? "No fields")
        """
        )
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Ensure the response is valid
            guard let httpResponse = response as? HTTPURLResponse else {
                os_log("Hmm, couldn't recognise the response as a typical `HTTPURLResponse`. Here it is anyway: \(response.debugDescription)")
                throw APIError.unknownStatusCode
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                print("Looks like the fetch request worked. This function will now send the raw data to be processed.")
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            case 400:
                print("Bad Request: \(data)")
                throw APIError.badRequest(data)
            default:
                print("Unknown status code: \(response.debugDescription)")
                throw APIError.otherError(URLError(.badServerResponse))
            }
        } catch let error as URLError {
            os_log("Got an error from a fetch")
            switch error.code {
            case .notConnectedToInternet,
                    .networkConnectionLost,
                    .dnsLookupFailed,
                    .cannotFindHost,
                    .cannotConnectToHost:
                
                throw APIError.noInternetConnection
            default:
                // Other URLError cases.
                throw APIError.otherError(error)
            }
        } catch {
            // Non-URLError cases.
            throw APIError.otherError(error)
        } // END do/catch
    } // END API fetch

}


public extension URLRequest {
    func printPrettyString() -> String {
        var requestComponents = [String: Any]()
        
        if let url = self.url {
            requestComponents["URL"] = url.absoluteString
        }
        
        if let method = self.httpMethod {
            requestComponents["Method"] = method
        }
        
        if let headers = self.allHTTPHeaderFields {
            requestComponents["Headers"] = headers
        }
        
        if let body = self.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            // Attempt to serialize JSON body to a readable JSON String
            if let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
               let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
               let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                requestComponents["Body"] = prettyPrintedString
            } else {
                // If body is not JSON or not decodable, print as a string
                requestComponents["Body"] = bodyString
            }
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestComponents, options: [.prettyPrinted]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return "Didn't work"
        }
    }
}



public enum APIError: Error, LocalizedError {
    
    case unknownStatusCode
    case badURL
    case badRequest(Data)
    case noInternetConnection
    
    //    case connectionError(Connection)
    
    case parsingError
    case decodingError(Error)
    
    case otherError(Error)
    //    case customError(String)
    
    public var errorDescription: String? {
        switch self {
            //        case .connectionError(let type):
            //            return "Connection error with \(type)"
        case .parsingError:
            return "Failed to parse data"
        case .otherError(let message):
            return message.localizedDescription
        default:
            return "Default error message"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
            //        case .connectionError:
            //            return "Check your internet connection and try again"
        case .parsingError:
            return "Please report this issue"
        case .otherError:
            return "Refer to detailed error message"
        default:
            return "Default recovery message"
        }
    }
}


public enum APIRequestType: String, Sendable, Codable {
    case get
    case post
    
    var value: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        }
    }
}

