/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComMamashaiTiwechatModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComMamashaiTiwechatModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"c3b560f8-e2db-4717-9bcb-f25bc4b6e317";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.mamashai.tiwechat";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs 

-(id)shareTimeline:(id)args{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [args objectAtIndex:0];
    message.description = [args objectAtIndex:1];
    //[message setThumbImage:[UIImage imageNamed:@"appicon.png"]];
    
    if ([args objectAtIndex:2] != nil){
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[args objectAtIndex:3]]]];
        [message setThumbImage:image];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [args objectAtIndex:2];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    return @"ok";
}

-(id)shareSession:(id)args{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [args objectAtIndex:0];
    message.description = [args objectAtIndex:1];
    //[message setThumbImage:[UIImage imageNamed:@"appicon.png"]];
    
    if ([args objectAtIndex:2] != nil){
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[args objectAtIndex:3]]]];
        [message setThumbImage:image];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [args objectAtIndex:2];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
    return @"ok";
}

-(id)loginWeixin:(id)args{
	SendAuthReq* req =[[[SendAuthReq alloc ] init ] autorelease ];
	req.scope = @"snsapi_userinfo" ;
	req.state = [args objectAtIndex:0]; ;
	//第三方向微信终端发送一个SendAuthReq消息结构
	
	[WXApi sendReq:req];
	
	return @"ok";
}

-(id)isWeixinInstalled:(id)args{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
	{
		return @"yes";
	}
	else{
		return @"no";
	}
	
	if ([WXApi isWXAppInstalled]) {
     	//判断是否有微信
     	return @"yes";
	}
	else{
		return @"no";
	}
}

-(id)shareText:(id)args{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = @"宝宝日历发来贺电";
    req.scene = WXSceneTimeline;        //朋友圈
    
    [WXApi sendReq:req];
    
    return @"ok";
}

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
	NSString *key = [TiUtils stringValue:value];
	
	//[WXApi registerApp:@"wxc4e544191aa9121a" withDescription:@"baby Calendar"];
	[WXApi registerApp:key withDescription:@"baby Calendar"];
}

-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
/*
-(void) onResp:(BaseResp*)resp
{
    NSString *strTitle = [NSString stringWithFormat:@"提示"];
    NSString *strMsg = [NSString stringWithFormat:@"发送微信成功"];
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~onResp called~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
*/

@end
