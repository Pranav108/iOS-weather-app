//
//  MyStack.swift
//  weatherApp
//
//  Created by Pranav Pratap on 26/07/23.
//

import Foundation

class FavouriteQueue {
    private var array: [Int]
    private let maxSize: Int

    init(size: Int) {
        maxSize = size
        array = []
    }

    func selectFavourite(havingIndex element: Int) -> Int?{
        print(#function, element)
        var indexToDeselect : Int?
        if array.count == maxSize {
            indexToDeselect = array.removeFirst()
        }
        array.append(element)
        return indexToDeselect
    }

    func deselectFavourite(havingIndex element : Int){
        print(#function, element)
        if let index = array.firstIndex(of: element) {
            array.remove(at: index)
        }
    }
    func getFavouriteList()-> [Int] {
        return array
    }
    func slideFavList(){
        for i in 0..<array.count{
            array[i] += 1
        }
    }
}
