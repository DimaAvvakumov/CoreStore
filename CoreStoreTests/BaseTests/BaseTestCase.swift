//
//  BaseTestCase.swift
//  CoreStore
//
//  Copyright © 2016 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest

@testable
import CoreStore


// MARK: - BaseTestCase

class BaseTestCase: XCTestCase {
    
    // MARK: Internal
    
    @nonobjc
    func prepareStack(configuration: String = "Config1", @noescape _ closure: (dataStack: DataStack) -> Void) {
        
        let stack = DataStack(
            modelName: "Model",
            bundle: NSBundle(forClass: self.dynamicType)
        )
        do {
            
            try stack.addStorageAndWait(
                SQLiteStore(
                    fileName: "\(self.dynamicType).sqlite",
                    configuration: configuration,
                    localStorageOptions: .RecreateStoreOnModelMismatch
                )
            )
        }
        catch let error as NSError {
            
            XCTFail(error.coreStoreDumpString)
        }
        closure(dataStack: stack)
    }
    
    
    // MARK: XCTestCase
    
    override func setUp() {
        
        super.setUp()
        self.deleteStores()
    }
    
    override func tearDown() {
        
        self.deleteStores()
        super.tearDown()
    }
    
    
    // MARK: Private
    
    private func deleteStores(directory: NSURL = SQLiteStore.defaultRootDirectory) {
        
        _ = try? NSFileManager.defaultManager().removeItemAtURL(directory)
    }
}