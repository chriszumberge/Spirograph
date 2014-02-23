//
//  SpirographViewController.m
//  Spirograph
//
//  Created by Christopher Zumberge on 2/21/14.
//  Copyright (c) 2014 Michael Toth. All rights reserved.
//

#import "SpirographViewController.h"
#import "SpirographView.h"
#import "HarmonigraphView.h"

@interface SpirographViewController ()

@end

@implementation SpirographViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [scrollView setPagingEnabled:YES];
    
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:4.0];
    
    [harmonigraphView setFrame:CGRectMake(0, 0, 280, 280)];
    [spirographView setFrame:CGRectMake(280, 0, 280, 280)];
    
    // Only let users type using the number pad
    [self.numSteps setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.stepSize setKeyboardType:(UIKeyboardTypeNumberPad)];
    
    // Init the k and l value labels
    self.lVal.text = [NSString stringWithFormat:@"%.2f", self.lSlider.value];
    self.kVal.text = [NSString stringWithFormat:@"%.2f", self.kSlider.value];
    
    // Set up notification listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    // Set default step and step size
    self.stepSize.text = @".04";
    self.numSteps.text = @"2400";
    
    // Init the Activity Indicator
    spinner.hidesWhenStopped = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    CGSize keyboardSize = [[[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]
                           CGRectValue].size;
    CGRect newFrame = self.view.frame;
    newFrame.origin.y += keyboardSize.height;
    self.view.frame = newFrame;
}

- (void)keyboardDidShow:(NSNotification *)n
{
    CGSize keyboardSize = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]
                           CGRectValue].size;
    CGRect newFrame = self.view.frame;
    newFrame.origin.y -= keyboardSize.height;
    self.view.frame = newFrame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [scrollView setContentSize:CGSizeMake(560, 280)];
}

- (IBAction)Redraw:(id)sender {
    [spinner startAnimating];
    [self.delegate lSliderValueChanged:self.lSlider.value];
    [self.delegate kSliderValueChanged:self.kSlider.value];
    [self.delegate numStepsValueChanged:[[self.numSteps text] floatValue]];
    [self.delegate stepSizeValueChanged:[[self.stepSize text] floatValue]];
    [spirographView setNeedsDisplay];
    [harmonigraphView setNeedsDisplay];
}



- (IBAction)lValueChanged:(id)sender {
    float sliderValue = self.lSlider.value;
    NSString *labelText = [NSString stringWithFormat:@"%.2f", sliderValue];
    self.lVal.text = labelText;
    //[self.delegate lSliderValueChanged:sliderValue];
}
- (IBAction)kValueChanged:(id)sender {
    float sliderValue = self.kSlider.value;
    NSString *labelText = [NSString stringWithFormat:@"%.2f", sliderValue];
    self.kVal.text = labelText;
    //[self.delegate kSliderValueChanged:sliderValue];
}

// Methods to enable and disable controls
- (void)DisableUIControl:(UIControl *)control {
    control.enabled = NO;
}

- (void)EnableUIControl:(UIControl *)control {
    control.enabled = YES;
}

@end
