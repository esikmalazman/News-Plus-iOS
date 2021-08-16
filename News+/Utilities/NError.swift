//
//  NError.swift
//  News+
//
//  Created by Ikmal Azman on 15/08/2021.
//

import Foundation

// Custom error messages, need to adopt Error protocol
enum NError : String, Error {
    
    case invalidTopic = "The topic requested is invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from server was invalid. Please Try Again"
}
