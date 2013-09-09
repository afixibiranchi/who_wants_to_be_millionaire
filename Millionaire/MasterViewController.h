//
//  MasterViewController.h
//  Millionaire
//
//  Created by Biranchi on 8/30/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechController.h"

@class DetailViewController;

@interface MasterViewController : UIViewController <SpeechControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (weak, nonatomic) IBOutlet UILabel *playLbl;
@property (weak, nonatomic) IBOutlet UILabel *quitLbl;

@property (weak, nonatomic) IBOutlet UILabel *loadingLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *aProgressView;


@end
