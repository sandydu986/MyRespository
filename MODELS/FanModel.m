//
//  FanModel.m
//  Wodfan
//
//  Created by TangQiao on 11-12-10.
//  Copyright (c) 2011年 TangQiao. All rights reserved.
//

#import "FanModel.h"
#import "commonFunctions.h"

@implementation FanModel {
    SBJSON * jsonTool;
}


@synthesize username = _username;
@synthesize password = _password;
@synthesize token = _token;
@synthesize globalWindow = _globalWindow;

#define kUsername @"username"
#define kPassword @"password"
#define kToken    @"token"

#define GET_STYLE_URL                        [NSString stringWithFormat:@"%@/search/getNavigator?id=6", BasicURL]
#define GET_RELATED_ITEMS_COUNT_BY_STAR_URL  [NSString stringWithFormat:@"%@/search/getRelatedItemsCountByStar?star_id=%@", kBaseURL]
#define GET_STAR_HEADER_URL                  [NSString stringWithFormat:@"%@/search/getStarHeader", BasicURL]
#define GET_FE_ROOT_URL                      [NSString stringWithFormat:@"%@/fe/getFE", BasicURL]

static FanModel * instance;
+ (FanModel *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[FanModel alloc] init];
                
            }
        }
    }
    return instance;
}


// 将图片缩小
+ (UIImage *) shrinkImage:(UIImage *) image {
    float width = 50.0;
    float height = 50.0;
    CGSize size = image.size;
    
    if (size.width > size.height) {
        height = width * size.height / size.width;
    } else {
        width = height * size.width / size.height;
    }
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage * imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}


-(id) init {
    if (self = [super init]) {
        //[self loadData];
        jsonTool = [[SBJSON alloc] init];
        events = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)getEventNameWithID:(NSInteger)_id {
    return [events objectForKey:[NSString stringWithFormat:@"%ld", (long)_id]];
}

- (void)registerEvent: (NSString *)name id:(NSInteger)_id {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)_id];
    if (![events objectForKey:key]) {
        [events setObject:[NSMutableArray array] forKey:key];
    }
    NSMutableArray *values = (NSMutableArray *)[events objectForKey:key];
    BOOL isExisted = FALSE;
    NSString *v;
    for (v in values) {
        if ([v isEqualToString:name]) {
            isExisted = TRUE;
            break;
        }
    }
    if (!isExisted) {
        [values addObject:name];
    }
}

- (int) getReturnCodeInJson:(NSDictionary*)json {
    NSNumber * code = [json objectForKey:@"code"];
    return [code intValue];
}

//get stars
- (void)getStars: (NSInteger) star_id andGetNum:(NSInteger) num query:(NSString *)query requestTag:(REQUESTTAG)requestTag requestEventName:(NSString *)eventName{
    query = query?query : @"";
    NSString *url = [NSString stringWithFormat:@"%@/search/getStars2?star_id=%ld&num=%ld&query=%@", BasicURL, star_id, (long)num, query];
    [self sendRequestURLWithQueue:url requestTag:requestTag requestEventName:eventName];
}

//get stars by category
- (void)getStarsByCategory:(NSInteger)offset num:(NSInteger)num query:(NSString *)query requestTag:(REQUESTTAG)requestTag requestEventName:(NSString *)eventName{
    query = query?query : @"";
    NSString *url = [NSString stringWithFormat:@"%@/search/getStarCategory?offset=%ld&num=%ld&query=%@", BasicURL, offset, num, query];
    [self sendRequestURLWithQueue:url requestTag:requestTag requestEventName:eventName];
}

// get star
- (void)getStar:(NSInteger)star_id requestEventName:(NSString *)eventName{
    NSString *url = [NSString stringWithFormat:@"%@/search/getStar?star_id=%ld", BasicURL, star_id];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self sendRequestURLWithQueue:url requestTag:STAR_DETAIL_REQUESTTAG requestEventName:eventName];
}

// get customized enter image from backend
- (void)getCustomizedEnterImage: (NSString *)eventName{
    NSString *url = [NSString stringWithFormat:@"%@/search/getCustomizedEnterImage", BasicURL];
    [self sendRequestURLWithQueue:url requestTag:MAIN_REQUESTTAG requestEventName:eventName];
}

- (void)getRelatedItemsByStar: (NSString*) star_id requestTag:(REQUESTTAG)requestTag requestEventName:(NSString *)eventName{
    NSString *url = [NSString stringWithFormat:@"%@/search/getRelatedItemsByStar?star_id=%@", BasicURL, star_id];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self sendRequestURLWithQueue:url requestTag:requestTag requestEventName:eventName];
}

- (NSDictionary *)getRelatedItemsCountByStar: (NSString*) star_id{
    if (![self isBaseAvailable:@"GET_RELATED_ITEMS_COUNT_BY_STAR_URL"])
        return nil;
    return [self getJSONFromUrl:[NSURL URLWithString:[[CommonFunctions getDomainInfo] objectForKey:@"GET_RELATED_ITEMS_COUNT_BY_STAR_URL"]]];
}

- (NSDictionary *)getStyle
{
    if (![self isBaseAvailable:@"GET_STYLE_URL"])
        return nil;
    return [self getJSONFromUrl:[NSURL URLWithString:[[CommonFunctions getDomainInfo] objectForKey:@"GET_STYLE_URL"]]];
}

- (NSDictionary *)getStarHeader
{
    if (![self isBaseAvailable:@"GET_STAR_HEADER_URL"])
        return nil;
    return [self getJSONFromUrl:[NSURL URLWithString:[[CommonFunctions getDomainInfo] objectForKey:@"GET_STAR_HEADER_URL"]]];
}

- (void)getStarHeaderAds:(NSString *)eventName;
{
    NSString *url = [NSString stringWithFormat:@"%@/search/getStarHeaderTopics", BasicURL];
    [self sendRequestURLWithQueue:url requestTag:MAIN_REQUESTTAG requestEventName:eventName];
}

- (NSDictionary *)getRootFEUrl{
    return[self getJSONFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@", GET_FE_ROOT_URL]]];
}

- (BOOL)isBaseAvailable:(NSString *)key{
    if (![CommonFunctions getDomainInfo] && ![CommonFunctions initDomainInfo]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:0]];
        return FALSE;
    }
    if (![[CommonFunctions getDomainInfo] objectForKey:key]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:0]];
        return FALSE;
    }
    return TRUE;
}

- (NSDictionary *)returnData:(NSString *)key{
    NSDictionary *data = [self getJSONFromUrl:[NSURL URLWithString:[[CommonFunctions getDomainInfo] objectForKey:key]]];
    if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:1]];
        return data;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:0]];
        return nil;
    }
}
    
- (NSDictionary *)returnDataWithURL:(NSString *)url{
    NSDictionary *data = [self getJSONFromUrl:[NSURL URLWithString:url]];
    if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:1]];
        return data;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:0]];
        return nil;
    }
}


- (NSDictionary *)getJSONFromUrl:(NSURL*)url {
    ASIFormDataRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUseCookiePersistence:NO];
    [request startSynchronous];
    NSError *error = [request error];
    [request setResponseEncoding:NSUTF8StringEncoding];
    if (!error) {
        NSString *response = [request responseString];
//        NSLog(@"response text: %@", response);
        NSDictionary * data;
        data = [jsonTool objectWithString:response error:&error];
        if (!error) {
            if (data) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:1]];
                return data;
            }
        } else {
//            NSLog(@"Error while parsing json: %@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:0]];
            return nil;
        }
    } else {
//        NSLog(@"Error info: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"view.backend.api" object:[NSNumber numberWithInt:0]];
        return nil;
    }
    return nil;
}

- (NSString *) getImageDesc:(NSArray*)imageArray {
    NSMutableArray * retArray = [[NSMutableArray alloc] init];
    for (NSString * imageId in imageArray) {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"0", @"iscollocation",
                             imageId, @"id",
                             @"", @"desc", nil];
        [retArray addObject:dict];
//        return [jsonTool stringWithObject:dict error:nil];
    }
    NSError *error;
    NSString * ret = [jsonTool stringWithObject:retArray error:&error];
    if (!error) {
        return ret;
    } else {
//        debugLog(@"Error while parsing json: %@", error);
        return nil;
    }
}


- (NSDictionary*) getJSONFromUrl:(NSURL*) url andUploadImage:(UIImage*)image {
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
    NSData * data = UIImageJPEGRepresentation(image, 0.1);
    [request addPostValue:[UserModel sharedInstance].userId forKey:@"user_id"];
    [request addData:data withFileName:@"pic.jpg" andContentType:@"image/jpeg" forKey:@"image"];
    [request setUseCookiePersistence:NO];
    [request startSynchronous];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
//        debugLog(@"response text: %@", response);
        NSDictionary * data;
        data = [jsonTool objectWithString:response error:&error];
        if (!error) {
            return data;
        } else {
            //debugLog(@"Error while parsing json: %@", error);
            return nil;
        }
    } else {
//        debugLog(@"Error info: %@", error);
        return nil;
    }
}

- (void) sendRequestURLWithQueue:(NSString *)url requestTag:(REQUESTTAG)tag requestEventName:(NSString *)eventName{
    NSLog(@"get stars request url %@", url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getJSONFromURLInTheQueue:[NSURL URLWithString:url] requestTag:tag requestEventName:eventName];
}

- (void) getJSONFromURLInTheQueue:(NSURL *)url requestTag:(REQUESTTAG)tag requestEventName:(NSString *)eventName{
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.tag = tag;
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    request.accessibilityLanguage = eventName;
    enabledTag = tag;
    [queue addOperation:request];
}

- (void)requestDone:(ASIHTTPRequest *)request {
    NSLog(@"the request is success.");
    if (enabledTag == request.tag) {
        NSLog(@"the request %@ is valid, send the data into callback", request.accessibilityLanguage);
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            NSDictionary * data;
            data = [jsonTool objectWithString:response error:&error];
            if (!error) {
                if (data) {
                    NSLog(@"call event name %@", request.accessibilityLanguage);
                    [[NSNotificationCenter defaultCenter] postNotificationName:request.accessibilityLanguage object:data];
                }
            } else {
                // response parse json failed
            }
        } else {
            // response exception
        }
    } else {
        NSLog(@"the request %@ is invalid, cancel it.", request.accessibilityLanguage);
        [request cancel];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request {
    if (enabledTag == request.tag) {
        [self performSelector:@selector(requestWentWrongDelay:) withObject:request afterDelay:2.0];
    } else {
        NSLog(@"the request %@ is invalid, cancel it.", request.accessibilityLanguage);
        [request cancel];
    }
}
-(void)requestWentWrongDelay:(ASIHTTPRequest *)request{
//        NSLog(@"the request %d is failed, retrying...", request.tag);
    ASIHTTPRequest *retryRequest = [ASIHTTPRequest requestWithURL:request.url];
    retryRequest.tag = request.tag;
    [retryRequest setResponseEncoding:NSUTF8StringEncoding];
    [retryRequest setDelegate:self];
    [retryRequest setDidFinishSelector:@selector(requestDone:)];
    [retryRequest setDidFailSelector:@selector(requestWentWrong:)];
    retryRequest.accessibilityLanguage = request.accessibilityLanguage;
    [queue addOperation:retryRequest];
}
//-(BOOL) login:(NSString *)username password:(NSString*)password {
//    NSString * urlStr = [NSString stringWithFormat:LOGIN_URL, username, password];
//    NSURL * url = [NSURL URLWithString:urlStr];
//    NSDictionary * json = [self getJSONFromUrl:url];
//    if ([self getReturnCodeInJson:json] == 200) {
//        self.username = username;
//        self.password = password;
//        self.token = [json objectForKey:@"token"];
//        [self saveData];
//        NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:200] forKey:@"code"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self userInfo:userInfo];
//        return YES;
//    }
//    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:400] forKey:@"code"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self userInfo:userInfo];
//    return NO;
//}
//
//-(NSString*) uploadImage:(UIImage*) image {
//    NSString * urlStr = [NSString stringWithFormat:UPLOAD_IMAGE_URL, self.token];
//    NSURL * url = [NSURL URLWithString:urlStr];
//    NSDictionary * result = [self getJSONFromUrl:url andUploadImage:image];
//    if ([self getReturnCodeInJson:result] == 200) {
//        return [result objectForKey:@"id"];
//    }
//    return nil;
//}
//
////  @"http://www.wodfan.com/ios/generate?type=%@&tag=&title=&pics=%@&token=%@desc=%@"
//-(NSString*) postArticleWithImageId:(NSString*)imageId andDesc:(NSString*)desc toType:(NSString*)type {
//    debugMethod();
//    // prepare data
//    NSString * imageJson = [self getImageDesc:[NSArray arrayWithObject:imageId]];
//    imageJson = [imageJson urlEncode];
//    desc =  [desc urlEncode];
//    NSString * tmpToken =  [self.token urlEncode];
//
//    // build url
//    NSString * urlStr = [NSString stringWithFormat:POST_URL, type, imageJson, tmpToken, desc];
//    debugLog(@"url string = %@", urlStr);
//    NSURL * url = [NSURL URLWithString:urlStr];
//    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
//    [request setUseCookiePersistence:NO];
//    [request startSynchronous];
//    NSError *error = [request error];
//    if (!error) {
//        NSString *response = [request responseString];
//        debugLog(@"response text: %@", response);
//        //NSDictionary * data;
//        //data = [jsonTool objectWithString:response error:&error];
//        if (!error) {
//            return response;
//        } else {
//            debugLog(@"Error while parsing json: %@", error);
//            return nil;
//        }
//    } else {
//        debugLog(@"Error info: %@", error);
//        return nil;
//    }
//}
//
//- (void) loadData {
//    debugMethod();
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults synchronize];
//    self.username = [defaults stringForKey:kUsername];
//    self.password = [defaults stringForKey:kPassword];
//    self.token = [defaults stringForKey:kToken];
//    debugLog(@"load setting: user:%@", self.username);
//    debugLog(@"load setting: pass:%@", self.password);
//    debugLog(@"load setting: token:%@", self.token);
//}
//
//- (void) resetData {
//    debugMethod();
//    self.username = self.password = nil;
//    self.token = nil;
//    [self saveData];
//}
//
//- (void) saveData {
//    debugMethod();
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:self.username forKey:kUsername];
//    [defaults setValue:self.password forKey:kPassword];
//    [defaults setValue:self.token forKey:kToken];
//    debugLog(@"save setting: user:%@", self.username);
//    debugLog(@"save setting: pass:%@", self.password);
//    debugLog(@"save setting: token:%@", self.token);
//    [defaults synchronize];
//}

@end
