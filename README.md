# Clarifai Professional Filter: iOS (Swift)
Inappropriate Photo Detection using [Clarifai's Photo Recognition API](https://www.clarifai.com)

![screenshot](/PhotoBrowserDemo/IMG_8205.png)


## First things first:

* Create an account at [developer.clarifai.com](https://www.developer.clarifai.com)
* Create an application to generate you Client ID and Client Secret, you'll need to enter these credentials in the 'Credentials.swift' file as so: 

```

let clarifaiClientID = "YOUR_CLIENT_ID_HERE"                                 
let clarifaiClientSecret = "YOUR_CLIENT_SECRET_HERE" 

```

## Photo Recognition
Clarifai's Photo Recognition method can be utilized by first creating and initializing the ClarifaiClient object to gain access to those super important elements that we talked about:

```
private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)

```
## (Courtesy: PhotoBrowserDemo)
**PhotoBrowserDemo** is the library where the main elements of the interface were built, and where all the photos are being fetched (using PHImageManager).

The source code for the original **PhotoBrowserDemo** project can be found using the link below: 
https://github.com/FlexMonkey/PhotoBrowserDemo
