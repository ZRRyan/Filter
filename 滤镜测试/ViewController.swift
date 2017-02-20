//
//  ViewController.swift
//  滤镜测试
//
//  Created by Ryan on 2017/2/20.
//  Copyright © 2017年 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageView: UIImageView = UIImageView()
    let pickerView = UIPickerView.init()
    let filterBtn = UIButton()
    
    lazy var filterNames: Array<String> = {
        
        return ["OriginImage",
                "CISepiaTone",
                "CIPhotoEffectMono",
                "CIPhotoEffectChrome",
                "CIPhotoEffectFade",
                "CIPhotoEffectInstant",
                "CIPhotoEffectNoir",
                "CIPhotoEffectProcess",
                "CIPhotoEffectTonal",
                "CIPhotoEffectTransfer",
                "CISRGBToneCurveToLinear",
                "CIVignetteEffect"]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(filterBtn)
        filterBtn.setTitle("筛选", for: .normal)
        filterBtn.addTarget(self, action: #selector(filterBtnClick), for: .touchUpInside)
        filterBtn.layer.cornerRadius = 20
        filterBtn.backgroundColor = UIColor.gray
        
        
        self.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
  
        
        imageView.image = UIImage.init(named: "1")?.filter(filterName: filterNames[0], intensity: 0.8)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let itemW = self.view.frame.size.width
        let itemH = self.view.frame.size.height
        
        imageView.frame = CGRect.init(x: 0, y: 0, width: itemW, height: itemH)
        
        filterBtn.frame = CGRect.init(x: 100, y: 20, width: itemW - 200, height: 40)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closePickerView()
    }
    
    func filterBtnClick() {
        showPickerView()
    }
    
    func showPickerView() {
        self.view.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        let itemW = self.view.frame.size.width
        let itemH = self.view.frame.size.height
        pickerView.frame = CGRect.init(x: 0, y: itemH, width: itemW, height: 200)
        UIView.animate(withDuration: 0.3) { 
            self.pickerView.frame = CGRect.init(x: 0, y: itemH - 200, width: itemW, height: 200)
        }
    }
    
    func closePickerView() {
        let itemW = self.view.frame.size.width
        let itemH = self.view.frame.size.height
        UIView.animate(withDuration: 0.3, animations: { 
            self.pickerView.frame = CGRect.init(x: 0, y: itemH, width: itemW, height: 200)
        }) { (finished) in
            self.pickerView.removeFromSuperview()
            self.pickerView.dataSource = nil
            self.pickerView.delegate = nil
        }
    }

}


extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterNames.count
    }

}


extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.filterNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imageView.image = UIImage.init(named: "1")?.filter(filterName: filterNames[row], intensity: 0.8)
    }
}

extension UIImage {
    
    /// 滤镜
    ///
    /// - Parameters:
    ///   - filterName: 滤镜名
    ///   - intensity: 强度
    /// - Returns: <#return value description#>
    func filter(filterName: String, intensity: Double) -> UIImage? {
        if filterName == "OriginImage" {
            return self
        }
        
       let imageData = UIImagePNGRepresentation(self)
        let inputImage = CoreImage.CIImage(data: imageData!)
        let context = CIContext.init(options: nil)
        let filter = CIFilter.init(name: filterName)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
//        filter?.setValue(intensity, forKeyPath: "inputIntensity")
        if let outputImage = filter?.outputImage {
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage.init(cgImage: outImage!)
        }
        return nil
    }
    
}
