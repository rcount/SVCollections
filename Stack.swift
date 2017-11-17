//
// Created by Stephen Vickers on 2/17/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

public struct Stack<Element>: ExpressibleByArrayLiteral {

    //MARK: - Private variables for the Stack - 
    
    ///array to hold the items
    fileprivate var items = [Element]()

    ///public variable to see if the collection is empty
    public var isEmpty: Bool {
        return self.items.isEmpty
    }

    ///fileprivate variable for times, this is used for the next() function
    fileprivate var times = 0

    ///fileprivate variable for the next starting number, this is used for the next() function
    fileprivate var nextStartingNumber: Int {
        return self.items.count - 1
    }
    
    //MARK: - Public variables for the Stack
    
    ///public var to get the count of the collection
    public var count: Int {
        return self.items.count
    }

    //MARK: - Constructors for the class - 
    
    ///public constructor for the class
    public init(){}

    ///public constructor that conforms to ExpressibleByArrayLiteral protocol
    /// -Parameters arrayLiteral: An arrayLieteral of items to add to the Queue
    ///
    ///This should not be directely called. Should be called with a declaration
    ///Followed by and comma seperated values inside of square brackets
    ///
    ///     i.e. var myStack: Stack = [1,2,3,4,5]
    public init(arrayLiteral items: Element...){
        for item in items{
            self.push(item: item)
        }
    }

    //MARK: - Public functions for the Stack Class
    
    ///public function to push an element on to the collection
    public mutating func push(item: Element){
        self.items.append(item)
    }

    ///public function to pop an element off the collection
    ///-returns:  the last Element element in the Stack if it's not empty, nil if it is
    public mutating func pop() -> Element?{
        return self.isEmpty ? nil : self.items.removeLast()
    }

    ///subscript to get an element in the collection
    /// - returns:     nil if the index is greater than self.count
    ///                other wise it returns the element at that spot
    subscript(_ index: Int) -> Element?{
        guard index < self.count else {
            return nil
        }
        return self.items.reversed()[index]
    }

}

//MARK: - Extension of Stack to make it comform to Sequence and IteratorProtocol -
extension Stack: Sequence, IteratorProtocol{

    ///function to make the collection conform to Sequence and IteratorProtocol
    ///this allows the function to be used inside a for in loop
    public mutating func next() -> Element?{

        guard self.times < self.count else{
            return nil
        }

        let temp = self[self.nextStartingNumber - self.times]
        self.times += 1

        return temp
    }


}

//MARK: - Extension on Stack to make it conform to CustomString Convertible -
extension Stack: CustomStringConvertible{
    
    ///Calculated Variable to get the Description of the Stack
    /// - return    a String reperesenting the values in the Stack
    public var description: String {
        return self.items.reversed().description
    }
}

//MARK: - Extension on Stack to get the hash Value of the stack if the Element is Hashable
extension Stack where Element: Hashable{

    ///Calculated Variable to get the hashValue of the Stack
    /// -return:    An Int with the HashValue 
    public var hashValue : Int{
        var hash = 31

        for item in self{
            hash += hash ^ item.hashValue ^ 100
        }

        return hash
        
        
    }
}

