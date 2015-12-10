//
//  Status.m
//  Status
//
//  Created by Steve Spencer on 12/9/15.
//  Copyright © 2015 Steve Spencer. All rights reserved.
//

#import "Status.h"

@implementation Status

+(instancetype)statusWithLabel:(NSString *)label color:(NSColor *)color {

    Status *status = [[Status alloc] init];
    status.label = label;
    status.color = color;

    return status;
}

@end
