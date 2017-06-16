//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let range: Range<Double> = Range(0.0..<10.0)
let min = range.lowerBound
let max = range.upperBound


let slider = UISlider()
print(slider.value)
print(slider.maximumValue)
slider.value = 237
print(slider.value)
