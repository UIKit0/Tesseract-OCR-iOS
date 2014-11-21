//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"

@interface G8ViewController ()
{
    
}
@end

@implementation G8ViewController

/****README****/
/*
 Tessdata folder is into the template project..
 TesseractOCR.framework is linked into the template project under the Framework group. It's builded by the main project.
 
 If you are using iOS7 or greater, import libstdc++.6.0.9.dylib (not libstdc++)!!!!!
 
 Follow the readme at https://github.com/gali8/Tesseract-OCR-iOS for first step.
 */



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startTest:nil];
}

-(void)recognizeImageWithTesseract:(UIImage *)img
{
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator startAnimating];
        self.imageToRecognize.image = img;
	});
    
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    [tesseract setImage:[img blackAndWhite]];
    [tesseract recognize];
    
    NSString *recognizedText = [tesseract recognizedText];
    
    NSLog(@"%@", recognizedText);
    
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tesseract OCR iOS" message:recognizedText delegate:nil cancelButtonTitle:@"Yeah!" otherButtonTitles:nil];
        [alert show];
        
    });
    
    tesseract = nil; //deallocate and free all memory
}


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract {
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)startTest:(id)sender {
    NSLog(@"start");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self recognizeImageWithTesseract:[UIImage imageNamed:@"image_sample.jpg"]];
	});
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"image_sample.jpg"];
    cell.textLabel.text = @"test";
    return cell;
}



@end
