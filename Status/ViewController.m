//
//  ViewController.m
//  Status
//
//  Created by Steve Spencer on 12/9/15.
//  Copyright © 2015 Steve Spencer. All rights reserved.
//

#import "ViewController.h"
#import "StatusView.h"

@interface ViewController()
@property (weak) IBOutlet StatusView *statusView;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)updateStatus:(NSArray *)statusList {
    [self.statusView updateStatus:statusList];
}

@end
