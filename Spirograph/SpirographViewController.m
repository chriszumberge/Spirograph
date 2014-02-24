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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [scrollView setPagingEnabled:YES];
    scrollView.delegate = self;
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
    spinner.center = CGPointMake(spinner.center.x, spinner.center.y);
    [self.view bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    [spinner stopAnimating];
    
    // Init controls
    [self scrollViewDidEndDecelerating:scrollView];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Close the number pads when touching away
    [self.stepSize resignFirstResponder];
    [self.numSteps resignFirstResponder];
    
    // Call super to do whatever it would do otherwise
    [super touchesBegan:touches withEvent:event];
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
    /*
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    [opQueue setMaxConcurrentOperationCount:6];
    
    [opQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(RedrawHarmonigraph) object:nil]];
    
    [opQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(RedrawSpirograph) object:nil]];

    //[opQueue addOperation:[[NSOperation alloc] init]];
    //NSOperation *harmonigraphOp = [[NSOperation alloc] init];
    [opQueue waitUntilAllOperationsAreFinished];
    [spinner stopAnimating];
    //[opQueue waitUntilAllOperationsHaveFinished];
*/
    /*
    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(d_group, bg_queue, ^{
        [self.delegate lSliderValueChanged:self.lSlider.value];
        [self.delegate kSliderValueChanged:self.kSlider.value];
        [self.delegate numStepsValueChanged:[[self.numSteps text] floatValue]];
        [self.delegate stepSizeValueChanged:[[self.stepSize text] floatValue]];
        [spirographView setNeedsDisplay];
    });
    
    dispatch_group_async(d_group, bg_queue, ^{
        [harmonigraphView setNeedsDisplay];
    });

    dispatch_group_notify(d_group, dispatch_get_main_queue(), ^{
        [spinner stopAnimating];
    });
     */
    [self RedrawHarmonigraph];
    [self RedrawSpirograph];
    [spinner stopAnimating];
}

- (void)RedrawHarmonigraph {
    [harmonigraphView setNeedsDisplay];
}

- (void)RedrawSpirograph {
    spirographView.lValue = self.lSlider.value;
    spirographView.kValue = self.kSlider.value;
    spirographView.numberOfSteps = [self.numSteps.text floatValue];
    spirographView.sizeOfStep = [self.stepSize.text floatValue];
    
    [spirographView setNeedsDisplay];
}

- (IBAction)lValueChanged:(id)sender {
    float sliderValue = self.lSlider.value;
    NSString *labelText = [NSString stringWithFormat:@"%.2f", sliderValue];
    self.lVal.text = labelText;
}

- (IBAction)kValueChanged:(id)sender {
    float sliderValue = self.kSlider.value;
    NSString *labelText = [NSString stringWithFormat:@"%.2f", sliderValue];
    self.kVal.text = labelText;
}

// When the user stopped dragging and the UI scroll deceleration and bounce are all done
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // If scrollView offset is 0, Harmonigraph is showing so disable the sliders and fields
    if (self->scrollView.contentOffset.x == 0)
    {
        [self DisableUIControl:self.lSlider];
        [self DisableUIControl:self.kSlider];
        [self DisableUIControl:self.numSteps];
        [self DisableUIControl:self.stepSize];
    }
    // When Spirograph is showing, reenable the controls
    else if (self->scrollView.contentOffset.x == 280.0)
    {
        [self EnableUIControl:self.lSlider];
        [self EnableUIControl:self.kSlider];
        [self EnableUIControl:self.numSteps];
        [self EnableUIControl:self.stepSize];
    }
}

// Methods to enable and disable controls
- (void)DisableUIControl:(UIControl *)control {
    control.enabled = NO;
}

- (void)EnableUIControl:(UIControl *)control {
    control.enabled = YES;
}

@end
