//
//  HeadersHelper.swift
//  Lectio
//
//  Created by Will Czifro on 10/31/14.
//  Copyright (c) 2014 Team WEIJ. All rights reserved.
//

import Foundation

public class HeadersHelper {
    
    func GenerateLoginHeaders() -> Dictionary<String, String> {
        let headers = Dictionary<String, String>()
        
        headers.updateValue("text/json", forKey: "Accept")
        headers.updateValue("application/x-www-form-urlencoded", forKey: "Content-Type")
        
        return headers
    }
    
    func GenerateAuthHeaders(token: String) -> Dictionary<String, String> {
        let headers = GenerateBasicHeaders()
        
        headers.updateValue(token, forKey: "Authorization")
        
        return headers
    }
    
    func GenerateBasicHeaders() -> Dictionary<String, String> {
        let headers = Dictionary<String, String>()
        
        headers.updateValue("text/json", forKey: "Accept")
        
        return headers
    }
}