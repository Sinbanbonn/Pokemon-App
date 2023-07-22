import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, RequestError>) -> Void)
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, RequestError>) -> Void){
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let url = url.description.removingPercentEncoding else{
            completion(.failure(.invalidURL))
            return
        }
        
        print(url)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.serviceUnavailable))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else{
                    completion(.failure(.decode))
                    return
                }
                completion(.success(decodedResponse))
            case 400...499:
                let error = handleResponseError(statusCode: response.statusCode)
                completion(.failure(error))
            case 500...599:
                let error = handleResponseError(statusCode: response.statusCode)
                completion(.failure(error))
                
            default:
                completion(.failure(.other(response.statusCode)))
            }
            
            
        }
        task.resume()
    }
}
