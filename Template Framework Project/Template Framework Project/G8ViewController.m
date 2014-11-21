//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"


@implementation G8ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressLabel.text = @"";
}

-(void)recognizeImageWithTesseract:(UIImage *)img
{
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator startAnimating];
	});
    
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    [tesseract setImage:img];
    [tesseract recognize];
    
    NSString *recognizedText = [tesseract recognizedText];
    
    NSLog(@"%@", recognizedText);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        self.progressLabel.text = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tesseract OCR iOS" message:recognizedText delegate:nil cancelButtonTitle:@"Yeah!" otherButtonTitles:nil];
        [alert show];
        
    });
    tesseract = nil; //deallocate and free all memory
}


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = [NSString stringWithFormat:@"Progress: %d%%", [tesseract progress]];
    });
    
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)startTest:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self recognizeImageWithTesseract:[self imageIndexed:3]];
	});
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UIImage *)imageIndexed:(NSInteger)index {
    NSString* file_name = [NSString stringWithFormat:@"image_%02d.jpg", index];
    return [UIImage imageNamed:file_name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.imageView.image = [self imageIndexed:indexPath.row];
    cell.detailTextLabel.text = @"";
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self recognizeImageWithTesseract:[self imageIndexed:indexPath.row]];
    });
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"displayModal" sender:indexPath];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"displayModal"]) {
        NSIndexPath *indexPath = sender;
        ModalViewController* dest = segue.destinationViewController;
        
        dest.image = [self imageIndexed:indexPath.row];
        dest.title = [NSString stringWithFormat:@"image_%02d.jpg", indexPath.row];
    }
}




@end
