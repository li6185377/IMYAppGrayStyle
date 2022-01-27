//
//  ViewController.m
//  IMYAppGrayStyle
//
//  Created by ljh on 2022/1/27.
//

#import "ViewController.h"
#import "IMYAppGrayStyle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)openGrayStyleAction:(id)sender {
    [IMYAppGrayStyle open];
}

- (IBAction)closeGrayStyleAction:(id)sender {
    [IMYAppGrayStyle close];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
