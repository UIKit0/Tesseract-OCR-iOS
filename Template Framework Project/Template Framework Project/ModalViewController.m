//
//  ModalViewController.m
//  Template Framework Project
//
//  Created by Pooria Azimi on 11/20/14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "ModalViewController.h"

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.topItem.title = self.title;
    self.imageView.image = self.image;
    self.detailLabel.text = [NSString stringWithFormat:@"%.0f x %.0f pixels", self.image.size.width, self.image.size.height];
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
