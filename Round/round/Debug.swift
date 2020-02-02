//
//  Debug.swift
//  round
//
//  Created by Denis Kotelnikov on 26.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

class Debug {
    public static var LOGGING : Bool = true
    public static var DUMPING : Bool = false

    public static func log(_ title : String, _ any : Any){
        if !LOGGING {return}
        print(title,any)
    }
    public static func log(_ object : Any){
        if !DUMPING {return}
        dump(object)
    }
}
