//
//  Error.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation

enum BookError : Error {
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case JSONParsingError
    case wrongJSONFormat
    case nilBook
}
