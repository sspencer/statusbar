//
//  AppDelegate.m
//  Status
//
//  Created by Steve Spencer on 12/9/15.
//  Copyright © 2015 Steve Spencer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Status.h"

#define UDP_PORT 9099


@interface AppDelegate ()
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) NSDictionary *colors;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    _colors = [self createColors];
    _socket = [self createSocket:[self getPort:UDP_PORT]];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (_viewController==nil) {
        _viewController = (ViewController *)[[NSApplication sharedApplication] mainWindow].contentViewController;
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    if (self.socket) {
        [self.socket close];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

#pragma mark - socket listener

-(void)udpSocket:(GCDAsyncUdpSocket *)sock
  didReceiveData:(NSData *)data
     fromAddress:(NSData *)address withFilterContext:(id)filterContext {

    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"UDP: %@", msg);

    if ([msg isEqualToString:@"quit"]) {
        [[NSApplication sharedApplication] terminate:nil];
    } else {

        NSArray *msgList = [msg componentsSeparatedByString:@","];
        NSMutableArray *statuses = [NSMutableArray arrayWithCapacity: [msgList count]];
        for (NSString *s in msgList) {
            [statuses addObject:[self createStatus:s]];
        }

        [self.viewController updateStatus:statuses];
    }

}

#pragma mark - Utils

- (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSDictionary *)createColors {
    NSMutableDictionary *colors = [[NSMutableDictionary alloc] initWithCapacity:16];
    colors[@"black"] =[NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 1];
    colors[@"blue"] =[NSColor colorWithCalibratedRed: 4.0/255 green: 51.0/255.0 blue: 1 alpha: 1];
    colors[@"cyan"] =[NSColor colorWithCalibratedRed: 0 green: 253.0/255.0 blue: 1 alpha: 1];
    colors[@"green"] =[NSColor colorWithCalibratedRed: 0 green: 234.0/255.0 blue: 0 alpha: 1];
    colors[@"magenta"] =[NSColor colorWithCalibratedRed: 1 green: 64.0/255.0 blue: 1 alpha: 1];
    colors[@"orange"] = [NSColor colorWithCalibratedRed: 1.0 green: 147.0/255.0 blue: 0 alpha: 1];
    colors[@"purple"] =[NSColor colorWithCalibratedRed: 148.0/255 green: 21.0/255.0 blue: 146.0/255.0 alpha: 1];
    colors[@"red"] = [NSColor colorWithCalibratedRed: 1.0 green: 38.0/255.0 blue: 0 alpha: 1];
    colors[@"yellow"] =[NSColor colorWithCalibratedRed: 1 green: 251.0/255.0 blue: 0 alpha: 1];
    colors[@"off"] = [NSColor colorWithCalibratedRed:0.88 green:0.88 blue:0.88 alpha:1];
    return colors;
}

-(GCDAsyncUdpSocket *)createSocket:(NSUInteger)port {

    GCDAsyncUdpSocket *sock;
    NSError *error = nil;

    sock = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    [sock bindToPort:port error:&error];
    if (error) {
        NSLog(@"Failed to bind to UDP Port %lu: %@", (unsigned long)port, [error localizedDescription]);
        return nil;
    }

    [sock beginReceiving:&error];
    if (error) {
        NSLog(@"Failed to receive on UDP Port %lu: %@", port, [error localizedDescription]);
        return nil;
    }

    NSString *msg =[NSString stringWithFormat:@"StatusBar listening on UDP Port %lu", port];
    fprintf(stdout, "%s\n", [msg UTF8String]);
    //NSLog(@"%@", msg);
    return sock;
}


- (Status *)createStatus:(NSString *)msg {
    NSArray *comps = [msg componentsSeparatedByString:@":"];

    // color:label
    NSString *color = [self trim:comps[0]];
    NSString *label = @"";

    if ([comps count] >= 2) {
        label = [self trim:comps[1]];
    }

    if (self.colors[color]) {
        return [Status statusWithLabel:label color:self.colors[color]];
    } else {
        return [Status statusWithLabel:label color:self.colors[@"off"]];
    }

    return [Status statusWithLabel:@"" color:self.colors[@"off"]];
}

-(NSUInteger) getPort:(NSUInteger)port {
    //NSString *p = [NSString stringWithFormat:@"%d", defaultPort];

    NSArray *args = [[NSProcessInfo processInfo] arguments];
    NSLog(@"ARGS: %@", args);
    
    NSUInteger cnt = [args count];
    NSUInteger newPort = 0;
    for (int i = 0; i < cnt; i++) {
        NSString *arg = args[i];
        if (([arg isEqualToString:@"-p"] || [arg isEqualToString:@"-port"]) && i < (cnt-1)) {
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            fmt.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [fmt numberFromString:args[i+1]];
            newPort = [number integerValue];
        } else if ([arg isEqualToString:@"-h"] || [arg isEqualToString:@"-help"]) {
            NSString *msg = @"USAGE: StatusBar [-port <port>]";
            fprintf(stdout, "%s\n", [msg UTF8String]);
            [NSApp terminate:self];
        }
    }

    if (newPort < 1000 || newPort > 65535) {
        return port;
    }

    return newPort;
}

@end
