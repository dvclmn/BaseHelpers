//
//  APIHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation

enum OpenAI: String {
    case url
    
    var value: String {
        switch self {
        case .url:
            return "https://api.openai.com/v1/chat/completions"
        }
    }
}

extension BanksiaHandler {
    
    func testAPIFetch() {
        fetchResponse(prompt: "Your prompt here", completion:  { result in
            switch result {
            case .success(let data):
                // Handle the raw data, or save it to a file for inspection
                
                print("Raw data received:\n\(data)")
            case .failure(let error):
                // Handle the error
                print("Error fetching API response: \(error)")
            }
        }, isTest: true)
    }
    
    func fetchResponse(prompt: String, completion: @escaping (Result<String, Error>) -> Void, isTest: Bool = false) {
        
        guard let apiKey = KeychainHandler.get(forKey: "OpenAIKey") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found."])))
            return
        }
        
        let url = URL(string: OpenAI.url.value)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": myModel.value, // Specify the model you are using
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": temperature // You can adjust the temperature as needed
        ]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Handle the response data
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                print("guard let data = data was not successful")
                return
            }
            
            if isTest {
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    completion(.success(jsonString)) // Pass the jsonString instead of data
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data could not be decoded into a string."])))
                }
                
            } else {
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    if let textResponse = decodedResponse.choices.first?.message.content {
                        // Call the completion handler with the text response
                        
                        completion(.success(textResponse))
                        
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format."])))
                    }
                } catch {
                    completion(.failure(error))
                    print("guard let data = data was not successful, here's the error: \(error)")
                }
            }
            
            
        }.resume() // Don't forget to call resume() to start the task
    }
    
    
    
    
    
    
} // END BanksiaHandler extension
