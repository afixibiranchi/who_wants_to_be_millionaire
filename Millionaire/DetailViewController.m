//
//  DetailViewController.m
//  Millionaire
//
//  Created by Biranchi on 8/30/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "DetailViewController.h"
#import "DataHolder.h"
#import "SpeechController.h"

@interface DetailViewController ()
//@property (strong, nonatomic) UIPopoverController *masterPopoverController;
//- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	currentSeqNo = 0;
	isPlayingAudioForNewQuestion = NO;
	
	//NSLog(@"self.view subviews : %@", [self.view subviews]);
  
	questionsArr = [[NSArray alloc] initWithArray:[[DataHolder sharedInstance] fetchQuestionsArr]];
	//NSLog(@"questionsArr :: %@", questionsArr);
	[self displayQuestion];
  
	
}


#pragma mark - Display Questions 


-(void)playAudioForNewQuestion {
  
  @autoreleasepool {
  
	//-------------- Play Audio before new Question -----------------
	
	isPlayingAudioForNewQuestion = YES;
	SpeechController *speechController = [SpeechController sharedInstance];
	[speechController setSpeechControllerDelegate:self];
	//[speechController startPlaying:@"nextQuestion.mp3" isBundleFile:YES];
	[speechController startPlaying:@"nextQuestion2.wav" isBundleFile:YES];
  }
  
}



-(void)displayQuestion {
  
  @autoreleasepool {
	
	[(UIButton *)[self.view viewWithTag:1] setImage:[UIImage imageNamed: @"options"] forState:UIControlStateNormal];
	[(UIButton *)[self.view viewWithTag:2] setImage:[UIImage imageNamed: @"options"] forState:UIControlStateNormal];
	[(UIButton *)[self.view viewWithTag:3] setImage:[UIImage imageNamed: @"options"] forState:UIControlStateNormal];
	[(UIButton *)[self.view viewWithTag:4] setImage:[UIImage imageNamed: @"options"] forState:UIControlStateNormal];

    
	  if(currentSeqNo < [questionsArr count]){

		
		//-------------- Display Question -----------------
		
		NSDictionary *dict	= [questionsArr objectAtIndex:currentSeqNo];
		NSString *seq		= [dict objectForKey:@"seq"];
		NSString *question	= [dict objectForKey:@"ques"];
		NSString *op1		= [dict objectForKey:@"op1"];
		NSString *op2		= [dict objectForKey:@"op2"];
		NSString *op3		= [dict objectForKey:@"op3"];
		NSString *op4		= [dict objectForKey:@"op4"];

		self.questionLbl.text = question;
		self.optionLbl1.text  = op1;
		self.optionLbl2.text  = op2;
		self.optionLbl3.text  = op3;
		self.optionLbl4.text  = op4;
		
		
		[self playAudioForNewQuestion];
		
		
		
		//----------------- Create Speech Array -------------------
		
		speechArr = [[NSMutableArray alloc] initWithCapacity:0];
		
		
		NSMutableDictionary *speechDict = [NSMutableDictionary dictionaryWithCapacity:0];
		[speechDict setObject:seq forKey:@"fileName"];
		[speechDict setObject:question forKey:@"speechString"];
		[speechArr addObject:speechDict];
		
		
		speechDict = [NSMutableDictionary dictionaryWithCapacity:0];
		[speechDict setObject:[NSString stringWithFormat:@"%@op1", seq] forKey:@"fileName"];
		[speechDict setObject:[NSString stringWithFormat:@"option A %@", op1] forKey:@"speechString"];
		[speechArr addObject:speechDict];
		
		
		speechDict = [NSMutableDictionary dictionaryWithCapacity:0];
		[speechDict setObject:[NSString stringWithFormat:@"%@op2", seq] forKey:@"fileName"];
		[speechDict setObject:[NSString stringWithFormat:@"option B %@", op2] forKey:@"speechString"];
		[speechArr addObject:speechDict];
		

		speechDict = [NSMutableDictionary dictionaryWithCapacity:0];
		[speechDict setObject:[NSString stringWithFormat:@"%@op3", seq] forKey:@"fileName"];
		[speechDict setObject:[NSString stringWithFormat:@"option C %@", op3] forKey:@"speechString"];
		[speechArr addObject:speechDict];
		
		
		speechDict = [NSMutableDictionary dictionaryWithCapacity:0];
		[speechDict setObject:[NSString stringWithFormat:@"%@op4", seq] forKey:@"fileName"];
		[speechDict setObject:[NSString stringWithFormat:@"option D %@", op4] forKey:@"speechString"];
		[speechArr addObject:speechDict];
		
		
		//[self startSpeech];
		
		
	  } else {
		
		NSLog(@"currentSeqNo is invalid : %d", currentSeqNo);
	  }
  }
  
}


#pragma mark - Speech Questions

-(void)startSpeech{
  
  @autoreleasepool {
    
	if([speechArr count]){

	  NSString *fileName = [NSString stringWithFormat:@"%@", [[speechArr objectAtIndex:0] objectForKey:@"fileName"]];
	  NSString *speechStr = [NSString stringWithFormat:@"%@", [[speechArr objectAtIndex:0] objectForKey:@"speechString"]];
	  
	  NSLog(@"\n\n\n");
	  NSLog(@"++speechStr : %@", speechStr);
	  
	  SpeechController *speechController = [SpeechController sharedInstance];
	  [speechController setSpeechControllerDelegate:self];
	  [speechController downloadAndPlayAudioFile:fileName forText:speechStr];
	  
	}
  }
  
}

	   
#pragma mark - SpeechController Delegate
	   
 -(void)speechDidFinishPlaying:(BOOL)val {
   
   NSLog(@"Speech did finish playing in DetailViewController");
   
   if(isPlayingAudioForNewQuestion == YES) {
	 
	 isPlayingAudioForNewQuestion = NO;
	 //[self displayQuestion];
	 [self startSpeech];
	 
   } else {
	   if(speechArr && [speechArr count]){
		 [speechArr removeObjectAtIndex:0];
		 [self performSelector:@selector(startSpeech) withObject:nil afterDelay:1.0f];
	   }
   }
   
   //SpeechController *speechController = [SpeechController sharedInstance];
   //[speechController setSpeechControllerDelegate:nil];
   //[speechController downloadAndPlayAudioFile:@"welcome.mp3" forText:@"Ladies and Gentlemen let's play      Who want's to be a millionaire."];
 }
 
	   


#pragma mark - Button Actions


- (IBAction)optionButtonAction:(id)sender {
  
  int optionSelected = [sender tag];
  
  if(currentSeqNo < [questionsArr count]){
	;
  } else {
	NSLog(@"currentSequence Number is exceeded");
	return;
  }
  
  
  SpeechController *speechController = [SpeechController sharedInstance];
  [speechController setSpeechControllerDelegate:nil];

  
  BOOL val = [self validateAnswer: optionSelected];
  if(val){
	//------- Correct Answer ---------
	
	[sender setImage:[UIImage imageNamed:@"correctAnswer"] forState:UIControlStateNormal];
	[speechController startPlaying:@"correct.wav" isBundleFile:YES];
	

  } else {
	//------- Incorrect Answer ---------

	[sender setImage:[UIImage imageNamed:@"wrongAnswer"] forState:UIControlStateNormal];
	[speechController startPlaying:@"incorrect.wav" isBundleFile:YES];

	int correctBtnIndex = [self getCorrectBtnIndex];
	if(correctBtnIndex == -1){
	  NSLog(@"Invalid CorrectIndex");
	} else {
	  [(UIButton *)[self.view viewWithTag:correctBtnIndex] setImage:[UIImage imageNamed: @"correctAnswer"] forState:UIControlStateNormal];
	}
	
	//------------ Stop Playing and Navigate to Home Screen ---------
	
  }
  
  
  //[NSThread sleepForTimeInterval:1];
  
  currentSeqNo = currentSeqNo+1;
  if(currentSeqNo < [questionsArr count]){
	
	[speechController setSpeechControllerDelegate:self];
	[self performSelector:@selector(displayQuestion) withObject:nil afterDelay:4.0f];
	
	//[self performSelector:@selector(playAudioForNewQuestion) withObject:nil afterDelay:5.0f];

  } else {
	//-------Questions Completed-------
  }
  
  
}


-(BOOL)validateAnswer : (int)optionSelected {
  BOOL res = NO;
  
  if(currentSeqNo < [questionsArr count]){
	;
  } else {
	NSLog(@"currentSequence Number is exceeded in validateAnswer");
	return res;
  }
  
  NSString *answerSelected = [NSString stringWithFormat:@"op%d", optionSelected];
  
  NSDictionary *dict = [questionsArr objectAtIndex:currentSeqNo];
  NSString *correctAnswer = [dict objectForKey:@"ans"];
  
  NSLog(@"answerSelected : %@", answerSelected);
  NSLog(@"correctAnswer : %@", correctAnswer);

  
  if([answerSelected isEqualToString:correctAnswer]){
	res = YES;
  }
  
  return res;
}


-(int)getCorrectBtnIndex {
  int index = -1;
  
  NSDictionary *dict = [questionsArr objectAtIndex:currentSeqNo];
  NSString *correctAnswer = [dict objectForKey:@"ans"];

  NSString *stringIndex = [correctAnswer stringByReplacingOccurrencesOfString:@"op" withString:@""];
  index = [stringIndex integerValue];
  
  
  return index;
}


#pragma mark -




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}




- (IBAction)backBtnAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Split view

/*
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
*/

@end







