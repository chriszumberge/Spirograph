//
//  SpirographViewController.h
//  Spirograph
//
//  Created by Michael Toth on 2/20/14.
//  Copyright (c) 2014 Michael Toth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HarmonigraphView.h"
#import "SpirographView.h"

@protocol SpirographViewControllerDelegate <NSObject>

@required

- (void)lSliderValueChanged:(float)value;
- (void)kSliderValueChanged:(float)value;
- (void)numStepsValueChanged:(float)value;
- (void)stepSizeValueChanged:(float)value;

@end

@interface SpirographViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    __weak IBOutlet SpirographView *spirographView;
    __weak IBOutlet HarmonigraphView *harmonigraphView;
    __weak IBOutlet UIActivityIndicatorView *spinner;
}

@property (weak, nonatomic) IBOutlet UISlider *lSlider;
- (IBAction)lValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *kSlider;
- (IBAction)kValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lVal;
@property (weak, nonatomic) IBOutlet UILabel *kVal;
@property (weak, nonatomic) IBOutlet UITextField *numSteps;
@property (weak, nonatomic) IBOutlet UITextField *stepSize;

- (IBAction)Redraw:(id)sender;

@end
