//
//  G8ViewController.h
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import "ModalViewController.h"

@interface G8ViewController : UIViewController <TesseractDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)startTest:(id)sender;

@end
