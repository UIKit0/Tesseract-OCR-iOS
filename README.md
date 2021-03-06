Tesseract OCR iOS 3.03 (Leptonica 1.70)
=================

**Tesseract OCR iOS is a Framework for iOS5+.**

It helps you to use OCR in iOS projects, writing Objective-C. Easy and fast.

Getting Started
=================

Use the provided template project
------------------------
You can use the "**Template Framework Project**" from this repository. It's a starting point for use the Tesseract Framework. It's iOS7 and arm64 ready!

Into the tessdata folder (linked like a referenced folder into the project), there are the .traineddata language files.

Integrate into an existing project
------------------------
### Option 1: Using [CocoaPods](http://cocoapods.org)
#### Stable version
Add the following line to your Podfile then run `pod update` 

```
pod 'TesseractOCRiOS', '~> 2.2'
```
#### Development version
Add the following line to your Podfile then run `pod update` 

```
pod 'TesseractOCRiOS', :git => 'https://github.com/gali8/Tesseract-OCR-iOS.git'
```
** WARNING **: This uses the GitHub repository's master branch as the source for the library. This is not based off of any Tesseract OCR iOS release.

### Option 2: Manual installation
Copy the framework "TesseractOCR.framework" (you can drag&drop it) from the **Products** folder in this repo, to your XCode Project under the frameworks folder.

### Option 3: Build from source
If you are masochist :) you can generate your TesseractOCR.framework building the **TesseractOCRAggregate** target. 

Now...

- If you are using **iOS7** or greater, link <code>libstdc++.6.0.9.dylib</code> library (Your target => General => Linked Frameworks and Libraries => + => libstdc++.6.0.9)

- Go to your project, click on the project and in the Build Settings tab add <code>-lstdc++</code> to all the "Other Linker Flags" keys.

- Go to your project settings, and ensure that C++ Standard Library => Compiler Default. (thanks to https://github.com/trein)

- Copy and import the <code>tessdata</code> folder from the Template Framework Project under the root of your project. It contains the "tessdata" files. You can add more tessdata files copyng them here.

WARNING: Check the "Create folder references for any added folders" option and the correct target into the "Add to Targets" section.

- Link the <code>CoreImage.framework</code>

- Import the header in your classes writing <code>#import &lt;TesseractOCR/TesseractOCR.h&gt;</code>

<br/>
Usage
=======

### Objective-C

**MyViewController.h**

```Objective-C
#import <TesseractOCR/TesseractOCR.h>
@interface MyViewController : UIViewController <TesseractDelegate>
@end
```

**MyViewController.m**

```Objective-C
- (void)viewDidLoad
{
     [super viewDidLoad];

	// language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory; eng+ita will search for a eng.traineddata and ita.traineddata.
	
	//Like in the Template Framework Project:
	// Assumed that .traineddata files are in your "tessdata" folder and the folder is in the root of the project.
	// Assumed, that you added a folder references "tessdata" into your xCode project tree, with the ‘Create folder references for any added folders’ options set up in the «Add files to project» dialog.
	// Assumed that any .traineddata files is in the tessdata folder, like in the Template Framework Project
	
	//Create your tesseract using the initWithLanguage method:
	// Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"<strong>eng+ita</strong>"];
	
	// set up the delegate to recieve tesseract's callback
	// self should respond to TesseractDelegate and implement shouldCancelImageRecognitionForTesseract: method
	// to have an ability to recieve callback and interrupt Tesseract before it finishes
	
	Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
	tesseract.delegate = self;
	
	[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
	[tesseract setImage:[[UIImage imageNamed:@"image_sample.jpg"] blackAndWhite]]; //image to check
	[tesseract setRect:CGRectMake(20, 20, 100, 100)]; //optional: set the rectangle to recognize text in the image
	[tesseract recognize];
	
	NSLog(@"%@", [tesseract recognizedText]);
	
	tesseract = nil; //deallocate and free all memory
}


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}
```

Set Tesseract variable key to value. See http://www.sk-spell.sk.cx/tesseract-ocr-en-variables for a complete (but not up-to-date) list.

For instance, use tessedit_char_whitelist to restrict characters to a specific set.

###Swift 
Make sure that you have used an Objective-c bridging header to include the library. Instructions on configuring a bridging header file can be found in the [Apple Developer Library](https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-XID_77).

**ViewController.swift**

```Swift
import UIKit

class ViewController: UIViewController, TesseractDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        var tesseract:Tesseract = Tesseract();
        tesseract.language = "eng+ita";
        tesseract.delegate = self;
        tesseract.setVariableValue("01234567890", forKey: "tessedit_char_whitelist");
        tesseract.image = UIImage(named: "image_sample.jpg");
        tesseract.recognize();

        NSLog("%@", tesseract.recognizedText);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: Tesseract!) -> Bool {
        return false; // return true, if you need to interrupt tesseract before it finishes
    }
}
```

Known Limitations
=================

- Not OS X support. iOS simulators are supported only for 32bit version.

Updates in this version 
=================
### 3.03 (Thanks to [Kevin Conley](https://github.com/kevincon))
- This update fixes the confidence value issue I reported in #56
- fixed the memory leak
- Modified characterBoxes function to return characters in order
- Removed unused lib files
- Added some null checks to fix a bug where no text is recognized
- **Note**: Building the Tesseract OCR Aggregate product will yield a warning about how the Tesseract and Leptonica lib files don't work for the x86_64 architecture. However, everything still works in the simulator for iPhone 5 and lower, as well as on all physical devices. I guess because the libraries work okay with the i386 target.
- New implementation based off the [API examples for tesseract-ocr](https://code.google.com/p/tesseract-ocr/wiki/APIExample#Result_iterator_example)

### 2.3
- Bug fixing.
- CoreImage filters: use <code>[img blackAndWhite];</code> to convert the UIImage to recognize into a RecognizeImageType
- Rect: use <code>[tesseract setRect:CGRectMake(20, 20, 100, 100)]</code> to define the rect where the text must be recognized

### 2.23 
- There is no need to draw an image for tesseract.
Instead it's possible just to get raw data from the input image.
Such way is better, cause in the case of the grayscale input image, there is no need to draw it in RGB color space, increasing memory consumptions significantly.


### 2.22 
- CocoaPods

### 2.21 
- tesserackCallbackFunction: leak solved on iDevice. 

### The 2.2 is like 2.1... 
but shouldCancelImageRecognitionForTesseract works again! Thank you to Timo Formella! 

- Template project updated. Now with camera support.

### New release 2.1

- Fixed memory leaks. Moved all freeing memory job to dealloc. Thanks to frank4565.
- Clear method is deprecated. Set tesseract = nil; to free all memory.
- Free the utf8Text according to the comment in Tesseract that “The recognized text is returned as a char* which is coded as UTF8 and must be freed with the delete [] operator.”.
- Template Framework Project updated.

### New release 2.0 with 64 bit support.

- The - (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language method is now deprecated. 
- Bug fixing!
- Removed tessdata folder from the framework project.
- The tessdata folder (follow the Template Framework Project) is now linked with the "folder references" option into the Template Project. <strong>REQUIRED!!!</strong>
- Added delegate TesseractDelegate
- arm64 support. Thanks to Cyril
- Now you can compile yours libraries. Follow the README_howto_compile_libaries.md inside. Thanks to Simon Strangbaard
- Framework updated
- Bugs fixed. Thanks to Simon Strangbaard
- iOS7 libstdc++ issue solved (using libstdc++.6.0.9). 
- **Template Framework Project added.** It's the start point for use the Tesseract Framework. It's **iOS7** ready!
- 11 october 2013, tesseract is up to date with last https://github.com/ldiqual/tesseract-ios version available.
- Clear method updated:<pre><code>[tesseract clear]; //call Clear() end End() functions</code></pre>
- XCode 5 ready!
- Framework builded with the new Xcode 5.

Dependencies
=================

Tesseract OCR iOS use UIKit, Foundation and CoreFoundation. They are already included in standard iOS Projects.

License
=================

Tesseract OCR iOS and TesseractOCR.framework are under MIT License.

Tesseract, powered by Google http://code.google.com/p/tesseract-ocr/, is under Apache License.


Author Infos
=================

Daniele Galiotto - iOS Freelance Developer - **www.g8production.com**

