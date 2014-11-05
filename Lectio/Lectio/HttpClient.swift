//
//  HttpClient.swift
//  Lectio
//
//  Created by Will Czifro on 10/31/14.
//  Copyright (c) 2014 Team WEIJ. All rights reserved.
//

import Foundation

public class HttpClient
{
    var jsonHelper: JsonHelper
    
    init() {
        jsonHelper = JsonHelper()
    }
    
    func sendRequest(request: NSMutableURLRequest, callback: (String, String?) -> Void) {
        let task = NSURLSession.sharedSession()
            .dataTaskWithRequest(request) {
                // implement callback
                (data, response, error) -> Void in
                if (error == nil){
                    callback("",error.localizedDescription)
                }
                else{
                    callback(NSString(data: data, encoding: NSUTF8StringEncoding)!, nil)
                }
        }
        
        task.resume()
    }
    
    func get(url: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        sendRequest(request, callback)
    }
    
    func getJSON(url: String,
        headers: Dictionary<String, String>,
        params: Dictionary<String, AnyObject>?,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            if params != nil {
                url = appendQueryParams(url, params: params)
            }
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
            request = setHeaders(request, headers: headers)
            sendRequest(request) {
                //implement callback
                (data: String, error: String?) -> Void in
                if (error != nil) {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    var jsonObj = self.jsonHelper.JsonParseDict(data)   // parse json string to object
                    callback(jsonObj, nil)
                }
            }
    }
    
    func postJSON(url: String,
        headers: Dictionary<String, String>,
        jsonObj: AnyObject,
        callback: (String, String?) -> Void) {
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request = addHeaders(request, headers: headers)
            let jsonString = jsonHelper.JsonStringify(jsonObj)  // convert object to string
            let data: NSData = jsonString.dataUsingEncoding(
                NSUTF8StringEncoding)!
            request.HTTPBody = data
            sendRequest(request, callback)
    }
    
    func appendQueryParams(oldUrl: String,
        params: Dictionary<String, AnyObject>?) -> String {
            let query = "?"
            for (key, value: AnyObject) in params {
                if query != "?" {
                    query += "&"
                }
                query += key + "=" + jsonHelper.JsonStringify(value)
            }
            return oldUrl + query
    }
    
    func setHeaders(request: NSMutableURLRequest,
        headers: Dictionary<String, String>) -> NSMutableURLRequest {
            for (key, value) in headers {
                if (key=="Authorization"){
                    request.addValue(value, forHTTPHeaderField: key)
                }
                else {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            return request
    }
    
    func addHeaders(request: NSMutableURLRequest,
        headers: Dictionary<String, String>) -> NSMutableURLRequest {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
            return request
    }
}

