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
            return
        }
        
        print(apiKey.debugDescription)
        
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
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponseHandler.self, from: data)
                if let textResponse = decodedResponse.choices.first?.text {
                    if let conversation = self.currentConversation {
                        let message = Message(content: textResponse, isUser: false, conversation: conversation)
                    } else {
                        print("No conversation selected")
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format."])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
