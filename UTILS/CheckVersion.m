//
//  CheckVersion.m
//  xmxcy_iphone
//
//  Created by wodfan on 6/27/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "CheckVersion.h"
#import "CommonFunctions.h"
#import "SBJSON.h"

@implementation CheckVersion
@synthesize alertViewVersion = _alertViewVersion;
@synthesize sVersionNew = _sVersionNew;
@synthesize sVersionNative = _sVersionNative;
@synthesize rootViewController = _rootViewController;


static CheckVersion *instance;

+ (CheckVersion *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[CheckVersion alloc] init];
            }
        }
    }
    return instance;
}


-(id)init{
    self = [super init];
    _sVersionNative = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return self;
}
-(void)asynchCheckVersion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestNewestVersion];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_sVersionNew && [_sVersionNew floatValue] > [_sVersionNative floatValue]){
                [self alertUpdate];
            }
        });
    }); 
}
-(void)synchCheckVersion{
    if(!_sVersionNew){
        [self requestNewestVersion];
    }
    if(_sVersionNew && [_sVersionNew floatValue] > [_sVersionNative floatValue]){
        [self alertUpdate];
    }else{
        [self alertNewest];
    }
}

-(void)requestNewestVersion{
    NSString *post = [[NSString alloc]initWithFormat:@"id=%@", [CommonFunctions getVersion]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
//    NSLog(@"===================>checkVersion request is send...");
    [request setURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *respond = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *sRespond = [[NSString alloc]initWithData:respond encoding:NSUTF8StringEncoding];
    SBJSON *jsontool = [[SBJSON alloc] init];
    NSDictionary *dic = [jsontool objectWithString:sRespond];
//    NSLog(@"===================>checkVersion request is callback...%@",[dic description]);
    if(dic && [dic objectForKey:@"results"] && [dic objectForKey:@"results"] && [[dic objectForKey:@"results"] objectAtIndex:0]){
        _sVersionNew = [[[dic objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
//        _sVersionNew = @"3.0";
    }
}


-(void) toUpdate{
    NSString *appId = [CommonFunctions getVersion];
    NSString *appurl = [NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=%@",  
             appId];   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
}

-(void)alertUpdate{
    NSString *sTitle  = [[NSString alloc] initWithFormat:@"V%@", _sVersionNative];
    NSString *sMessage = [[NSString alloc] initWithFormat:@"发现新版本%@,是否升级?", _sVersionNew];
    _alertViewVersion = [[UIAlertView alloc] initWithTitle:sTitle message:sMessage delegate:_rootViewController cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在更新" , nil];
    [_alertViewVersion show];
}
-(void)alertNewest{
    NSString *sTitle  = [[NSString alloc] initWithFormat:@"V%@", _sVersionNative];
    NSString *sMessage = [[NSString alloc] initWithFormat:@"恭喜您，已经是最新的版本~"];
    [[[UIAlertView alloc] initWithTitle:sTitle message:sMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ] show];
}

@end
