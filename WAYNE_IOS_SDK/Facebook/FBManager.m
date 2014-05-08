//
//  FacebookUtil.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-9-27.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "FBManager.h"

#warning to change to all friends
static FBSessionDefaultAudience defaultAudience = FBSessionDefaultAudienceOnlyMe;

@implementation FBManager {
    FBSession* _session;
    FBRequestConnection* _connection;
}
-(void)dealloc{
    [self cancelConnection];
}
+(id)sharedInstance
{
    static dispatch_once_t pred;
    static FBManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
//    id a ;[a class]
    return sharedInstance;
}

-(FBSession *)session{
    if (_session == nil||_session.state != FBSessionStateCreated) {
        _session = [[FBSession alloc]init
//                        WithPermissions:@[
//                                                               @"friends_games_activity",
//                                                               @"user_games_activity"]
                        ];
    }
    return _session;
}
-(void)loginWithCompletionHandler:(FBSessionStateHandler)handler{
    if (![self session].isOpen) {
        if ([self session].state == FBSessionStateCreatedOpening) {
            return;
        }
        [[self session] openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (handler) {
                NSLog(@"login:%d---%@",status,error);
                handler(session,status,error);
            }
        }];
    }
}
-(void)logout{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)requestForMeWithCompletionHandeler:(FBRequestHandler)requestHandler{
    [self cancelConnection];
    //    [self performPublishAction:^{
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                   graphPath:@"me"
                                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"id,name,username,first_name,last_name,gender", @"fields",
                                                              nil]
                                                  HTTPMethod:nil];
    _connection = [[FBRequestConnection alloc] init];
    [_connection addRequest:request
          completionHandler:requestHandler];
    [_connection start];
    //    }];
    
}

-(void)requestForFriendsWithCompletionHandeler:(FBRequestHandler)requestHandler{
    [self cancelConnection];
    //    [self performPublishAction:^{
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"me/friends"
                                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             @"id,name,username,first_name,last_name,gender", @"fields",
                                                             nil]
                                                 HTTPMethod:nil];
    _connection = [[FBRequestConnection alloc] init];
    [_connection addRequest:request
          completionHandler:requestHandler];
    [_connection start];
    //    }];
    
}

-(void)requestForScoresWithCompletionHandeler:(FBRequestHandler)requestHandler{
    [self cancelConnection];
    
//    _connection = [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/scores?fields=score,user",APP_ID_FB] parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        NSLog(@"%@=================%@",APP_ID_FB,result);
//        
//        
//    }];
//    return;
    _connection = [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/scores?fields=score,user", APP_ID_FB] parameters:nil HTTPMethod:@"GET" completionHandler:requestHandler];
    return;
    NSLog(@"ps====%@",[self session].permissions);
    NSString* appId = APP_ID_FB;
//            appId = @"100002502731089";
//            appId = @"100004996780572";
//            appId = @"100006527853824";
//            appId = _me.id;
//    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"type", @"fields",
//                            nil];
        FBRequest *request =
//    [FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@/scores",appId]];
    [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@/scores",appId] parameters:nil HTTPMethod:@"GET"];
        [request setSession:[self session]];
   
        _connection = [[FBRequestConnection alloc] init];
        [_connection addRequest:request
              completionHandler:requestHandler];
        [_connection start];
//    }];
    
}

#pragma mark- Requests
-(void)cancelConnection{
    if (_connection) {
        [_connection cancel];
    }
}
-(void)setMyScore:(NSUInteger)score completionHandler:(FBRequestHandler)handler{
    if (_me) {
        [self setScore:score userId:_me.id completionHandler:handler];
    }else{
        [[FBManager sharedInstance]requestForMeWithCompletionHandeler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *me, NSError *error) {
            [[FBManager sharedInstance]setMe:me];
            [self setScore:score userId:me.id completionHandler:handler];
        }];
    }
}
-(void)setScore:(NSUInteger)score userId:(NSString*)userId completionHandler:(FBRequestHandler)handler{
    [self cancelConnection];
    [self performPublishAction:^{
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%d", score], @"score",
                                       nil];
        
        _connection = [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/scores", userId] parameters:params HTTPMethod:@"POST" completionHandler:handler];
    }];
}
//THE FBSESSION MUST BE ISOPEN
-(void)feedImage:(UIImage*)image completionHandler:(FBRequestHandler)handler{
    [self cancelConnection];
    
    [self performPublishAction:^{
        _connection = [[FBRequestConnection alloc] init];
        _connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
        | FBRequestConnectionErrorBehaviorAlertUser
        | FBRequestConnectionErrorBehaviorRetry;
        
        [_connection addRequest:[FBRequest requestForUploadPhoto:image]
             completionHandler:handler];
        [_connection start];
    }];
}
-(void)feedWithText:(NSString*)text andImage:(UIImage*)image completionHandler:(FBRequestHandler)handler{
    [self cancelConnection];
    [self performPublishAction:^{
        if (image&&text) {
            NSMutableDictionary *params =
            [NSMutableDictionary dictionaryWithObjectsAndKeys:text,@"message",UIImageJPEGRepresentation(image,0.6),@"source", nil];
            
            _connection = [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:handler];
        }else{
            if (text) {
                _connection = [FBRequestConnection startForPostStatusUpdate:text completionHandler:handler];
            }else if(image){
                _connection = [FBRequestConnection startForUploadPhoto:image completionHandler:handler];
            }
            
        }
    }];
}
-(void) performPublishAction:(void (^)(void)) action {
    if (FBSession.activeSession.isOpen) {//如果SESSION有效
        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
            [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                  defaultAudience:defaultAudience
                                                completionHandler:^(FBSession *session, NSError *error) {
                                                    if (!error) {
                                                        action();
                                                    }else{
                                                        NSLog(@"#####%@",error);
                                                    }
                                                }];
        } else {
            action();
        }
    }else{
        [self loginWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            NSLog(@"Status:%d#####Login Error :%@",status,error);
            if(FBSession.activeSession.isOpen){
               [self performPublishAction:action];
            }
        }];
    }
}
@end
