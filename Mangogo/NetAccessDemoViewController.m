//
//  NetAccessDemoViewController.m
//  Mongo
//
//  Created by kyson on 03/02/2018.
//  Copyright © 2018 cn.kyson.mongo. All rights reserved.
//

#import "NetAccessDemoViewController.h"
#import "MGNetworkAccess.h"

@interface NetAccessDemoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *moduleTextField;
@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UIButton    *generatedButton;
@property (weak, nonatomic) IBOutlet UILabel     *requestURLLabel;
@property (weak, nonatomic) IBOutlet UIButton    *doRequestButton;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;

@end

@implementation NetAccessDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.generatedButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClicked:(id)sender{
    
    self.requestURLLabel.text = [NSString stringWithFormat:@"%@/%@/%@",self.hostTextField.text,self.moduleTextField.text,self.serviceNameTextField.text];
}



- (IBAction)doRequestButtonClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MGNetworkAccess *access = [[MGNetworkAccess alloc] initWithHost:self.hostTextField.text modulePath:self.moduleTextField.text];
        access.requestType = RequestTypeGet;
        MGNetwokResponse *response = [access doServiceRequestWithName:self.serviceNameTextField.text params:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.responseTextView.text = response.rawJson;
        });
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
