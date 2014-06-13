//
//  PrimitiveConversion.swift
//  Quick
//
//  Created by 木村圭佑 on 2014/06/13.
//  Copyright (c) 2014年 木村圭佑. All rights reserved.
//

import Foundation

extension UInt8{
    @conversion func __conversion() -> (UInt){
        return UInt(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return UInt(self) as NSObject
    }
}

extension UInt16{
    @conversion func __conversion() -> (UInt){
        return UInt(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return UInt(self) as NSObject
    }
}

extension UInt32{
    @conversion func __conversion() -> (UInt){
        return UInt(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return UInt(self) as NSObject
    }
}

extension Int8{
    @conversion func __conversion() -> (Int){
        return Int(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return Int(self) as NSObject
    }
}

extension Int16{
    @conversion func __conversion() -> (Int){
        return Int(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return Int(self) as NSObject
    }
}


extension Int32{
    @conversion func __conversion() -> (Int){
        return Int(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return Int(self) as NSObject
    }
}

extension UnicodeScalar{
    @conversion func __conversion() -> (String){
        return String(self)
    }
    
    @conversion func __conversion() -> (NSObject){
        return String(self) as NSObject
    }
    
}
