//
//  ViewController.m
//  Wit-Ai
//
//  Created by Kareem Moussa on 11/23/15.
//  Copyright (c) 2015 Kareem Moussa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UILabel *labelView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set the WitDelegate object
    [Wit sharedInstance].delegate = self;
    
    // create the button
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100);
    
    WITMicButton* witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
    
    // create the label
    labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, screen.size.width, 50)];
    labelView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id) customData error:(NSError*)e {
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        return;
    }
    NSDictionary *firstOutcome = outcomes[0];
    NSString *intent = firstOutcome[@"intent"];
    
    NSString *base = @"https://agent.electricimp.com/pa_r-aPWYEnP";
    NSString *query = @"";
    NSString *task = firstOutcome[@"entities"][@"task"][0][@"value"];
    NSString *time = firstOutcome[@"entities"][@"duration"][0][@"value"];
    
    labelView.text = [NSString stringWithFormat:@"%@: %@ %@", intent, task, time];
    [self.view addSubview:labelView];
    
    //if parameters are not ok, return from the function
    if ([intent isEqualToString:@"Set_Task"] && task && time)
        query = [NSString stringWithFormat:@"set?task=%@&time=%@", task, time];
    else if([intent isEqualToString:@"Delete_Task"] && task)
        query = [NSString stringWithFormat:@"delete?task=%@", task];
    else
        return;
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", base, query];
    
    //get request to the electric imp agent/device
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
            }] resume];
}

@end
