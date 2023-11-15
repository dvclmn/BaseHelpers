//
//  APIHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation

extension BanksiaHandler {
    
    func fetchResponse(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = KeychainHandler.get(forKey: "OpenAIKey") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found."])))
            print("Couldn't get the key")
            return
        }
        
        print("API key: \(apiKey)")
        
        let url = URL(string: "https://api.openai.com/v1/engines/text-davinci-003/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 150
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Handle the response data
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponseHandler.self, from: data)
                    if let textResponse = decodedResponse.choices.first?.text {
                        // Call the completion handler with the text response
                        completion(.success(textResponse))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format."])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume() // Don't forget to call resume() to start the task
    }
}
