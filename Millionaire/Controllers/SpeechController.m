//
//  SpeechAPI.m
//  Millionaire
//
//  Created by Biranchi on 8/31/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "SpeechController.h"
#import <AVFoundation/AVFoundation.h>

@implementation SpeechController


static SpeechController *speechController = nil;

@synthesize audioPlayer;
@synthesize speechControllerDelegate;
@synthesize audioFileArr;

+(SpeechController *)sharedInstance{
  
  @synchronized(self){
	if(speechController == nil){
	  speechController = [[SpeechController alloc] init];
	}
  }
  
  return speechController;
}



#pragma mark - DownloadAudio file 


-(void)downloadAndPlayAudioFile:(NSString *)fileName forText:(NSString *)aText{
  
  
  if(!fileName || ![fileName length]){
	fileName = @"file.mp3";
  } else {
	
	if(![fileName hasSuffix:@".mp3"]){
	  fileName = [NSString stringWithFormat:@"%@.mp3", fileName];
	}
	
  }
  

  NSLog(@"DownloadFile : %@", fileName);
  
  
  if(!aText || ![aText length]){
	aText = @"Let's play who want's to be a millionaire";
  }
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
  
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
  {
	
		
		//----- Make REST API Call --------------
		
		NSString *text = aText; 
		NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=en&q=%@",text];
		
		NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
		[request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
		
		
	
		NSURLResponse* response = nil;
		NSError* error = nil;
		
		//----- Download Audio file in background thread --------------
		
		dispatch_queue_t queue = dispatch_queue_create("com.xchanging.millionaire",nil);
		dispatch_async(queue, ^{
		  
		  NSData* data = [NSURLConnection sendSynchronousRequest:request
											   returningResponse:(NSURLResponse **)&response
														   error:(NSError **)&error];
		  [data writeToFile:path atomically:YES];
		  NSLog(@"file downloaded successfully : %@", fileName);
		  
		  [self startPlaying:fileName isBundleFile:NO];
		  
		  //dispatch_async(dispatch_get_main_queue(), ^{
			;
		  //});
		  
		});
		
  } else {
	
	NSLog(@"File is already downloaded");
	[self startPlaying:fileName isBundleFile:NO];
  }
}




-(void)removeAudioFile : (NSString *)fileName{
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:path])
  {
	if([[NSFileManager defaultManager] removeItemAtPath:path error:nil]){
	  NSLog(@"File removed successfully : %@", fileName);
	} else {
	  NSLog(@"Error while removing file : %@", fileName);
	}
  }
}




#pragma mark - Start Playing 

-(void)startPlaying : (NSString *)fileName  isBundleFile:(BOOL)isBundleFile{
 
  if(!fileName){
	NSLog(@"File not present for playing");
	return;
  }
  
  NSLog(@"Inside startPlaying...");
  
  NSError        *err = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = nil;  
  
  if(isBundleFile == NO){
	path = [documentsDirectory stringByAppendingPathComponent:fileName];
  } else {
	
	NSRange range = [fileName rangeOfString:@"."];
	NSUInteger indexOfDot = -1;
	if(range.location != NSNotFound){
	  indexOfDot = range.location;

	  NSString *type = [fileName substringFromIndex:indexOfDot+1];
	  NSLog(@"Type : %@", type);
	  
	  fileName = [fileName substringToIndex:indexOfDot];
	  NSLog(@"fileName  : %@", fileName);
	  
	  path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
	} else {
	  
	  NSLog(@"File extension not found");
	  return;
	}
  }
  
  
  NSLog(@"FilePath : %@", path);
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:path])
  {
	NSLog(@"File exists....initializing AVAudioPlayer");
	
	
	if([self.audioPlayer isPlaying]){
	  [self stopPlaying];
	}
	
	
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
			  [NSURL fileURLWithPath:path] error:&err];
	
	if(err){
	  NSLog(@"Error while initializing AVAudioPlayer : %@", [err description]);
	  return;
	}
	
	float volume = 1.0f;
	if([fileName isEqualToString:@"titleSong"]){
	  volume = 0.05f;
	}
	
	NSLog(@"volume : %f", volume);
	NSLog(@"fileName : %@", fileName);

	
	self.audioPlayer.volume = volume;
	[self.audioPlayer prepareToPlay];
	[self.audioPlayer setNumberOfLoops:0];
	[self.audioPlayer setDelegate:self];
	[self.audioPlayer play];
  } else {
	NSLog(@"File not exists at path");
  }
  
}




#pragma mark - Start Playing

-(void)stopPlaying{
  
  [self.audioPlayer stop];
}





#pragma - AVAudioPlayer Delegates 

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  
  NSLog(@"Audio Player did finish playing");
  
  if([self.speechControllerDelegate respondsToSelector:@selector(speechDidFinishPlaying:)]){
	[self.speechControllerDelegate speechDidFinishPlaying:YES];
  }
  
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
  NSLog(@"Audio Player Error : %@", [error description]);

}


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
  NSLog(@"Audio Player Interrupted");
}



#pragma mark - Play Array of Files 

-(void)playArrayOfFiles {
  
  if([self.audioFileArr count]){
	
	//----- Play the first object in the array -------
	
	
  }
  
}



@end




