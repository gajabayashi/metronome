//
//  metronemeTestViewController.h
//  metronemeTest
//
//  Created by 藤林 幹雄 on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface metronemeTestViewController : UIViewController<UIPickerViewDelegate> {
    
    IBOutlet UILabel *currentTime;
    IBOutlet UILabel *tempo;
    IBOutlet UIView *settingView;
    UIButton *getTime;
    IBOutlet UIButton *tempoPlusButton;
    IBOutlet UIButton *tempoMinusButton;
    int getCurrentTimeButtonPushed;
    double currentTimeTemp[2];
    int defineFlag;
    int tempoA,tempoB;
    int istmPlusON;
    int istmMinusON;
    NSTimer *tmPlus,*tmMinus;
    NSTimer *beatRepeat;
    NSMutableArray *beat;
    int changeBeat;
    int beatPattern;
    UIImageView *circle_;
    BOOL isFlipView,isFlipSettingView;
    double beatDuration;
    SystemSoundID upBeatSoundID,downBeatSoundID;


    
    IBOutlet UIPickerView *picker;  
    
    
    
}

-(IBAction)getCurrentTime;
-(IBAction)tempoPlus;
-(IBAction)tempoMinus;
-(IBAction)flipSettingView;
-(IBAction)flipView;
-(void)animationDidStop;
-(void)beatPattern:(NSTimer *)timer;
-(void)downBeat;
-(void)upBeat;
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView;
-(void)callBeat;


@property (nonatomic, retain) UIPickerView *picker; 


@end
