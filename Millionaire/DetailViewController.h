//
//  DetailViewController.h
//  Millionaire
//
//  Created by Biranchi on 8/30/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechController.h"

@interface DetailViewController : UIViewController <SpeechControllerDelegate>{
  
  int			  currentSeqNo;
  NSArray		  *questionsArr;
  NSMutableArray  *speechArr;
  BOOL			  isPlayingAudioForNewQuestion;
}


@property (weak, nonatomic) IBOutlet UIButton *optionBtnA;
@property (weak, nonatomic) IBOutlet UIButton *optionBtnB;
@property (weak, nonatomic) IBOutlet UIButton *optionBtnC;
@property (weak, nonatomic) IBOutlet UIButton *optionBtnD;

@property (weak, nonatomic) IBOutlet UILabel *questionLbl;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl1;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl2;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl3;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl4;

@end
