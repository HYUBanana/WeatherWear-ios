//
//  UIImage.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit

extension UIImage
{
   func resizedImage(Size sizeImage: CGSize) -> UIImage?
   {
       let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
       UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
       self.draw(in: frame)
       let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       self.withRenderingMode(.alwaysOriginal)
       return resizedImage
   }
}
