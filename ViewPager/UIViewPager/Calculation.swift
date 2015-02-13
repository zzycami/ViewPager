//
//  Calculation.swift
//  MobileMap
//
//  Created by damingdan on 15/2/7.
//  Copyright (c) 2015年 Kingoit. All rights reserved.
//

import Foundation
import CoreGraphics


func +(lhs: Int, rhs: Double) -> Double {
    return Double(lhs) + rhs
}
func +(lhs: Double, rhs: Int) -> Double {
    return lhs + Double(rhs)
}
func +(lhs: Int, rhs: Float) -> Float {
    return Float(lhs) + rhs
}
func +(lhs: Float, rhs: Int) -> Float {
    return lhs + Float(rhs)
}
func +(lhs: Float, rhs: Double) -> Double {
    return Double(lhs) + rhs
}
func +(lhs: Double, rhs: Float) -> Double {
    return lhs + Double(rhs)
}
func +(lhs: UInt, rhs: Double) -> Double {
    return Double(lhs) + rhs
}
func +(lhs: Double, rhs: UInt) -> Double {
    return lhs + Double(rhs)
}
func +(lhs: UInt, rhs: Float) -> Float {
    return Float(lhs) + rhs
}
func +(lhs: Float, rhs: UInt) -> Float {
    return lhs + Float(rhs)
}
func -(lhs: Int, rhs: Double) -> Double {
    return Double(lhs) - rhs
}
func -(lhs: Double, rhs: Int) -> Double {
    return lhs - Double(rhs)
}
func -(lhs: Int, rhs: Float) -> Float {
    return Float(lhs) - rhs
}
func -(lhs: Float, rhs: Int) -> Float {
    return lhs - Float(rhs)
}
func -(lhs: Float, rhs: Double) -> Double {
    return Double(lhs) - rhs
}
func -(lhs: Double, rhs: Float) -> Double {
    return lhs - Double(rhs)
}
func -(lhs: UInt, rhs: Double) -> Double {
    return Double(lhs) - rhs
}
func -(lhs: Double, rhs: UInt) -> Double {
    return lhs - Double(rhs)
}
func -(lhs: UInt, rhs: Float) -> Float {
    return Float(lhs) - rhs
}
func -(lhs: Float, rhs: UInt) -> Float {
    return lhs - Float(rhs)
}
func *(lhs: Int, rhs: Double) -> Double {
    return Double(lhs) * rhs
}
func *(lhs: Double, rhs: Int) -> Double {
    return lhs * Double(rhs)
}
func *(lhs: Int, rhs: Float) -> Float {
    return Float(lhs) * rhs
}
func *(lhs: Float, rhs: Int) -> Float {
    return lhs * Float(rhs)
}
func *(lhs: Float, rhs: Double) -> Double {
    return Double(lhs) * rhs
}
func *(lhs: Double, rhs: Float) -> Double {
    return lhs * Double(rhs)
}
func *(lhs: UInt, rhs: Double) -> Double {
    return Double(lhs) * rhs
}
func *(lhs: Double, rhs: UInt) -> Double {
    return lhs * Double(rhs)
}
func *(lhs: UInt, rhs: Float) -> Float {
    return Float(lhs) * rhs
}
func *(lhs: Float, rhs: UInt) -> Float {
    return lhs * Float(rhs)
}
func /(lhs: Int, rhs: Double) -> Double {
    return Double(lhs) / rhs
}
func /(lhs: Double, rhs: Int) -> Double {
    return lhs / Double(rhs)
}
func /(lhs: Int, rhs: Float) -> Float {
    return Float(lhs) / rhs
}
func /(lhs: Float, rhs: Int) -> Float {
    return lhs / Float(rhs)
}
func /(lhs: Float, rhs: Double) -> Double {
    return Double(lhs) / rhs
}
func /(lhs: Double, rhs: Float) -> Double {
    return lhs / Double(rhs)
}
func /(lhs: UInt, rhs: Double) -> Double {
    return Double(lhs) / rhs
}
func /(lhs: Double, rhs: UInt) -> Double {
    return lhs / Double(rhs)
}
func /(lhs: UInt, rhs: Float) -> Float {
    return Float(lhs) / rhs
}
func /(lhs: Float, rhs: UInt) -> Float {
    return lhs / Float(rhs)
}
// MARK: - Core Graphics Calculation
func +(lhs: CGFloat, rhs: Float) -> CGFloat {
    return lhs + CGFloat(rhs)
}
func +(lhs: Float, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}
func +(lhs: CGFloat, rhs: Double) -> CGFloat {
    return lhs + CGFloat(rhs)
}
func +(lhs: Double, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}
func +(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs + CGFloat(rhs)
}
func +(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}
func +(lhs: CGFloat, rhs: UInt) -> CGFloat {
    return lhs + CGFloat(rhs)
}
func +(lhs: UInt, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}
func -(lhs: CGFloat, rhs: Float) -> CGFloat {
    return lhs - CGFloat(rhs)
}
func -(lhs: Float, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}
func -(lhs: CGFloat, rhs: Double) -> CGFloat {
    return lhs - CGFloat(rhs)
}
func -(lhs: Double, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}
func -(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs - CGFloat(rhs)
}
func -(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}
func -(lhs: CGFloat, rhs: UInt) -> CGFloat {
    return lhs - CGFloat(rhs)
}
func -(lhs: UInt, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}
func *(lhs: CGFloat, rhs: Float) -> CGFloat {
    return lhs * CGFloat(rhs)
}
func *(lhs: Float, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}
func *(lhs: CGFloat, rhs: Double) -> CGFloat {
    return lhs * CGFloat(rhs)
}
func *(lhs: Double, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}
func *(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs * CGFloat(rhs)
}
func *(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}
func *(lhs: CGFloat, rhs: UInt) -> CGFloat {
    return lhs * CGFloat(rhs)
}
func *(lhs: UInt, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}
func /(lhs: CGFloat, rhs: Float) -> CGFloat {
    return lhs / CGFloat(rhs)
}
func /(lhs: Float, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}
func /(lhs: CGFloat, rhs: Double) -> CGFloat {
    return lhs / CGFloat(rhs)
}
func /(lhs: Double, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}
func /(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}
func /(lhs: Int, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}
func /(lhs: CGFloat, rhs: UInt) -> CGFloat {
    return lhs / CGFloat(rhs)
}
func /(lhs: UInt, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}