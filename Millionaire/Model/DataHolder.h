//
//  DataHolder.h
//  Millionaire
//
//  Created by Biranchi on 9/1/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHolder : NSObject {
  
}

@property (nonatomic, strong) NSArray *questionsArr;

-(NSArray *)fetchQuestionsArr;
+(DataHolder *)sharedInstance;


@end
