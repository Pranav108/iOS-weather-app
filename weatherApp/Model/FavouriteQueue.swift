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
        if array.count == maxSize {
             array.removeLast()
        }
        array.insert(element, at: 0)
    }

    func deselectFavourite(havingIndex element : Int){
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
    func swapFavouriteWeather(forIndex index : Int){
        for i in 0..<array.count {
            if array[i] < index{
                array[i] += 1
            }else if array[i] == index{
                array[i] = 0
            }
        }
    }
    func deleteRow(withIndex index : Int){
        for i in 0..<array.count {
            if array[i] > index{
                array[i] -= 1
            }
        }
        deselectFavourite(havingIndex: index)
    }
}
