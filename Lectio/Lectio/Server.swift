//
//  Server.swift
//  Lectio
//
//  Created by Will Czifro on 10/31/14.
//  Copyright (c) 2014 Team WEIJ. All rights reserved.
//

import Foundation

public class Server {
    var httpClient: HttpClient
    var headersHelper: HeadersHelper
    var jsonHelper: JsonHelper
    var baseUrl: String = "http://10.0.0.33:9500"
    
    init(){
        httpClient = HttpClient()
        headersHelper = HeadersHelper()
        jsonHelper = JsonHelper()
    }
    
    func login(username: String, password: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            let post = (username: username, password: password, grant_type: "password")
            let url = baseUrl + "/api/v1/accounts/login"
            httpClient.postJSON(url, headers: headersHelper.GenerateLoginHeaders(), jsonObj: post) {
                (data: String, error: String?) -> Void in
                if (error != nil){
                    callback(Dictionary<String, AnyObject>(), error.localizedDescription)
                }
                else {
                    var jsonObj = jsonHelper.JsonParseDict(data)
                    callback(jsonObj, nil)
                }
            }
    }
    
    func getLectures(pg: Int, num: Int, token: String, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        let url = baseUrl + "/api/v1/lectures/getLectures"
        let params = ["pg": pg, "num": num]
        httpClient.getJSON(url, headers: headersHelper.GenerateAuthHeaders(token), params: param, callback)
    }
    
    func getLecture(lectureid: Int, token: String, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        let url = baseUrl + "/api/v1/lectures/getLecture"
        let param = ["lectureid": lectureid]
        httpClient.getJSON(url, headers: headersHelper.GenerateAuthHeaders(token), params: param, callback)
    }
    
    func getVideo(videoid: Int, token: String, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        let url = baseUrl + "/api/v1/videos/getVideo"
        let param = ["videoid", videoid]
        httpClient.getJSON(url, headers: headersHelper.GenerateAuthHeaders(token), params: param, callback)
    }
    
    func postComment(comment: String, token: String, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        let url = baseUrl + "/api/v1/lectures/addComment"
        let post = (commentText: comment)
        httpClient.postJSON(url, headers: headersHelper.GenerateAuthHeaders(token), jsonObj: post) {
            (data: String, error: String?) -> Void in
            if (error != nil){
                callback(Dictionary<String, AnyObject>(), error.localizedDescription)
            }
            else {
                var jsonObj = jsonHelper.JsonParseDict(data)
                callback(jsonObj, nil)
            }
        }
    }
    
}