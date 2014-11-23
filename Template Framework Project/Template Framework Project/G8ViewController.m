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
    self.data = @[
                  @{
                      @"path": @"image_00.jpg",
                      @"size": @13062,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_01.jpg",
                      @"size": @128777,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_02.jpg",
                      @"size": @11356,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_03.jpg",
                      @"size": @153842,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_04.jpg",
                      @"size": @202530,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_05.jpg",
                      @"size": @103084,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_06.jpg",
                      @"size": @156564,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_07.jpg",
                      @"size": @76523,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_08.jpg",
                      @"size": @93771,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_09.jpg",
                      @"size": @132985,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_10.jpg",
                      @"size": @256101,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_11.jpg",
                      @"size": @2371330,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_12.jpg",
                      @"size": @1376411,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_13.jpg",
                      @"size": @16965,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      },
                  @{
                      @"path": @"image_14.jpg",
                      @"size": @103639,
                      @"offline_secs": @0,
                      @"online_secs": @0,
                      @"offline_finished": @NO,
                      @"online_finished": @NO
                      }
                  ];
    
    self.progressLabel.text = @"";
}

-(void)recognizeImageWithTesseract:(UIImage *)img
{
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator startAnimating];
//        [[UIScreen mainScreen] setBrightness:1.0];
	});
    
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    [tesseract setImage:img];
    [tesseract recognize];
    
    NSString *recognizedText = [tesseract recognizedText];
    
    NSLog(@"%@", recognizedText);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
//        [[UIScreen mainScreen] setBrightness:0.2];
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
    
    return NO; // return YES, if you need to interrupt tesseract before it finishes
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)startTest:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self recognizeImageWithTesseract:[UIImage imageNamed:self.data[2][@"path"]]];
	});
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
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
    cell.detailTextLabel.text = @"14s / 25s";
    cell.textLabel.text = @"";
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self recognizeImageWithTesseract:[UIImage imageNamed:self.data[indexPath.row][@"path"]]];
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
        
        dest.image = [UIImage imageNamed:self.data[indexPath.row][@"path"]];
        dest.size = self.data[indexPath.row][@"size"];
        dest.title = [NSString stringWithFormat:@"image_%02ld.jpg", (long)indexPath.row];
    }
}




@end
