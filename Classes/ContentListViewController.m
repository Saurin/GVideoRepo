//
//  ContentListViewController.m
//  GuidedVideo
//
//  Created by Saurin Travadi on 6/3/13.
//
//

#import "ContentListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "Content.h"

CGFloat kMovieViewOffsetX = 20.0;
CGFloat kMovieViewOffsetY = 20.0;

@implementation ContentListViewController {
    MBProgressHUD *HUD;
    NSMutableArray *videos, *images;
}
@synthesize moviePlayerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewManager = (DetailViewManager *)self.splitViewController.delegate;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD show:YES];
    [self performSelector:@selector(downloadList) withObject:nil afterDelay:0.1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView setRowHeight:75];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadList {
   
    NSError *err;
    NSURL *url =[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/81021448/list.txt"];
    NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:&err];
    NSLog(@"%@",str);

    videos = [[NSMutableArray alloc] init];
    images = [[NSMutableArray alloc] init];
    NSArray *result = [[str JSONValue] valueForKey:@"Contents"];
    for (id obj in result) {
        
        if([[obj valueForKey:@"Type"] isEqualToString:@"Video"])
            [videos addObject:[[Content alloc] initWithName:[obj valueForKey:@"Name"] url:[obj valueForKey:@"URL"] thumb:[obj valueForKey:@"Thumbnail"]]];
        else
            [images addObject:[[Content alloc] initWithName:[obj valueForKey:@"Name"] url:[obj valueForKey:@"URL"] thumb:@""]];
    }
    
    [self.tableView reloadData];
    [HUD hide:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [videos count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section==0?@"Images":@"Videos";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if(indexPath.section==0){
        cell.textLabel.text = ((Content *)[images objectAtIndex:indexPath.row]).url;
    }
    else{
        cell.textLabel.text = ((Content *)[videos objectAtIndex:indexPath.row]).url;
    }


    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url;
    if(indexPath.section==0){
        url = @"";
    }
    else{
        url = ((Content *)[videos objectAtIndex:indexPath.row]).url;
    }
    
    [self playMovieStream:[NSURL URLWithString:url]];
}

-(void)playMovieStream:(NSURL *)movieFileURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    /* If we have a streaming url then specify the movie source type. */
    if ([[movieFileURL pathExtension] compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        movieSourceType = MPMovieSourceTypeStreaming;
    }
    [self createAndPlayMovieForURL:movieFileURL sourceType:movieSourceType];
}

-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    [self createAndConfigurePlayerWithURL:movieURL sourceType:sourceType];
    
    /* Play the movie! */
    [[self moviePlayerController] play];
}

-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    /* Create a new movie player object. */
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if (player)
    {
        [self setMoviePlayerController:player];
        [self installMovieNotificationObservers];
        
        [player setContentURL:movieURL];
        [player setMovieSourceType:sourceType];
        CGRect viewInsetRect = CGRectInset ([self.view bounds],kMovieViewOffsetX,kMovieViewOffsetY );
        [[player view] setFrame:viewInsetRect];
        
        [player view].backgroundColor = [UIColor blackColor];
        [self.view addSubview: [player view]];
        
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:movieURL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"video-%d.mov",arc4random() % 1000]];
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];

        
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil);
            NSLog(@"Successfully downloaded file to %@", path);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        [operation start];
        
    }
}

-(void)installMovieNotificationObservers
{
//    MPMoviePlayerController *player = [self moviePlayerController];
    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loadStateDidChange:)
//                                                 name:MPMoviePlayerLoadStateDidChangeNotification
//                                               object:player];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:player];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
//                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
//                                               object:player];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackStateDidChange:)
//                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
//                                               object:player];
}

//-(void)saveVideo:(NSURL *)url
//{
//    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDownloadDestinationPath:@"/Users/pk/Desktop/my_file.m4v"];
//    [request setDelegate:self];
//    [request startAsynchronous];
//    
//}
//
//-(void)requestFinished:(ASIHTTPRequest *)request
//
//{
//    
//}
//
//-(void)requestFailed:(ASIHTTPRequest *)request
//{
//    
//    NSLog(@"%@",request.error);
//    
//}


@end
