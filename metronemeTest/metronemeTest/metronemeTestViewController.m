//
//  metronemeTestViewController.m
//  metronemeTest
//
//  Created by 藤林 幹雄 on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "metronemeTestViewController.h"

#define ON 1



@implementation metronemeTestViewController


@synthesize picker; 

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)gesturePlus:(id *)sender {
    
    if (istmPlusON == 0) {
         
        NSLog(@"plusですよ");
        tmPlus = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tempoPlus) userInfo:nil repeats:YES];
        
       
       
    }else{

        istmPlusON = 0;
        [tmPlus invalidate];
    
    }
    [self callBeat];
    
}


-(void)gestureMinus:(id *)sender {
    
    if (istmMinusON == 0) {
         
        NSLog(@"minusですよ");
        tmMinus = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tempoMinus) userInfo:nil repeats:YES];
        
       

    }else{
        istmMinusON = 0;
        NSLog(@"マイナスをキャンセル");
        [tmMinus invalidate];
    }
    
    [self callBeat];

    
   
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    getCurrentTimeButtonPushed = 0;
    istmPlusON = 0;
    picker.delegate=self;
    beatPattern = 0;
    isFlipView = YES;
    beat = [[NSMutableArray alloc] init];
    [beat addObject:@"0"];
    [beat addObject:@"2"];
    [beat addObject:@"3"];
    [beat addObject:@"4"];
    [beat addObject:@"5"];
    [beat addObject:@"6"];
    [beat addObject:@"7"];
    [beat addObject:@"2+3"];
    [beat addObject:@"2+2+3"];
    [beat addObject:@"3+3+2"];
    
    
    
    //効果音準備
    NSString *path = [[NSBundle mainBundle]pathForResource:@"downBeat" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((CFURLRef)url, &downBeatSoundID);
    
    NSString *UPpath = [[NSBundle mainBundle]pathForResource:@"upBeat" ofType:@"wav"];
    NSURL *UPurl = [NSURL fileURLWithPath:UPpath];
    AudioServicesCreateSystemSoundID((CFURLRef)UPurl, &upBeatSoundID);
    
    AudioServicesPlaySystemSound(downBeatSoundID);
    AudioServicesPlaySystemSound(upBeatSoundID);

    
    
    
    
    
    
    
    
    tempoA = 120;
    tempoB = 120;
    if((currentTimeTemp[0]-currentTimeTemp[1])>=0){
        tempo.text = [NSString stringWithFormat:@"%d",tempoA%250];
        
    }else
    {
        tempo.text = [NSString stringWithFormat:@"%d",tempoB%250];
        
    }
   
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePlus:)];  
    
    longPressGesture.minimumPressDuration = 1.f;
    [tempoPlusButton addGestureRecognizer:longPressGesture];  
    
    
    
    UILongPressGestureRecognizer *longPressGestureMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMinus:)];  
    
    longPressGestureMinus.minimumPressDuration = 1.f;
    [tempoMinusButton addGestureRecognizer:longPressGestureMinus];  
    
    
    
    [longPressGesture release];  
    [longPressGestureMinus release];
    
    
    
}

//- (void) handleLongPressGesture:(UILongPressGestureRecognizer*) sender {  
  //  NSLog(@"long press");  
//}  


-(IBAction)getCurrentTime;
{
    currentTimeTemp[getCurrentTimeButtonPushed%2] = CFAbsoluteTimeGetCurrent();
    getCurrentTimeButtonPushed ++;   
    
   // currentTime.text =  [NSString stringWithFormat:@"%f",currentTimeTemp[0]];
    
     tempoA =  60/(currentTimeTemp[0]-currentTimeTemp[1]);
     tempoB =  60/(currentTimeTemp[1]-currentTimeTemp[0]);
    
   // defineFlag = ON;
    
    if((currentTimeTemp[0]-currentTimeTemp[1])>=0){
        tempo.text = [NSString stringWithFormat:@"%d",tempoA%250];

    }else
    {
        tempo.text = [NSString stringWithFormat:@"%d",tempoB%250];

    }
    
    [self callBeat];    
}


//設定画面へ遷移

-(IBAction)flipSettingView{
       isFlipView = NO;
    isFlipSettingView = YES;
 
    
    
    if (![UIView areAnimationsEnabled]) {
        return;
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
         [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        [UIView setAnimationDelegate:self];
        
        // viewに追加
        [self.view addSubview:settingView];
        [UIView setAnimationsEnabled:NO];
    	[UIView commitAnimations]; 
        
        
    }
}


//メトロノーム画面へ遷移

-(IBAction)flipView{
    isFlipSettingView = NO;
     isFlipView = YES;
    
    if (![UIView areAnimationsEnabled]) {
        
        NSLog(@"koko");
        return;
    }else{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        [UIView setAnimationDelegate:self];

        
        // viewに追加
        [settingView removeFromSuperview];
         [UIView setAnimationsEnabled:NO];
        [UIView commitAnimations]; 
       
        
    }
}



-(void)animationDidStop{
    [UIView setAnimationsEnabled:YES];
}




-(IBAction)tempoPlus
{
    
    NSLog(@"tempoPlus");
    istmPlusON = 1;
        
    
   // if(defineFlag == ON )
    {
        
        
        if((currentTimeTemp[0]-currentTimeTemp[1])>=0){
            tempoA++;
            tempo.text = [NSString stringWithFormat:@"%d",tempoA%250];
            
        }else
        {
            tempoB++;
            tempo.text = [NSString stringWithFormat:@"%d",tempoB%250];
            
        }

        
        
        
    }
    
   [self callBeat];

    
    
}



-(IBAction)tempoMinus
{
    istmMinusON = 1;
    //if(defineFlag == ON )
    {
        
        
        if((currentTimeTemp[0]-currentTimeTemp[1])>=0){
            tempoA--;
            tempo.text = [NSString stringWithFormat:@"%d",tempoA%250];
            
        }else
        {
            tempoB--;
            tempo.text = [NSString stringWithFormat:@"%d",tempoB%250];
            
        }
        
        
        
        
    }
    
    [self callBeat];

    
    
}


-(void)callBeat{
    
    

    if (beatRepeat) {
        [beatRepeat invalidate];
        changeBeat = 0;
    }
    if((currentTimeTemp[0]-currentTimeTemp[1])>=0){
        beatDuration = 60.0f/tempoA ;
        beatRepeat = [NSTimer scheduledTimerWithTimeInterval:60.0f/tempoA target:self selector:@selector(whichBeat:) userInfo:nil repeats:YES];
        
    }else{
        beatDuration = 60.0f/tempoB ;

        beatRepeat = [NSTimer scheduledTimerWithTimeInterval:60.0f/tempoB target:self selector:@selector(whichBeat:) userInfo:nil repeats:YES];
    }
    
}


//pickerViewの設定

- (NSString*)pickerView: (UIPickerView*) pView titleForRow:(NSInteger) row forComponent:(NSInteger)component {  
    
    return [beat objectAtIndex:row]; 
}  

- (NSInteger) pickerView: (UIPickerView*)pView numberOfRowsInComponent:(NSInteger) component {  
    return [beat count];  
}  

- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent:(NSInteger)component { 
    
        beatPattern = row;
    [self callBeat];
  
    
}


//downBeatとupBeatの場合分け

-(void)whichBeat:(NSTimer *)timer{
    
    
    
    switch (beatPattern) {
        case 0:
            [self upBeat];
            break;
        case 1:
            if (changeBeat == 0) {
                changeBeat = 1;
                [self downBeat];
            }else{
                [self upBeat];
                changeBeat = 0;
            }
            
            break;
        case 2:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat == 1 ){
                changeBeat++;
                [self upBeat];
                break;
            }
            if (changeBeat == 2) {
                [self upBeat];
                changeBeat = 0;
                break;
            }

        case 3:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat >=1 && changeBeat <=2){
                changeBeat++;
                [self upBeat];
                break;
            }
            if (changeBeat == 3) {
                [self upBeat];
                changeBeat = 0;
                break;
            }

        case 4:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat >=1 && changeBeat <=3){
                changeBeat++;
                [self upBeat];
                break;
            }
            if (changeBeat == 4) {
                [self upBeat];
                changeBeat = 0;
                break;
            }


        case 5:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat >=1 && changeBeat <=4){
                changeBeat++;
                [self upBeat];
                break;
            }
                if (changeBeat == 5) {
                    [self upBeat];
                    changeBeat = 0;
                    break;
            }
        case 6:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat >=1 && changeBeat <=5){
                changeBeat++;
                [self upBeat];
                break;
            }
            if (changeBeat == 6) {
                [self upBeat];
                changeBeat = 0;
                break;
            }

            
            
        case 7:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat == 1){
                changeBeat++;
                [self upBeat];
                break;
            }
            
            if (changeBeat == 2) {
                changeBeat++ ;
                [self downBeat];
                break;
            }
            if (changeBeat == 3) {
                changeBeat++ ;
                [self upBeat];
                break;
            }
            if (changeBeat == 4) {
                [self upBeat];
                changeBeat = 0;
                break;
                
            }
            
        case 8:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat == 1){
                changeBeat++;
                [self upBeat];
                break;
            }
            
            if (changeBeat == 2) {
                changeBeat++ ;
                [self downBeat];
                break;
            }
            if (changeBeat == 3) {
                changeBeat++ ;
                [self upBeat];
                break;
            }
            if (changeBeat == 4) {
                changeBeat++ ;
                [self downBeat];

                break;
                
            }
            if (changeBeat == 5) {
                changeBeat++ ;
                [self upBeat];
 
                break;
                
            }

            if (changeBeat == 6) {
                [self upBeat];
                changeBeat = 0;
                break;
                
            }




        case 9:
            if(changeBeat == 0) {
                changeBeat++;
                [self downBeat];
                break;
            }
            if(changeBeat == 1){
                changeBeat++;
                [self upBeat];
                break;
            }
            
            if (changeBeat == 2) {
                changeBeat++ ;
                [self upBeat];
                break;
            }
            if (changeBeat == 3) {
                changeBeat++ ;
                [self downBeat];
                break;
            }
            if (changeBeat == 4) {
                changeBeat++ ;
                [self upBeat];

                break;
                
            }
            
            if (changeBeat == 5) {
                changeBeat++ ;
                [self upBeat];

                break;
                
            }

            if (changeBeat == 6) {
                changeBeat++ ;
                [self downBeat];

                break;
                
            }

            if (changeBeat == 7) {
                [self upBeat];
                changeBeat = 0;
                break;
                
            }



            
                   
            
            
            
        default:
            [self upBeat];
            break;
            
    }
    
    
    
    
    
    
    
}


//音を鳴らすメソッド

-(void)downBeat{
    
    NSLog(@"downBeat");
    AudioServicesPlaySystemSound(downBeatSoundID);

    if(isFlipView){
    UIImage *image = [UIImage imageNamed:@"redCircle.png"];
    circle_ = [[UIImageView alloc ]initWithImage:image];
    circle_.alpha = 0.0;
    [self.view addSubview:circle_];
    circle_.center = CGPointMake(230,230);
    circle_.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:beatDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    circle_.center = CGPointMake(230, 230);
    circle_.alpha = 0.0;
    
    CGAffineTransform transformScale = CGAffineTransformScale(CGAffineTransformIdentity, 3, 3);   
    circle_.transform = CGAffineTransformConcat(transformScale ,transformScale);
    [UIView commitAnimations];
    }
}

-(void)upBeat{
    
    NSLog(@"upBeat");
    AudioServicesPlaySystemSound(upBeatSoundID);
    if(isFlipView){
        UIImage *image = [UIImage imageNamed:@"circle.png"];
        circle_ = [[UIImageView alloc ]initWithImage:image];
        circle_.alpha = 0.0;
        [self.view addSubview:circle_];
        circle_.center = CGPointMake(230,230);
        circle_.alpha = 1.0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:beatDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        circle_.center = CGPointMake(230, 230);
        circle_.alpha = 0.0;
        
        CGAffineTransform transformScale = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);   
        circle_.transform = CGAffineTransformConcat(transformScale ,transformScale);
        [UIView commitAnimations];
    }

    
}






-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    
    return 1;

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
