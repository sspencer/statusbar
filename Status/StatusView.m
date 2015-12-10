//
//  StatusView.m
//  Status
//
//  Created by Steve Spencer on 12/9/15.
//  Copyright © 2015 Steve Spencer. All rights reserved.
//

#import "StatusView.h"
#import "Status.h"

#define PADDING 20
#define SIZE 180

@interface StatusView ()

@property (nonatomic, strong) NSArray *statuses;
@end


@implementation StatusView


- (void)updateStatus:(NSArray *)statuses {
    self.statuses = statuses;
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    CGFloat height = self.bounds.size.height - (SIZE + PADDING);
    CGFloat xoffset = PADDING;

    for (Status *s in self.statuses) {
        NSColor *fillColor = s.color;
        [self drawAt:NSMakePoint(xoffset, height) color:fillColor text:s.label];
        xoffset += (PADDING*2) + SIZE;
    }
}

-(void)drawAt:(CGPoint)point color:(NSColor*)fillColor text:(NSString *)labelText {
    // Drawing code here.
    //// Color Declarations
    NSColor *innerShadowColor = [NSColor colorWithCalibratedWhite:0.88 alpha:1];
    NSColor *outerShadowColor = [NSColor colorWithCalibratedWhite:0.33 alpha:1.0];
    NSColor* borderColor = [NSColor colorWithCalibratedHue: [fillColor hueComponent] saturation: [fillColor saturationComponent] brightness: 0.8 alpha: [fillColor alphaComponent]];
    NSColor* labelColor = [NSColor colorWithCalibratedRed: 0.167 green: 0.167 blue: 0.167 alpha: 1];

    //// Shadow Declarations
    NSShadow* innerShadow = [[NSShadow alloc] init];
    [innerShadow setShadowColor: [innerShadowColor colorWithAlphaComponent: 0.7]];
    [innerShadow setShadowOffset: NSMakeSize(6, -6)];
    [innerShadow setShadowBlurRadius: 14];
    NSShadow* outerShadow = [[NSShadow alloc] init];
    [outerShadow setShadowColor: [outerShadowColor colorWithAlphaComponent: 0.3]];
    [outerShadow setShadowOffset: NSMakeSize(5, -5)];
    [outerShadow setShadowBlurRadius: 10];

    //// Oval Drawing
    NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(point.x, point.y, SIZE, SIZE)];
    [NSGraphicsContext saveGraphicsState];
    [outerShadow set];
    [fillColor setFill];
    [ovalPath fill];

    ////// Oval Inner Shadow
    NSRect ovalBorderRect = NSInsetRect([ovalPath bounds], -innerShadow.shadowBlurRadius, -innerShadow.shadowBlurRadius);
    ovalBorderRect = NSOffsetRect(ovalBorderRect, -innerShadow.shadowOffset.width, -innerShadow.shadowOffset.height);
    ovalBorderRect = NSInsetRect(NSUnionRect(ovalBorderRect, [ovalPath bounds]), -1, -1);

    NSBezierPath* ovalNegativePath = [NSBezierPath bezierPathWithRect: ovalBorderRect];
    [ovalNegativePath appendBezierPath: ovalPath];
    [ovalNegativePath setWindingRule: NSEvenOddWindingRule];

    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* innerShadowWithOffset = [innerShadow copy];
        CGFloat xOffset = innerShadowWithOffset.shadowOffset.width + round(ovalBorderRect.size.width);
        CGFloat yOffset = innerShadowWithOffset.shadowOffset.height;
        innerShadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [innerShadowWithOffset set];
        [[NSColor grayColor] setFill];
        [ovalPath addClip];

        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(ovalBorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: ovalNegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];

    [NSGraphicsContext restoreGraphicsState];

    [borderColor setStroke];
    [ovalPath setLineWidth: 2];
    [ovalPath stroke];


    //// Text Drawing
    NSRect textRect = NSMakeRect(point.x-PADDING, point.y - PADDING - 10, SIZE+PADDING*2, 20);
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSCenterTextAlignment];

    NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSFont boldSystemFontOfSize: 14], NSFontAttributeName,
                                        labelColor, NSForegroundColorAttributeName,
                                        textStyle, NSParagraphStyleAttributeName, nil];
    
    [labelText drawInRect: NSOffsetRect(textRect, 0, 1) withAttributes: textFontAttributes];
    
    
}

@end
