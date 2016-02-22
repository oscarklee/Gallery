//
//  BingService.swift
//  Gallery
//
//  Created by MacPRo on 2/19/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import Foundation

class BingService: NSObject, GalleryService {
  // url root of the bing page api.
  let rootUrl = "https://api.datamarket.azure.com/Bing/Search/v1/Image"
  
  // key created in the oscar account for the gallery app to get the images.
  // only 5000 requests are alowed.
  let appId = "hciiGAyTD/NK0tgAxWZcfE0LGh0VZwNls9a2VlahrZY="
  
  var request: NSMutableURLRequest!
  
  init(query: String = "baby") {
    super.init()
    
    // format the account id in base64 with the form 'id:id' for the credentials.
    let authorization = getBase64AccountCredentials(appId)
    
    // create get parameters for the url.
    let parameters: [NSURLQueryItem] = [
      NSURLQueryItem(name: "Query", value: "'\(query)'"),
      NSURLQueryItem(name: "Adult", value: "'Off'"),
      NSURLQueryItem(name: "$top", value: "101"),
      NSURLQueryItem(name: "$format", value: "JSON"),
      NSURLQueryItem(name: "ImageFilters", value: "'Size:Width:1440+Size:Height:900'")
    ]
    
    // create the nsurl with the root url and the parameters.
    let urlComponents: NSURLComponents = NSURLComponents(string: rootUrl)!
    urlComponents.queryItems = parameters
    urlComponents.percentEncodedQuery = getExtraEncodedURLQuery(urlComponents.query!)
    
    // make the request to be sent.
    self.request = makeAuthorizationRequest(urlComponents.URL!, base64Authorization: authorization)
  }
  
  func getExtraEncodedURLQuery(query: String) -> String {
    let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~?=&"
    let unreservedCharset = NSCharacterSet(charactersInString: unreservedChars)
    return query.stringByAddingPercentEncodingWithAllowedCharacters(unreservedCharset)!
  }
  
  func getBase64AccountCredentials(id: String) -> String {
    // format the id according to the specification.
    let loginString = NSString(format: "%1$@:%1$@", id)
    
    // encoded data using utf8 encoding.
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    
    // encoded to base 64 string.
    return loginData.base64EncodedStringWithOptions([])
  }
  
  func makeAuthorizationRequest(baseUrl: NSURL, base64Authorization: String) -> NSMutableURLRequest {
    // make the request with the root url.
    let request = NSMutableURLRequest(URL: baseUrl)
    
    // set the get method for the request.
    request.HTTPMethod = "GET"
    
    // set the header authorization with the base64 credentials.
    request.setValue("Basic \(base64Authorization)", forHTTPHeaderField: "Authorization")
    
    // return the request.
    return request
  }
  
  func getContent(onComplete: (content: [Data]) -> Void) {
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) {
      (data, response, error) in
      
      if (error == nil) {
        let result = self.getDataFromPlainContent(data!)
        onComplete(content: result)
      }
    }
    
    task.resume()
  }
  
  func getDataFromPlainContent(data: NSData) -> [Data] {
    var response: [Data] = []
    
    do {
      if let json:AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) {
        if let dictionary = json as? NSDictionary {
          let results = dictionary["d"]!["results"] as? [[String: AnyObject]]
          for result in results! {
            let newData:Data = Data()
            newData.label = result["Title"]! as! String
            newData.image = NSURL(string: result["MediaUrl"]! as! String)!
            
            let thumbnailDict = result["Thumbnail"] as! [String: AnyObject]
            newData.thumbnail = NSURL(string: thumbnailDict["MediaUrl"]! as! String)!
            
            response.append(newData)
          }
        }
      } else {
        let content: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        print(content)
      }
    } catch {
      print("error serializing JSON: \(error)")
    }
    
    return response
  }
}