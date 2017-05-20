//
// Created by Stephen Vickers on 1/14/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

///Small class that creates a Node for the LikedList
fileprivate class LinkedListNode<Element> {

    ///variable that holds a generic element for the node
    fileprivate var value : Element

    ///pointer to the next node in the list if there is one
    fileprivate var next : LinkedListNode?

    ///pointer to the previous node in the list if there is one
    fileprivate weak var previous : LinkedListNode?

    ///constructor for the class that takes a generic element and assigns it to self.value
    public init( _ value : Element ){
        self.value = value
    }

    ///deinit to set the next and previous back to nill
    deinit {
        self.next = nil
        self.previous = nil
    }
}


///Class that for a linked list for a generic element
///class also conforms to CustomStringConvertible, Sequence, and IteratorProtocol
public class LinkedList<Element>:  Sequence, IteratorProtocol, ExpressibleByArrayLiteral {

    //MARK: - Private variables and constants for the Linked List -

    ///typealias for LinkedListNode so I only have to type Node through out the rest of the class
    fileprivate typealias Node = LinkedListNode<Element>

    ///constant private variable to hold 1
    fileprivate let kOne = 1

    ///constant private variable to hold 2
    fileprivate let kTwo = 2

    ///private var to hold a pointer to the first node in the list
    fileprivate var head: Node?

    ///private variable to hold the number of times the array has been called in a sequence.
    ///this make the class conform to Sequence and IteratorProtocol
    fileprivate  var times: Int = 0

    ///public variable to get to the last node in the list
    private var last: Node? {

        //start with the head node if it's not nil
        if var node = head {

            //while there is a next node move to the next
            while case let next? = node.next {
                node = next
            }

            //return the last node that is not nil
            return node
        }

        //return nil if there is no nodes in the list
        return nil
    }

    //MARK: - Public variables and constants for the Linked List

    ///public variable to hold the count of the number of nodes in the list
    public var count = 0

    ///public variable to get access to the first node in the list
    private var first: Node? {
        return self.head
    }

    ///pubic Bool var that tells whether the lis is empty returns true if self.count is equal to 0 and false otherwise
    public var isEmpty: Bool {
        return self.count == 0 ? true : false
    }



    ///public variable to get to the starting index, returns 0 as that's the first node
    public var startIndex: Int {
        return 0
    }

    ///public variable to get to the last index, returns self.count - 1
    public var endIndex: Int {
        return self.count
    }


    ///public variable to get a new instance of a linked list with the same elements inside it
    public var newInstance : LinkedList<Element> {

        //create a new LinkedList with the same type of element
        let temp = LinkedList<Element>()

        //for the elements in the list, add them to the temp list
        for element in self{
            temp.append(element: element)
        }

        //return the temp list
        return temp
    }

    //MARK: - Constructors for the linked list -

    ///default constructor for the class
    public init() {
    }

    ///overloaded constructor that takes and element and adds it to the list
    public init(element: Element) {
        self.append(element: element)
    }

    ///Required init to make LinkedList conform to ExpressibleByArrayLiteral
    ///This constructor should not be called directly
    ///To use it correctly you add a coma separated value list inside of square brackets
    ///     let numbers : LinkedList = [1,2,3,4,5]
    required public init(arrayLiteral list: Element...){
        for item in list{
            self.append(element: item)
        }
    }


    //MARK: - Public Functions for the Linked List -

    ///function to append an element to the list
    public func append(element: Element) {

        //create a new Node with containing the element
        let newNode = Node(element)

        //if there is a last node then add the new Node to the end
        if let lastNode = self.last {
            newNode.previous = lastNode
            lastNode.next = newNode
        }

        //otherwise set self.head to newNode
        else {
            self.head = newNode
        }

        //increase the count
        self.increaseCount()
    }

    ///Public function to insert an element at a particular index
    public func insert(value: Element, at index: Int) {
        let (prev, next) = self.nodeBeforeAndAfter(at: index)

        let node = Node(value)
        node.previous = prev
        node.next = next
        prev?.next = node
        next?.previous = node

        if prev == nil {
            self.head = node
        }

        self.increaseCount()

    }

    ///public function to remove the last element from the LinkedList
    public func removeLast() -> Element {
        assert(!self.isEmpty)
        return self.remove(node: self.last!)
    }

    ///Public function to remove at a particular index in the LinkedList
    public func remove(at index: Int) -> Element {
        let node = nodeAt(index: index)
        assert(node != nil)
        return self.remove(node: node!)
    }

    ///Public Function to reverse the complete list
    public func reverse() {
        var node = self.head

        while let currentNode = node {
            node = currentNode.next
            self.swap(left: currentNode.next!, right: currentNode.previous!)
            self.head = currentNode
        }
    }

    ///Public function to get an element after a certain index
    public func element(afterIndex after: Int) -> Element {
        return self[after + 1]
    }

    ///Public function to map the LinkedList to a new list
    ///takes a closure to make the newLinked list i.e. {$0.character.count < $1.character.count} to
    ///get the character count  sorted of all elements if the elements happen to be string
    public func map<U>(transform: (Element) -> U) -> LinkedList<U> {
        let results = LinkedList<U>()
        var node = self.head

        while node != nil {
            results.append(element: transform(node!.value))
            node = node!.next
        }

        return results
    }

    ///Public function to filter the elements by a particular closure
    ///takes a closure to make the new list i.e. {$0.character.count > 5} to get all the elements that the
    ///character count is greater than 5 if the elements are strings
    public func filter(predicate: (Element) -> Bool) -> LinkedList<Element> {
        let results = LinkedList<Element>()

        var node = self.head

        while node != nil {
            if predicate(node!.value) {
                results.append(element: node!.value)
            }

            node = node!.next
        }

        return results
    }

    ///pubic subscript for the class
    public subscript(_ index: Int) -> Element {

        //get will get the element at the a particular index
        get {
            let node = self.nodeAt(index: index)

            return node!.value
        }

        //set a value for a Node at a particular index
        set(value) {

            //if the index is equal to self.endIndex then append the element to the end of the list
            if index == self.endIndex {
                self.append(element: value)
            }

            //if the new index is between self.startIndex (0) and self.endIndex (the count of elements in the class) then
            //change the value at that node to the new value
            else if index >= self.startIndex && index < self.endIndex {
                let node = self.nodeAt(index: index)
                node!.value = value
            }

            //else the new index is out of range and we just let the user know by printing that.
            else {
                print("Out of range")
            }
        }
    }


    ///Public function to make the Linked list conform to Sequence Protocol
    ///this make it to where we can use a for-in loop with the Linked List
    public func next() -> Element? {

        guard self.times < self.count
                else {
            self.resetTimes()
            return nil
        }

        let temp = self[self.startIndex + times]
        self.times += 1

        return temp

    }

    //MARK: - Private Functions for the Linked List -

    ///private function to increase the count of the list
    private func increaseCount() {
        self.count += 1
    }

    ///private function to decrease the count of the list
    private func decreaseCount() {
        self.count -= 1
    }



    /// function to get a node at a certain index
    fileprivate func nodeAt(index: Int) -> Node? {

        //if the index is greater or equal to than self.startIndex and less than self.endIndex then go over the
        if index >= self.startIndex && index < self.endIndex {

            //create a reference to the head node
            var node = self.head

            //create an variable equal to the index
            var i = index

            //while the node doens't equal nil then continue looping
            while node != nil {

                //if i equal 0 then you are at the correct node so it's returned
                if i == 0 {
                    return node
                }
                i -= 1 //decrease i by one
                node = node!.next //advance to the next node
            }
        }

        //return nil if the index is out of range
        return nil

    }

    ///private node to get the node before and the current node that something is supposed to be inserted at
    private func nodeBeforeAndAfter(at index: Int) -> (Node?, Node?) {

        assert(index >= 0)

        var i = index
        var next = self.head
        var prev: Node?

        while next != nil && i > 0 {
            i -= 1
            prev = next
            next = next!.next
        }

        assert(i == 0)

        return (prev, next)
    }



    ///Public function to remove an element at a particular Node
    ///return the element of that node
    fileprivate func remove(node: Node) -> Element {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            self.head = next
        }

        node.previous = nil
        node.next = nil

        self.decreaseCount()
        return node.value
    }





    ///fileprivate function to set the self.times to 0
    fileprivate func resetTimes(){
        self.times = 0
    }


    ///private function to swap the values of two nodes
    ///after trying to swap the place where the nodes were found it was easier to just swap the values
    ///since this is a class and not a struct it is a reference so we can just swap the values and move one
    fileprivate func swap(left : Node, right: Node){

        //set temp equal to the value in the left node to temp
        //set the value of left.value equal to right.value
        //set the right.value equal to temp
        let temp = left.value
        left.value = right.value
        right.value = temp
    }




}

//MARK: - Extension to make LinkedList conform to CustomStringConvertible -

extension LinkedList : CustomStringConvertible{

    ///public variable that returns a string representation of the class
    ///this is used to make the LinkedList class conform to CustomStringConvertible
    public var description: String  {
        //start the string with a square bracket
        var s = "["

        //set the first node to head
        var node = self.head

        //set the starting index for the nodes to increase
        var index = 1

        //while the node doesn't equal nil then advance add the node!.value to the string
        //set the node equal to the next node and repeat
        while node != nil {
            s += "\(node!.value)"
            node = node!.next

            //if the new node doesn't equal nil then add a ',' with a space afterward
            if node != nil {
                s += ", "
            }
            index += self.kOne
        }
        //return the string with a square bracket added to the end
        return s + "]"
    }
}


//MARK: - Extension to get the hashValue of the LinkedList as long as the Element is Hashable -

extension LinkedList where Element : Hashable {

    ///get the hashValue of the LinkedList. Start with 31 and continue doing an xor on the hash values of the values in all nodes and return that number
    public var hashValue : Int {

        var hash = 31

        var node = self.head

        while node != nil {
            hash =  hash ^ node!.value.hashValue
            node = node!.next
        }

        return hash
    }
}

//MARK: - Extension to be able to sort the LinkedList if the Element conforms to Comparable -

extension LinkedList where Element : Comparable{

    ///Public function to call a sort on the the linked List
    @discardableResult public func sorted() -> LinkedList<Element> {

        if self.count < 10 {
            self.bubbleSort()
        }else {
            self.quickSort(left: self.startIndex, right: self.endIndex - 1)
        }

        //return self so we can use print(list.sorted()) and get the actual list back
        //this is needed because otherwise it would print ()
        return self

    }

    ///Private Bubble Sort function. This is used for sorting small amounts of data as it works on (O)n^2 time always
    private func bubbleSort(){

        //index for the first element to check
        var index1 = 0

        //while index one is less that self.count
        while index1 < self.count  {

            //index for the second element to check
            var index2 = 0

            //continue looking though the list while index2 is less that self.count
            while index2 < self.count {

                //if the element at index1 is less than the element at index2 then swap them
                if self[index1] < self[index2]{
                    self.swap(left: self.nodeAt(index: index1)!, right: self.nodeAt(index: index2)!)
                }

                //increase the index2
                index2 += 1
            }

            //increase the index1
            index1 += 1
        }
    }

    ///private function to partition the list,
    ///this is used for the self.quickSort() method
    private func partition(left : Int = 0, right : Int) -> Int{

        //get the middle index of the range that was passed to the partition function
        let middle = left + (right - left ) / self.kTwo

        //set the pivot value to the value of the node that is at the middle index
        let pivot = self.nodeAt(index: middle)!.value

        //swap the two values of the two nodes at the middle and the left
        self.swap(left: self.nodeAt(index: middle)!, right: self.nodeAt(index: left)!)

        //set the starting indexes of the left and right to traverse the the range from the front and back
        var index1 = left + self.kOne //set to left plus one because we already swapped the value at left
        var index2 = right

        //while the first index is less than the the second index we will increase the left and decrease the right
        while index1 < index2 {

            //while index1 is less than or equal to index2 and the element at index1 is less than the pivot increase index1
            while index1 <= index2 && self[index1] <= pivot{
                index1 += self.kOne
            }

            //while index one is less than or equal to index2 and the element at index2 is greater than the pivot then decrease index2
            while index1 <= index2 && pivot < self[index2]{
                index2 -= self.kOne
            }

            //if index2 is less than index2 then we have found two elements that are out of order and we swap the two elements
            if index1 < index2 {
                self.swap(left: self.nodeAt(index: index1)!, right: self.nodeAt(index: index2)!)
            }
        }

        //swap the elements at index1 - 1 and left
        //since we swap the left and the middle at the start of the function what's on the left
        //is out of order and should go directly before what's at index1
        self.swap(left: self.nodeAt(index: index1 - self.kOne)!, right: self.nodeAt(index: left)!)

        //return index1 - 1 to call the partition again for the "part" constant in the quickSort function
        return index1 - self.kOne

    }

    ///Private Quick sort function that takes two indexes as the left and right positions to sort from
    ///starting out this is called with the indexes of 0 and self.endIndex - 1
    ///starts with self.endIndex  - 1 to conform to other Swift collection types where self.endIndex is one past the last element
    ///QuickSort is not stable, meaning that if two things are equal, they wont necessarily stay in the same order they are in
    ///The function usually runs on O(n log n) time for n elements, but can take O(n^2) which can happen if the element of the pivot in partition is either the largest or smallest value
    private func quickSort(left : Int, right : Int){

        //if the left index is less than the right then we need to continue thought the sort
        if left < right {

            //set the part to the int returned from the partition function
            let part = self.partition(left: left, right: right)

            //recursively call self.quickSort() twice on what's to the left of part and then what's to the right of part
            self.quickSort(left: left, right: part - self.kOne)
            self.quickSort(left: part + self.kOne, right: right)
        }
    }

    ///public static function to see if the two values in the two linked list are equal
    public static func == (lhs : LinkedList<Element>, rhs : LinkedList<Element>) -> Bool {

        //check to see if the list point to the same same place in memory
        //if they do they are the same list and will always be true
        if lhs === rhs {
            return true
        }

        //check if the count of both list are the same, if they aren't return false
        if lhs.count != rhs.count {
            return false
        }

        //else the counts are the same so we test to see if the two list have the all the same values in them
        else {

            //set an index at zero
            var index = 0

            //create two temp list and sort them then compare their elements
            let left = lhs.newInstance
            left.sorted()
            let right = rhs.newInstance
            right.sorted()

            //while the index is less than the count of lhs (chosen because it doesn't matter because the are the same)
            //check if the value of the rhs at that index is contained inside the lhs LinkedList
            while index < lhs.count {

                if left[index] != right[index]{
                    return false
                }

                index += 1
            }

            //if all the elements are in the lhs and rhs are equal then return true
            return true
        }
    }
}
