//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"
#import "AFNetworking.h"


@implementation G8ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = @[
                  [@{
                      @"path": @"image_0.jpg",
                      @"size": @11356,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      } mutableCopy],
                  [@{
                      @"path": @"image_1.jpg",
                      @"size": @13062,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      } mutableCopy],
                  [@{
                      @"path": @"image_2.jpg",
                      @"size": @128777,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      } mutableCopy],
                  [@{
                      @"path": @"image_3.jpg",
                      @"size": @103639,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      } mutableCopy],
                  [@{
                     @"path": @"image_4.jpg",
                     @"size": @256101,
                     @"offline_secs": @0,
                     @"online_secs": @0,
                     @"offline_finished": @NO,
                     @"online_finished": @NO
                     } mutableCopy],
                  [@{
                     @"path": @"image_4_2.jpg",
                     @"size": @19992,
                     @"offline_secs": @0,
                     @"online_secs": @0,
                     @"offline_finished": @NO,
                     @"online_finished": @NO
                     } mutableCopy],
                  [@{
                      @"path": @"image_5.jpg",
                      @"size": @103084,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      } mutableCopy],
                  [@{
                      @"path": @"image_6.jpg",
                      @"size": @156564,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      } mutableCopy],
                  [@{
                     @"path": @"image_7.jpg",
                     @"size": @2371330,
                     @"offline_secs": @0,
                     @"online_secs": @0,
                     @"offline_finished": @NO,
                     @"online_finished": @NO
                     } mutableCopy],
                  [@{
                     @"path": @"image_7_2.jpg",
                     @"size": @363112,
                     @"offline_secs": @0,
                     @"online_secs": @0,
                     @"offline_finished": @NO,
                     @"online_finished": @NO
                     } mutableCopy]
                  ];
    
    self.progressLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark -
#pragma mark tesseract


-(void)recognizeImageWithTesseract:(NSInteger)index
{
    NSDate *start = [NSDate date];
    UIImage *image = [UIImage imageNamed:self.data[index][@"path"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator startAnimating];
	});
    
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    [tesseract setImage:image];
    [tesseract recognize];
    
    NSString *recognizedText = [tesseract recognizedText];
    
    NSTimeInterval timeInterval = 0 - [start timeIntervalSinceNow];
    NSLog(@"%@", recognizedText);
    
    
    self.data[index][@"offline_finished"] = @YES;
    self.data[index][@"offline_secs"] = @( timeInterval );
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        self.progressLabel.text = @"";
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    });
    tesseract = nil; //deallocate and free all memory
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = [NSString stringWithFormat:@"Progress: %d%%", [tesseract progress]];
    });
    
    return NO; // return YES, if you need to interrupt tesseract before it finishes
}




#pragma mark -
#pragma mark tesseract cloud



- (void)recognizeImageWithTesseractCloud:(NSInteger)index
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDate *start = [NSDate date];
    
    UIImage *image = [UIImage imageNamed:self.data[index][@"path"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator startAnimating];
        self.progressLabel.text = @"Sending...";
    });
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//        NSString *imagePostUrl = @"http://poorias-macbook-pro.local:8000";
//        NSString *imagePostUrl = @"http://169.254.251.230:8000";
    NSString *imagePostUrl = @"http://104.236.190.152";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:imagePostUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"asd" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:request
          success: ^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"response: %@", responseObject);
              
              NSTimeInterval timeInterval = 0 - [start timeIntervalSinceNow];
              
              self.data[index][@"online_finished"] = @YES;
              self.data[index][@"online_secs"] = @( timeInterval );
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.activityIndicator stopAnimating];
                  self.progressLabel.text = @"";
                  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
              });

          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.activityIndicator stopAnimating];
                  self.progressLabel.text = @"Error!";
              });
              
          }];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [[NSOperationQueue mainQueue] addOperation:op];
    
#pragma clang diagnostic pop
}





#pragma mark -
#pragma mark table view


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *thumbnail_path = [NSString stringWithFormat:@"thumb_%@", self.data[indexPath.row][@"path"]];
    cell.imageView.image = [UIImage imageNamed:thumbnail_path];
    
    // construct the text, e.g., "--/10s" or "12s/15s"
    NSString *offlineDetailText = @"";
    BOOL offline_finished = [self.data[indexPath.row][@"offline_finished"] boolValue];
    if (offline_finished) {
        NSNumber *offline_secs = self.data[indexPath.row][@"offline_secs"];
        offlineDetailText = [NSString stringWithFormat:@"%.2fs", [offline_secs floatValue]];
    } else {
        offlineDetailText = @"--";
    }
    
    NSString *onlineDetailText = @"";
    BOOL online_finished = [self.data[indexPath.row][@"online_finished"] boolValue];
    if (online_finished) {
        NSNumber *online_secs = self.data[indexPath.row][@"online_secs"];
        onlineDetailText = [NSString stringWithFormat:@"%.2fs", [online_secs floatValue]];
    } else {
        onlineDetailText = @"--";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@", offlineDetailText, onlineDetailText];
    cell.textLabel.text = [self.data[indexPath.row][@"path"] stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if ([self.localSwitch isOn]) {
            [self recognizeImageWithTesseractCloud:indexPath.row];
        } else {
            [self recognizeImageWithTesseract:indexPath.row];
        }

    });
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"displayModal" sender:indexPath];

}






#pragma mark -
#pragma mark modal segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"displayModal"]) {
        NSIndexPath *indexPath = sender;
        ModalViewController* dest = segue.destinationViewController;
        
        dest.image = [UIImage imageNamed:self.data[indexPath.row][@"path"]];
        dest.size = self.data[indexPath.row][@"size"];
        dest.title = [NSString stringWithFormat:@"image_%02ld.jpg", (long)indexPath.row];
    }
}




@end
