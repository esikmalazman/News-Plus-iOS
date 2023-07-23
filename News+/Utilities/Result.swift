//
//  Result.swift
//  News+
//
//  Created by Ikmal Azman on 15/08/2021.
//

import Foundation

// For result type logic handling, associate
// Result <> type, remove ambiguity of the optionals, value that represent either success/failure include associate value in each case
enum Result<Success, Failure : Error> {
    case success(Success)
    case failure(Failure)
}
