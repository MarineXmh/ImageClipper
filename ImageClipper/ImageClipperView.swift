//
//  ImageClipperView.swift
//  ImageClipper
//
//  Created by Xu Menghua on 2017/4/16.
//  Copyright © 2017年 Xu Menghua. All rights reserved.
//

import UIKit

class ImageClipperView: UIView, UIScrollViewDelegate {
    
    let leftTopPoint:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let leftBottomPoint:UIView = UIView(frame: CGRect(x: 0, y: 100, width: 20, height: 20))
    let rightTopPoint:UIView = UIView(frame: CGRect(x: 100, y: 0, width: 20, height: 20))
    let rightBottomPoint:UIView = UIView(frame: CGRect(x: 100, y: 100, width: 20, height: 20))
    let clipperRect:ImageClipperRect = ImageClipperRect(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
    let scrollView:UIScrollView = UIScrollView()
    let imageView:UIImageView = UIImageView()
    
    public func clipImage() -> UIImage {
        UIGraphicsBeginImageContext((self.imageView.image?.size)!)
        let path = UIBezierPath(rect: CGRect(x: (self.scrollView.contentOffset.x + self.clipperRect.frame.origin.x) / self.scrollView.zoomScale, y: (self.scrollView.contentOffset.y + self.clipperRect.frame.origin.y) / self.scrollView.zoomScale, width: self.clipperRect.frame.size.width / self.scrollView.zoomScale, height: self.clipperRect.frame.size.height / self.scrollView.zoomScale))
        path.addClip()
        self.imageView.image?.draw(at: CGPoint(x: 0, y: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, image:UIImage) {
        super.init(frame: frame)
        self.scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.scrollView.contentSize = CGSize(width: image.size.width, height: image.size.height)
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.minimumZoomScale = 0.25
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        self.imageView.image = image
        
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.addSubview(clipperRect)
        self.addSubview(leftTopPoint)
        self.addSubview(leftBottomPoint)
        self.addSubview(rightTopPoint)
        self.addSubview(rightBottomPoint)
        
        let clipperRectPanGesture = UIPanGestureRecognizer(target: self, action: #selector(clipperRectPan(pan:)))
        self.clipperRect.addGestureRecognizer(clipperRectPanGesture)
        let leftTopPointPanGesture = UIPanGestureRecognizer(target: self, action: #selector(leftTopPointPan(pan:)))
        self.leftTopPoint.addGestureRecognizer(leftTopPointPanGesture)
        let leftBottomPointPanGesture = UIPanGestureRecognizer(target: self, action: #selector(leftBottomPointPan(pan:)))
        self.leftBottomPoint.addGestureRecognizer(leftBottomPointPanGesture)
        let rightTopPointPanGesture = UIPanGestureRecognizer(target: self, action: #selector(rightTopPointPan(pan:)))
        self.rightTopPoint.addGestureRecognizer(rightTopPointPanGesture)
        let rightBottomPointPanGesture = UIPanGestureRecognizer(target: self, action: #selector(rightBottomPointPan(pan:)))
        self.rightBottomPoint.addGestureRecognizer(rightBottomPointPanGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(self.scrollView.zoomScale)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y)
    }

    func clipperRectPan(pan:UIPanGestureRecognizer) -> Void {
        let location = pan.location(in: self)
        self.clipperRect.center = CGPoint(x: location.x, y: location.y)
        self.leftTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y)
        self.leftBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.rightTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y)
        self.rightBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.clipperRect.setNeedsDisplay()
        print(location.x, location.y, "\n")
    }
    
    func leftTopPointPan(pan:UIPanGestureRecognizer) -> Void {
        let location = pan.location(in: self)
        if (self.rightTopPoint.center.x - location.x) < 60 || (self.leftBottomPoint.center.y - location.y) < 60{
            return
        }
        self.leftTopPoint.center = CGPoint(x: location.x, y: location.y)
        self.clipperRect.frame = CGRect(x: location.x, y: location.y, width: self.rightTopPoint.center.x - location.x, height: self.leftBottomPoint.center.y - location.y)
        self.leftBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.rightTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y)
        self.rightBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.clipperRect.setNeedsDisplay()
    }
    
    func leftBottomPointPan(pan:UIPanGestureRecognizer) -> Void {
        let location = pan.location(in: self)
        if (self.rightBottomPoint.center.x - location.x) < 60 || (location.y - self.clipperRect.frame.origin.y) < 60 {
            return
        }
        self.leftBottomPoint.center = CGPoint(x: location.x, y: location.y)
        self.clipperRect.frame = CGRect(x: location.x, y: self.clipperRect.frame.origin.y, width: self.rightBottomPoint.center.x - location.x, height: location.y - self.clipperRect.frame.origin.y)
        self.leftTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y)
        self.rightTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y)
        self.rightBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.clipperRect.setNeedsDisplay()
    }
    
    func rightTopPointPan(pan:UIPanGestureRecognizer) -> Void {
        let location = pan.location(in: self)
        if (location.x - self.clipperRect.frame.origin.x) < 60 || (self.rightBottomPoint.center.y - location.y) < 60 {
            return
        }
        self.rightTopPoint.center = CGPoint(x: location.x, y: location.y)
        self.clipperRect.frame = CGRect(x: self.clipperRect.frame.origin.x, y: location.y, width: location.x - self.clipperRect.frame.origin.x, height: self.rightBottomPoint.center.y - location.y)
        self.leftTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y)
        self.leftBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.rightBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.clipperRect.setNeedsDisplay()
    }
    
    func rightBottomPointPan(pan:UIPanGestureRecognizer) -> Void {
        let location = pan.location(in: self)
        if (location.x - self.clipperRect.frame.origin.x) < 60 || (location.y - self.clipperRect.frame.origin.y) < 60 {
            return
        }
        self.rightBottomPoint.center = CGPoint(x: location.x, y: location.y)
        self.clipperRect.frame = CGRect(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y, width: location.x - self.clipperRect.frame.origin.x, height: location.y - self.clipperRect.frame.origin.y)
        self.leftTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y)
        self.leftBottomPoint.center = CGPoint(x: self.clipperRect.frame.origin.x, y: self.clipperRect.frame.origin.y + self.clipperRect.frame.size.height)
        self.rightTopPoint.center = CGPoint(x: self.clipperRect.frame.origin.x + self.clipperRect.frame.size.width, y: self.clipperRect.frame.origin.y)
        self.clipperRect.setNeedsDisplay()
    }
}
