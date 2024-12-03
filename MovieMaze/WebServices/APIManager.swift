//
//  APIManager.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import Foundation
import Alamofire
import Swift

class ApiManager {
    
    static var shared = ApiManager()
    
    func requestGET(url: String, parameter: [String: Any] = [:], isForListCities : Bool = false, completionHandler: @escaping (_ statusCode: Int?, _ result: Data?, _ error: String?) -> Void) {
        
        AF.request(url,
                   method: .get,
                   parameters: parameter,
                   encoding: URLEncoding.default,
                   headers: Headers().getHeaders())
        .validate(statusCode: 200..<505)
        .response(completionHandler: { response in
#if DEBUG
            ApiManager.logApiResponse(response)
#endif
            switch response.result {
            case .success:
                self.produceSuccessResult(response: response, completionHandler: completionHandler)
            case .failure(let error):
                self.produceSuccessResult(response: response, completionHandler: completionHandler)
            }
        })
    }
    
    
    func produceSuccessResult(response: AFDataResponse<Data?>?,
                              completionHandler: @escaping (_ statusCode: Int?, _ result: Data?, _ message: String?) -> Void) {
        
        guard let httpStatusCode = response?.response?.statusCode else {
            completionHandler(nil, nil, "No response from server.")
            return
        }
        
        switch httpStatusCode {
        case 200, 201:
            completionHandler(httpStatusCode, response?.data, nil)
            
        case 400:
            completionHandler(httpStatusCode, nil, "Bad request. Please check your input.")
            
        case 401:
            completionHandler(httpStatusCode, nil, "Unauthorized. Please check your access credentials.")
            
        case 403:
            completionHandler(httpStatusCode, nil, "Forbidden. You do not have permission to access this resource.")
            
        case 404:
            completionHandler(httpStatusCode, nil, "Resource not found. Please verify the endpoint.")
            
        case 422:
            completionHandler(httpStatusCode, response?.data, "Validation error. Please check the submitted data.")
            
        case 500...599:
            completionHandler(httpStatusCode, nil, "Server error. Please try again later.")
            
        default:
            completionHandler(httpStatusCode, response?.data, "Unexpected response with status code: \(httpStatusCode).")
        }
    }
    
    public static func logApiResponse<Data, AFError>(_ response: DataResponse<Data, AFError>) {
        guard let request = response.request, let httpResponse = response.response, let responseData = response.data else {
            print("API request is missing either request, response, or data. Put a breakpoint in ServiceRequest.swift to learn more.")
            return
        }
        
        var requestLines = ["curl -X \(request.httpMethod!)"]
        requestLines.append(contentsOf: request.allHTTPHeaderFields!.map { "-H \"\($0.key): \($0.value)\"" })
        if let requestBody = response.request?.httpBody {
            requestLines.append("-d '\(String(data: requestBody, encoding: .ascii)!)'")
        }
        requestLines.append("\"\(request.url!.absoluteString)\"")
        print(requestLines.joined(separator: " \\\n   "))
        print("Response status: \(httpResponse.statusCode), data: \(String(data: responseData, encoding: .ascii)!.prefix(1024))")
    }
}
