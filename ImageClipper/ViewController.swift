//
//  ViewController.swift
//  ImageClipper
//
//  Created by Xu Menghua on 2017/4/16.
//  Copyright © 2017年 Xu Menghua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageClipperView:ImageClipperView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "test")
        imageClipperView = ImageClipperView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 40), image: image!)
        self.view.addSubview(imageClipperView!)
        
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 0, y: self.view.frame.size.height - 20, width: self.view.frame.size.width, height: 20)
        self.view.addSubview(saveButton)
        saveButton.setTitle("Save Image", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonClicked(button:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveButtonClicked(button:UIButton) -> Void {
        print("button clicked")
        let image = imageClipperView?.clipImage()
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        var resultTitle:String?
        var resultMessage:String?
        if error != nil {
            resultTitle = "错误"
            resultMessage = "保存失败,请检查是否允许使用相册"
        } else {
            resultTitle = "提示"
            resultMessage = "保存成功"
        }
        let alert:UIAlertController = UIAlertController.init(title: resultTitle, message:resultMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

