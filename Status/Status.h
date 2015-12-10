//
//  Status.h
//  Status
//
//  Created by Steve Spencer on 12/9/15.
//  Copyright © 2015 Steve Spencer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Status : NSObject

@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSString *label;

+(instancetype)statusWithLabel:(NSString *)label color:(NSColor *)color;

@end
