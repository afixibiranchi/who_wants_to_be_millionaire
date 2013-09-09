//
//  MasterViewController.m
//  Millionaire
//
//  Created by Biranchi on 8/30/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SpeechController.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Master", @"Master");
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		    //self.clearsSelectionOnViewWillAppear = NO;
		    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
		}
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
  
	[self.navigationController setNavigationBarHidden:YES];
	[self showHideButtons:NO];
  
	//[speechController downloadAudioFile:@"start" forText:@"Welcome to who want's to be a millionaire"];
  
  
  
	// Do any additional setup after loading the view, typically from a nib.
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//	self.navigationItem.rightBarButtonItem = addButton;
}



-(void)viewDidAppear:(BOOL)animated {
  
  SpeechController *speechController = [SpeechController sharedInstance];
  [speechController setSpeechControllerDelegate:self];
  [speechController startPlaying:@"titleSong.mp3" isBundleFile:YES];
  
  [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
  
}



-(void)viewDidDisappear:(BOOL)animated {
  
  //-------- Stop play audio ---------------
//  SpeechController *speechController = [SpeechController sharedInstance];
//  [speechController stopPlaying];
}



#pragma mark - Update ProgressView


- (void)makeMyProgressBarMoving {
  
  float actual = [self.aProgressView progress];
  if (actual < 1) {
	
	
	//---- New Algorithm start----
	
	//NSLog(@"actual : %f", actual);
	float newValue = actual + (arc4random()%10)/100.0f ;
	//NSLog(@"newValue : %f", newValue);
	
	if(newValue > 100.0f){
	  newValue = 100.0f;
	}
	
	
	
	//---- New Algorithm end-----
	
	
	self.aProgressView.progress = newValue; //actual + 0.05;// 0.1;
	
	//int newValue = (actual+0.05)*100;
	
	int newDisplayValue = newValue*100;
	if(newDisplayValue > 100){
	  newDisplayValue = 100;
	}
	
	NSString *str = [NSString stringWithFormat:@"Loading...     %d%%", newDisplayValue];
	
	//NSLog(@"str : %@", str);
	[self.loadingLbl setText:str];
	
	[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
  }
  else{
	
	NSLog(@"Progress bar is completed...");
  }
  
}





#pragma mark - Button Actions


- (IBAction)playBtnAction:(id)sender {
  
  
  NSString *nibName = nil;
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

	  nibName = @"DetailViewController_iPhone";
	
  } else {
  
	  nibName = @"DetailViewController_iPad";

  }
  
  DetailViewController *detailViewController =  [[DetailViewController alloc] initWithNibName:nibName bundle:nil];
;
  [self.navigationController pushViewController:detailViewController animated:YES];
  
}



- (IBAction)quitBtnAction:(id)sender {
  
  NSLog(@"Quit action done");
  //[NSThread exit];
  exit(1);

  NSLog(@"Shouldn't come here");
}


#pragma mark - Show/Hide Buttons

-(void)showHideButtons : (BOOL)boolVal{
  
  if(boolVal){
	
	[self.playBtn setHidden:NO];
	[self.playLbl setHidden:NO];
	
	[self.quitBtn setHidden:NO];
	[self.quitLbl setHidden:NO];
	
	[self.loadingLbl setHidden:YES];
	[self.aProgressView setHidden:YES];
	
  } else {
	
	[self.playBtn setHidden:YES];
	[self.playLbl setHidden:YES];
	
	[self.quitBtn setHidden:YES];
	[self.quitLbl setHidden:YES];
	
	[self.loadingLbl setHidden:NO];
	[self.aProgressView setHidden:NO];
  }
  
}




#pragma mark - SpeechController Delegate

-(void)speechDidFinishPlaying:(BOOL)val {
  
  
  [self showHideButtons:YES];


  
  //[NSThread sleepForTimeInterval:1];
  
  //SpeechController *speechController = [SpeechController sharedInstance];
  //[speechController setSpeechControllerDelegate:nil];
  //[speechController downloadAndPlayAudioFile:@"welcome.mp3" forText:@"Ladies and Gentlemen let's play      Who want's to be a millionaire."];
}


#pragma mark -



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


	NSDate *object = _objects[indexPath.row];
	cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *object = _objects[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}

*/
@end




