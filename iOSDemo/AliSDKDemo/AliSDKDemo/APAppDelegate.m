//
//  APAppDelegate.m
//  AliSDKDemo
//
//  Created by 方彬 on 11/29/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import "APAppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

// 以下的类是验证支付结果用的  不验证不需要引用
#import "DataVerifier.h" // 验证签名
//#import "AlixPayResult.h" // 支付结果处理
#import "JSONModel.h"
#import "ResultDicModel.h"
@class RealResultDicModel;

@implementation APAppDelegate{

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */
#pragma mark --步骤4：配置支付宝客户端返回url处理方法。（外部存在支付包钱包，支付宝钱包将处理结果通过url返回。）在@implementation AppDelegate中以下代码中的NSLog改为实际业务处理代码：

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
         
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      
                                                      NSLog(@"result = %@",resultDic);
                                                      
                                                      //对独立客户端回调结果验证
                                                      [self paymentResultNew:resultDic];
                                                  }];
        
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url
         
                                      standbyCallback:^(NSDictionary *resultDic) {
                                          
                                          NSLog(@"result = %@",resultDic);
                                          
                                      }];
    }
    
    
    
    
    
    
    
    
    return YES;
}

#pragma mark --此处注意了：使用支付宝网页版的回调 会在这里  但是使用支付宝客户端的回调 会在Appdelegate的回调方法中[两者本质不同 后者是应用之间的跳转(应用间跳转 openURL)  前者只是页面加载而已]
#pragma mark --支付完成 返回时 该方法会执行 byzzj 已经验证过了()
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
         
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      
                                                      NSLog(@"result = %@",resultDic);
                                                      
                                                      //对独立客户端回调结果验证
                                                      [self paymentResultNew:resultDic];
                                                  }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        
    }
    
    if ([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url
         
                                      standbyCallback:^(NSDictionary *resultDic) {
                                          
                                          NSLog(@"result = %@",resultDic);
                                          
                                          
                                      }];
    }
    
    return YES;
}

#pragma mark - 对独立客户端回调结果验证
- (void)paymentResultNew:(NSDictionary *)resultDic
{
    
    //支付宝公钥（目前所有支付宝公钥都是这个）
    NSString* key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB";
    //这个方法应该是初始化公钥并保存到本地吧
    id<DataVerifier> verifier = CreateRSADataVerifier(key);
    
    if (resultDic)
    {
        /*
         9000 订单支付成功
         8000 正在处理中
         4000 订单支付失败
         6001 用户中途取消
         6002 网络连接出错
         */
        if ([resultDic[@"resultStatus"] integerValue] == 9000)
            //网上很多教程到这里就结束了，因为他们没有验证返回订单签名
        {
            // NSLog(@"resultDic[@\"result\"] = %@",resultDic[@"result"]);
            
            NSString *resultStr = resultDic[@"result"];
            //验签
            //分割字符串获取订单信息和签名
            //去掉返回字典中result值里面的“{\"alipay_trade_app_pay_response\":” 头部
            NSString *result = [resultStr stringByReplacingOccurrencesOfString:@"{\"alipay_trade_app_pay_response\":" withString:@""];
            //去掉返回字典中result值里面的“\",\"sign_type\":\"RSA\"}” 尾部
            result = [result stringByReplacingOccurrencesOfString:@"\",\"sign_type\":\"RSA\"}" withString:@""];
            //分割字符串获取订单信息和签名
            NSArray *array = [result componentsSeparatedByString:@",\"sign\":\""];//中间 分割
            
            //返回的订单信息
            NSString *orderString = array[0];
            NSString *signedString = array[1];
            
            //验证返回信息与签名
            if ([verifier verifyString:orderString withSign:signedString])
            {
                //验证签名成功，交易结果无篡改
                NSLog(@"------------支付成功---------------");
            }
            else
            {
                //验签错误
                NSLog(@"------------验签错误---------------");
            }
            
            
        }
        else
        {
            NSLog(@"交易失败 %zd",[resultDic[@"resultStatus"] integerValue]);
        }
        
    }else{
#pragma mark --测试 验证 --也即验证签名
        //交易失败
        NSString *resultStr = @"{\"alipay_trade_app_pay_response\":{\"code\":\"10000\",\"msg\":\"Success\",\"app_id\":\"2016122904720193\",\"auth_app_id\":\"2016122904720193\",\"charset\":\"utf-8\",\"timestamp\":\"2017-01-03 12:11:05\",\"total_amount\":\"0.01\",\"trade_no\":\"2017010321001004550232501630\",\"seller_id\":\"2088521538362085\",\"out_trade_no\":\"DHOECO9EPO95K7Y\"},\"sign\":\"uUDBTmP9QtgQtXGwv6VEwgojckHvPvuDyQxrtqF7Y/PpeqLlmxLBAupQQMCB0V7dwWfk7pEX8wupl3mIJa4Ik9XAMQeWXOmAS18HuAlPggB3PTNDOEcGo+/lbwzuVeD1ndyw6qc5znxeOVLJ2n4m4qPld3syTNR425M/89HOo7I=\",\"sign_type\":\"RSA\"}";
        NSLog(@"resultStr = %@",resultStr);
        
        
        //验签
        //分割字符串获取订单信息和签名
        //返回的订单信息
        NSString *orderString = @"{\"code\":\"10000\",\"msg\":\"Success\",\"app_id\":\"2016122904720193\",\"auth_app_id\":\"2016122904720193\",\"charset\":\"utf-8\",\"timestamp\":\"2017-01-03 12:11:05\",\"total_amount\":\"0.01\",\"trade_no\":\"2017010321001004550232501630\",\"seller_id\":\"2088521538362085\",\"out_trade_no\":\"DHOECO9EPO95K7Y\"}";
        //返回的订单签名
        NSString *signedString = @"uUDBTmP9QtgQtXGwv6VEwgojckHvPvuDyQxrtqF7Y/PpeqLlmxLBAupQQMCB0V7dwWfk7pEX8wupl3mIJa4Ik9XAMQeWXOmAS18HuAlPggB3PTNDOEcGo+/lbwzuVeD1ndyw6qc5znxeOVLJ2n4m4qPld3syTNR425M/89HOo7I=";
        
        //去掉返回字典中result值里面的“{\"alipay_trade_app_pay_response\":”
        NSString *result = [resultStr stringByReplacingOccurrencesOfString:@"{\"alipay_trade_app_pay_response\":" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\",\"sign_type\":\"RSA\"}" withString:@""];
        //分割字符串获取订单信息和签名
        NSArray *array = [result componentsSeparatedByString:@",\"sign\":\""];
        
        //返回的订单信息
        NSString *orderString1 = array[0];
        NSString *signedString1 = array[1];
        
        if ([orderString isEqualToString:orderString1]) {
            NSLog(@"截取的订单信息 OK");
        }
        
        if ([signedString isEqualToString:signedString1]) {
            NSLog(@"截取的订单签名 OK");
        }
        
        //验证返回信息与签名
        if ([verifier verifyString:orderString withSign:signedString])
        {
            //验证签名成功，交易结果无篡改
            NSLog(@"------------支付成功---------------");
        }
        else
        {
            //验签错误
            NSLog(@"------------验签错误---------------");
        }
        
    }
}


@end
