# Clarifai Professional Filter: iOS (Swift)

Inappropriate Photo Detection: An Example of how to use [Clarifai's Photo Recognition API](https://www.clarifai.com)

![screenshot](/PhotoBrowserDemo/IMG_8205.png)

## Why is this Awesome?!?
Your social media presence has the power to speak volumes about your character! Ever think about employers sniffing through your social media profiles? Ever debate whether or not your photo is too risque to post (when you have relatives and other family members following you)? What if there was a magical filter to do the pondering for you (in less than 2 seconds)?

We're gonna go through how you can eliminate your "second-thought" process when it comes to your photos, by building that magical filter using Clarifai's awesome Photo Recognition API!


## First things first:

* Create an account at [developer.clarifai.com](https://www.developer.clarifai.com)
* Create an application to generate you Client ID and Client Secret, you'll need to enter these credentials in the '**Credentials.swift**' file as so: 

```

let clarifaiClientID = "YOUR_CLIENT_ID_HERE"                                 
let clarifaiClientSecret = "YOUR_CLIENT_SECRET_HERE" 

```

## Photo Recognition
Clarifai's Photo Recognition method can be utilized by first creating and initializing the ClarifaiClient object to gain access to those super important elements that we talked about:

### **ImageItemRenderer.swift**
```
private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
```

### How does it work?
Here is the magical method for we're gonna use for image recognition:
```
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
                if results![0].tags.contains("sexy") || results![0].tags.contains("flirt")  || results![0].tags.contains("bathing suit") || results![0].tags.contains("kissing") || results![0].tags.contains("crazy") {
                    
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

```
### What's happening?
This function grabs the UIImage from each of our photos, scales them down to a reasonable size, and translates them as JPEG files. Then, it forwards those jpeg files to Clarifai and tells it to start recognizing them with this line of code:

```
client.recognizeJpegs([jpeg]) 
```

It then saves the jpegs as an array of **ClarifaiResult** objects, before doing a little error handling:

```
client.recognizeJpegs([jpeg]) {
           (results: [ClarifaiResult]?, error: NSError?) in
            
            //Print error should anything go wrong
            if error != nil {
                print("Error: \(error)\n")
                
            } 
```
If we're clear on errors, now's our chance to execute our rules for our image tags. In this case, we need to pin-point all images containing our forbidden keywords (feel free to add in whatever tags you desire!).

```
else {
                //Print all tag results for all photos
                print("Tags:\"\(results![0].tags)")
                
                //All innapropriate words that aren't suitable to post
                if results![0].tags.contains("sexy") || results![0].tags.contains("flirt")  || results![0].tags.contains("bathing suit") || results![0].tags.contains("kissing") || results![0].tags.contains("crazy") {
                
                //do something

```

Pretty straight forward right? Here we're saying if any of the images contain any of our forbidden keywords, we want to do something about it! In the app, we add a label onto our images, and update them accordingly depending upon wheteher they are appropriate or not. 

                    //Update UI
                    self.label.text = "Not Suitable!"
                    self.label.textColor = UIColor.redColor()
              }

If our images are appropriate, we update the UI accordingly as well.
```
              else {
                    //Update UI
                    self.notSuitable = false
                    self.label.text = "Postable!"
                    self.label.textColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
                }
                
            }

```
And finally, we need somwhere to call our function right?! In this case, since we are using [PhotoBrowserDemo](https://github.com/FlexMonkey/PhotoBrowserDemo), we're going to need to implement this method as the results are being fetched from our Photos Library:
```
 func requestResultHandler (image: UIImage?, properties: [NSObject: AnyObject]?) -> Void
    {
        PhotoBrowser.executeInMainQueue({self.imageView.image = image})
        
        //call image reconition method
        recognizeImage(image)
    }

```

And that's all folks! There you have it! Your very own magical appropriate image filter. :)

Round of applause to #TeamClarifai for such majestic and straight forward code!!!

## (Courtesy: PhotoBrowserDemo)
**PhotoBrowserDemo** is the library where the main elements of the interface were built, and where all the photos are being fetched (using PHImageManager).

The source code for the original **PhotoBrowserDemo** project can be found using the link below: 
https://github.com/FlexMonkey/PhotoBrowserDemo


# Author
### Timirah James, iOS Engineer
