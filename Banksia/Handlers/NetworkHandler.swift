//
//  APIHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation

enum KeychainError: Error {
    case couldNotFindItem
}


extension BanksiaHandler {
    
    
    func fetchGPTResponse<T: Decodable>(prompt: String) async throws -> T {
        
        isResponseLoading = true
        
//        guard let apiKey = KeychainHandler.get(forKey: "OpenAIKey") else {
//            print("Couldn't get the api key from keychain")
//            throw KeychainError.couldNotFindItem
//        }
        
        print("Let's fetch a response from GPT")
        
        let requestBody = RequestBody(
            model: pref.gptModel.value,
            messages: [
                RequestMessage(role: "system", content: pref.systemPrompt),
                RequestMessage(role: "user", content: prompt)
            ],
            temperature: pref.gptTemperature
        )
        
        let request = try makeURLRequest(from: OpenAI.chatURL, requestType: .post, bearerToken: "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", body: requestBody)
        
        print("Request: '\(request)'")
        
        let decoder = JSONDecoder()
        
        let data = try await fetch(request: request)
        
        isResponseLoading = false
        
        return try decoder.decode(T.self, from: data)
    }
    
    func makeURLRequest(from urlString: String, requestType: APIRequestType = .get, clientID: String? = nil, bearerToken: String? = nil, body: RequestBody? = nil) throws -> URLRequest {
        print("Let's create a valid URLRequest for url: '\(urlString)', of type: '\(requestType.rawValue)', with body: \(String(describing: body))")
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        if let clientID = clientID {
            request.addValue(clientID, forHTTPHeaderField: "Client-ID")
        }
        if let bearerToken = bearerToken {
            request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            request.httpBody = bodyData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    // MARK: - Generic API fetch
    /// Makes a network request and decodes the JSON response
    func fetch(request: URLRequest) async throws -> Data {
        print("Going to fetch and return data for request '\(request)'")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Ensure the response is valid
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknownStatusCode
            }
            
            print("Reponse: \(httpResponse)")
            
            switch httpResponse.statusCode {
            case 200...299:
                print("Looks like the fetch request worked. This function will now send the raw data to be processed.")
                return data
            case 400:
                print("Bad Request: \(data.debugDescription)")
                throw APIError.badRequest(data)
            default:
                print("Unknown status code")
                throw APIError.otherError(URLError(.badServerResponse))
            }
        } catch let error as URLError {
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
    
    
} // END BanksiaHandler extension


enum APIRequestType: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: Error {
    case unknownStatusCode
    case badURL
    case badRequest(Data)
    case otherError(Error)
    case decodingError(Error)
    case noInternetConnection
}
