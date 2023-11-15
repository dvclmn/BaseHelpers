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
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                print("guard let data = data was not successful")
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                if let textResponse = decodedResponse.choices.first?.message.content {
                    // Call the completion handler with the text response
                    completion(.success(textResponse))
                    
                    // Save the JSON response to a file
                    self.saveJSONResponseToFile(jsonData: data, usage: decodedResponse.usage)
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format."])))
                }
            } catch {
                completion(.failure(error))
                print("guard let data = data was not successful, here's the error: \(error)")
            }
        }.resume() // Don't forget to call resume() to start the task
    }
    
    private func saveJSONResponseToFile(jsonData: Data, usage: APIUsage) {
        DispatchQueue.global(qos: .background).async {
            do {
                // Convert the raw data to a pretty-printed JSON format for readability
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                let prettyJSONData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                
                // Create a unique file name for each response using a timestamp
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
                let dateString = dateFormatter.string(from: Date())
                let fileName = "Response-\(dateString).json"
                
                // Get the documents directory path
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                
                // Write the pretty-printed JSON data to the file
                try prettyJSONData.write(to: fileURL, options: .atomicWrite)
                
                print("Saved JSON response to \(fileURL)")
            } catch {
                print("Error saving JSON response to file: \(error)")
            }
        }
    }
}
