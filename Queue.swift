//
// Created by Stephen Vickers on 2/17/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

public struct Queue<Element> : ExpressibleByArrayLiteral{

    //MARK: - Private variables for the Queue Class - 
    
    ///array to hold the items
    fileprivate var items = [Element]()

    ///public variable to see if the collection is empty
    public var isEmpty : Bool {
        return self.items.isEmpty
    }

    ///fileprivate variable for times, this is used for the next() function
    fileprivate var times = 0

    ///fileprivate variable for the next starting number, this is used for the next() function
    fileprivate var nextStartingNumber : Int {
        return self.items.count - 1
    }
    
    //MARK: - Public Variables for the Queue Class
    
    ///public var to get the count of the collection
    public var count : Int {
        return self.items.count
    }

    //MARK: - Constructors for the Queue Class -
    
    ///public constructor for the class
    public init(){}

    ///public constructor that conforms to ExpressibleByArrayLiteral protocol
    /// -Parameters arrayLiteral: An arrayLieteral of items to add to the Queue
    ///
    ///This should not be directely called. Should be called with a declaration
    ///Followed by and comma seperated values inside of square brackets
    ///
    ///     i.e. var myQueue : Queue = [1,2,3,4,5]
    public init(arrayLiteral items : Element...){
        for item in items{
            self.push(item: item)
        }
    }

    //MARK: - Public functions for the Queue class - 
    
    ///public function to push an element on to the collection
    /// - Parameter item:   An element to push onto the Queue
    public mutating func push(item : Element){
        self.items.append(item)
    }

    ///public function to pop an element off the collection
    ///-returns: And the first element in the Queue if it's not empty, nil if it is
    public mutating func pop() -> Element?{
        return self.isEmpty ? nil : self.items.removeFirst()
    }

    ///subscript to get an element in the collection
    ///returns:     nil if the index is greater than self.count 
    ///             other wise it returns the element at that spot
    subscript(_ index: Int) -> Element?{
        guard index < self.count else {
            return nil
        }
        return self.items[index]
    }

}

//MARK: - Extension for Queue to make it comform ot Sequesnce and IteratorProtocol -
extension Queue : Sequence, IteratorProtocol {

    ///function to make the collection conform to Sequence and IteratorProtocol
    ///this allows the function to be used inside a for in loop
    public mutating func next() -> Element?{

        guard self.times < self.count else{
            return nil
        }

        let temp = self[self.times]
        self.times += 1

        return temp
    }
}

//Mark: - Extension on Queue to make it comfrom to CustomStringConvertible
extension Queue : CustomStringConvertible{
    
    ///Calculated variable to get the discription of the items in the Queue
    public var description: String {
        return self.items.description
    }
}

//MARK: - Extension on Queue to get the HashVale if Element conforms to Hashable
extension Queue where Element : Hashable{

    ///Calculated variable to get the hashvalue of the the Queue
    public var hashValue : Int{
        var hash = 31

        for item in self{
            hash += hash ^ item.hashValue ^ 100
        }

        return hash
    }
}
