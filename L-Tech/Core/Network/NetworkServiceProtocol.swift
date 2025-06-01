import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, AFError>) -> Void)
}
