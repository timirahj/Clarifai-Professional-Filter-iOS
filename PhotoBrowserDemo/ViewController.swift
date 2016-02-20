//
//  ViewController.swift
//  PhotoBrowserDemo
//
//  Created by Simon Gladman on 08/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PhotoBrowserDelegate {
    
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
    let photoBrowser = PhotoBrowser(returnImageSize: CGSize(width: 640, height: 640))
    let launchBrowserButton = UIButton()
    let imageView: UIImageView = UIImageView(frame: CGRectZero)

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor()
        
        launchBrowserButton.setTitle("Launch Photo Browser", forState: UIControlState.Normal)
        launchBrowserButton.addTarget(self, action: "launchPhotoBrowser", forControlEvents: UIControlEvents.TouchDown)
        
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 2
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        view.addSubview(imageView)
        view.addSubview(launchBrowserButton)
    }

    func launchPhotoBrowser()
    {
        
        photoBrowser.delegate = self
        photoBrowser.launch()
        
    }
    
    func photoBrowserDidSelectImage(image: UIImage, localIdentifier: String)
    {
        imageView.image = image
        recognizeImage(image)
    }

    override func viewDidLayoutSubviews()
    {
        let topMargin = topLayoutGuide.length
        let imageViewSide = min(view.frame.width, view.frame.height - topMargin) - 75
 
        imageView.frame = CGRect(x: view.frame.width / 2 - imageViewSide / 2,
            y: view.frame.height / 2 - imageViewSide / 2,
            width: imageViewSide,
            height: imageViewSide)
        
        launchBrowserButton.frame = CGRect(x: 0, y: view.frame.height - 40, width: view.frame.width, height: 40)
    }

    
    //Image Recognition . . .
    private func recognizeImage(image: UIImage?) {
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
            if error != nil {
                print("Error: \(error)\n")
              //  self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                //self.textView.text = "Tags:\n" + results![0].tags.joinWithSeparator(", ")
                print("Tags:\"\(results![0].tags)")
            }
           // self.button.enabled = true
        }
    }
    
    

}

