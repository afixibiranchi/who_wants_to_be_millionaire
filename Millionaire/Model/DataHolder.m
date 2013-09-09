//
//  DataHolder.m
//  Millionaire
//
//  Created by Biranchi on 9/1/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "DataHolder.h"

@implementation DataHolder

static DataHolder *dataHolder = nil;

@synthesize questionsArr;

+(DataHolder *)sharedInstance{
  
  @synchronized(self){
	if(dataHolder == nil){
	  dataHolder = [[DataHolder alloc] init];	
	}
  }
  return dataHolder;
}





-(NSArray *)fetchQuestionsArr {
  
  if(self.questionsArr == nil) {
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
	  self.questionsArr = [NSArray arrayWithContentsOfFile:filePath];
	}
	
  }
  
  return self.questionsArr;
}


@end
