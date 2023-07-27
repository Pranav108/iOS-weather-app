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

    func selectFavourite(havingIndex element: Int) {
        print(#function, element)
        if array.count == maxSize {
             array.removeLast()
        }
        array.insert(element, at: 0)
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