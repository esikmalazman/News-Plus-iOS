//
//  NetworkManagerContract.swift
//  News+
//
//  Created by Ikmal Azman on 25/05/2022.
//

import Foundation

/// Extract URLSession method into protocol to enable test double
protocol NetworkManagerContract {
    /// Interface for URLDataTask that been copy from its api, allow to decople from singleton
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

/// Extend URLSession to conform to our abstract protocol
extension URLSession  : NetworkManagerContract {}
