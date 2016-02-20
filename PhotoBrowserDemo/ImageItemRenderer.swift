//
//  ImageItemRenderer.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 31/12/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import Photos

class ImageItemRenderer: UICollectionViewCell, PHPhotoLibraryChangeObserver
{
    let label = UILabel(frame: CGRectZero)
    let imageView = UIImageView(frame: CGRectZero)
    let blurOverlay = UIVisualEffectView(effect: UIBlurEffect())
    
    let manager = PHImageManager.defaultManager()
    let deliveryOptions = PHImageRequestOptionsDeliveryMode.Opportunistic
    let requestOptions = PHImageRequestOptions()
    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    
    // Create an instance of ClafirfaiClient
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    var notSuitable: Bool = false
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        requestOptions.deliveryMode = deliveryOptions
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.Exact
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        label.numberOfLines = 0
  
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.Center
        
        contentView.addSubview(imageView)
        contentView.addSubview(blurOverlay)
        contentView.addSubview(label)
        
        layer.borderColor = UIColor.darkGrayColor().CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    override func layoutSubviews()
    {
        imageView.frame = bounds
        
        let labelFrame = CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20)
        
        blurOverlay.frame = labelFrame
        label.frame = labelFrame
    }
    
    deinit
    {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    var asset: PHAsset?
    {
        didSet
        {
            if let asset = asset
            {
                dispatch_async(dispatch_get_global_queue(priority, 0))
                {
                   // self.setLabel()
                    self.manager.requestImageForAsset(asset,
                        targetSize: self.frame.size,
                        contentMode: PHImageContentMode.AspectFill,
                        options: self.requestOptions,
                        resultHandler: self.requestResultHandler)
                }
            }
        }
    }
    
    
    func photoLibraryDidChange(changeInstance: PHChange)
    {
 //       dispatch_async(dispatch_get_main_queue(), { self.setLabel() })
    }

    func requestResultHandler (image: UIImage?, properties: [NSObject: AnyObject]?) -> Void
    {
        PhotoBrowser.executeInMainQueue({self.imageView.image = image})
        
        //recognize the image here
        recognizeImage(image)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //Image Recognition . . .
    internal func recognizeImage(image: UIImage?) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image!.size.height / image!.size.width)
        UIGraphicsBeginImageContext(size)
        image!.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!
        
        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            
            //Print error should anything go wrong
            if error != nil {
                print("Error: \(error)\n")
                
            } else {
                //Print all tag results for all photos
                print("Tags:\"\(results![0].tags)")
                
                //All innapropriate words that aren't suitable to post
                if results![0].tags.contains("sexy") || results![0].tags.contains("sex") || results![0].tags.contains("flirt") || results![0].tags.contains("porn") || results![0].tags.contains("bathing suit") || results![0].tags.contains("kissing") || results![0].tags.contains("naked") || results![0].tags.contains("crazy") || results![0].tags.contains("bra") || results![0].tags.contains("panties") || results![0].tags.contains("lingerie") || results![0].tags.contains("nude") || results![0].tags.contains("underwear") || results![0].tags.contains("cleavage"){
                    
                    self.notSuitable = true
                    print("DO NOT POST!")
                    
                    //Update UI
                    self.label.text = "Not Suitable!"
                    self.label.textColor = UIColor.redColor()
                    
                }
                  else {
                    
                    //Update UI
                    self.notSuitable = false
                    self.label.text = "Postable!"
                    self.label.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
                }
                
            }
        }
    }
    

}

