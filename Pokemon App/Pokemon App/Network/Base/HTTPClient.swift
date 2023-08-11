import Foundation
import Combine

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type) async throws -> T
}


extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type) async throws -> T {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        
        guard let url = urlComponents.url else {
            throw RequestError.invalidURL
            
        }
        
        guard let url = url.description.removingPercentEncoding else{
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.serviceUnavailable
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else{
                    throw RequestError.decode
                    
                }
                return decodedResponse
            case 400...499:
                let error = handleResponseError(statusCode: response.statusCode)
                throw error
            case 500...599:
                let error = handleResponseError(statusCode: response.statusCode)
                throw error
                
            default:
                throw RequestError.other(response.statusCode)
            }
        } catch {
            throw RequestError.other(0)
        }
        
    }
    
}

