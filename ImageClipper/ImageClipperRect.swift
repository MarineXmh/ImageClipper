//
//  ImageClipperRect.swift
//  ImageClipper
//
//  Created by Xu Menghua on 2017/4/16.
//  Copyright © 2017年 Xu Menghua. All rights reserved.
//

import UIKit

class ImageClipperRect: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        let clipperRangeRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(2.0)
        context?.addRect(clipperRangeRect)
        context?.drawPath(using: .stroke)
        context?.setLineWidth(6.0)
        context?.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: 20, y: 0)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: self.frame.size.width - 20, y: 0), CGPoint(x: self.frame.size.width, y: 0)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: self.frame.size.width, y: 0), CGPoint(x: self.frame.size.width, y: 20)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: self.frame.size.width, y: self.frame.size.height - 20), CGPoint(x: self.frame.size.width, y: self.frame.size.height)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: self.frame.size.width, y: self.frame.size.height), CGPoint(x: self.frame.size.width - 20, y: self.frame.size.height)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: 20, y: self.frame.size.height), CGPoint(x: 0, y: self.frame.size.height)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: 0, y: self.frame.size.height), CGPoint(x: 0, y: self.frame.size.height - 20)])
        context?.drawPath(using: .stroke)
        context?.addLines(between: [CGPoint(x: 0, y: 20), CGPoint(x: 0, y: 0)])
        context?.drawPath(using: .stroke)
    }

}
