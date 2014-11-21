//
//  ModalViewController.h
//  Template Framework Project
//
//  Created by Pooria Azimi on 11/20/14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;

@property UIImage* image;

- (IBAction)dismiss:(id)sender;

@end
