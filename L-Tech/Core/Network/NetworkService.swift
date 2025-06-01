import Alamofire

final class NetworkService: NetworkServiceProtocol {

    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, AFError>) -> Void) {
        let method = endpoint.method
        let url = endpoint.url
        let parameters = endpoint.parameters
        let headers = endpoint.headers

        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : URLEncoding.httpBody
        
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
