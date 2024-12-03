//
//  WebServices.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//
import Foundation
import Alamofire
import UIKit

class Headers: NSObject {
    
    let deviceName =  UIDevice.current.name
    let appVersion =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    let timeZone = TimeZone.current.identifier
    
    public func getHeaders() -> HTTPHeaders {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "device-type": "ios",
            "device-model": getModel(),
            "device-name": removeSpecialCharsFromString(text: deviceName),
            "device-os": getDeviceOs(),
            "timezone": timeZone,
        ]
        
        return headers
    }
    
    func getModel() -> String {
        let deviceModel: String = UIDevice.current.model
        return deviceModel
    }
    
    func getDeviceOs() -> String {
        let systemVersion = UIDevice.current.systemVersion
        return "iOS \(systemVersion)"
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars: Set<Character> =
        Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(text.filter {okayChars.contains($0) })
    }
}
