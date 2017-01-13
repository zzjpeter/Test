//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"// 订单信息
#import "APAuthV2Info.h"
#import "DataSigner.h"// 签名
#import <AlipaySDK/AlipaySDK.h>


// 以下的类是验证支付结果用的  不验证不需要引用
#import "DataVerifier.h" // 验证签名
//#import "AlixPayResult.h" // 支付结果处理
#import "JSONModel.h"
#import "ResultDicModel.h"
@class RealResultDicModel;


#define PID (@"2088521538362085")

//#define APPID  (@"2016122804689974")
//2016122904720193
#define APPID  (@"2016122904720193")

#define PRIVATEKEY (@"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDIOqPw4L5eHAnAwPXz3nDKuVovlKSS0oTqzdBw5JMh1FubQj4VNzktTTUk1/tUHentILfwwj73t3ycP/P+PmnS9T00nf6x+nKA9zB7OstsimeFiRH7wRuzDpp8jGzxVcYFru2JXM2qTdgXgtLGfscR7fysLkRNQt3/oFCo4jqmy1TvEtuSSJ9pRqFBzehpH+wHPS3rZZoeYtCkm6QaATH4esjQPMEiA2exx9BIc99iD0C2wolPSWR+7T1FxMfe3Ut196AlHRnVDZgRjaKh0nWawDwO/3Pdv/3uo4mRlSKjzeidzYJSJ6Hodnbslo+6LCGbeGjX1y+v+aVy/75rQtc7AgMBAAECggEBAIvBGlJzm4v2R/xo8oK/3LwyuTcCqgfstmdpNjbF48g1/6aTit+mBtuOyywnMD4bDv662ohKHEcso+YvYS8xAw4CrDDAolg5dZh8cDNi6z+cLvtum8W7mIjXBY8vOI8ODkRDP3qj8s0OvmhSoKl5LZtfIABR3syKgob8r6/hD40AmuuxVZcBcmgAj3YpBDboHDhC5KPTQZ3zYKrTQrrGYix+4qcc/P0Tb3cuKmrekvbq72in/wcTBBGlTpAFz+FPfoIcTh95GS9AzRQnIaDym3rb89xGWEp7ko4apurzRqed891VbwLrn6SP65u0JsBlTALMEGcezfPME8uEOUwzqZkCgYEA/eQNDEPyRWmwSbmPkWHzw1MmkFbheHmF7LuaecshSEE6MMw3rVqy9PBVhwa2iOz431F8IH70d6Cbdewxfi+Zo6nISmNCjw1dGj2Zurjin4234lXDfSic0SLYy3ALoBkKZznbSwnr70Z+HeZHHWsfWNdWTKOKxgW/nhgRI/PEbzcCgYEAyeR3ktQX1Lcw+zyN0bKiwk1xTTGdmqlF3ZztJL64QxvxpiK5Yl0yahx5rm4Kmo16OymnRnCWOtcujDRUIc2q+pDz55Sa2Ec3cupA6i0RMFSulwxvnybKpNv4YcTTH2mAGUK32SiTb7KcZBXdQ7Wa8aGTFGbZshMSMIwvxRfCsh0CgYEA9wOztiU9R09mlrQU/GuCkJ0Lvg7pWx9Qr1xvFOQOw4/Cn8twuBawWiKh87cSTPHRyOQskikyjFkUJ4zfMlf5cQQ0vDsKfMeRt4ALW2GaC4YETA8JHXIv8EGpD3U5uk/ikT/3HXDPvYKmHUz4D6UzYGpRqkrLL5JUNepQctwuV80CgYBqisfTU1v0JGyT2OPaitO7iBTHsOxEBxpYlgzLfF5PA/slOmPsldQaDUbllyq/XvPnLtcYpCeTi6UD1kWjxR56tm4QguqoQgTv/tEdA4VzpOyxx51MNrNwBqlwJudnR0yTiBLvZatQochIRQWMStUmuKaeeJxfjhLmTcST1TMovQKBgEXfS3yS9CPK4MeOf1WJG+djfq9xkwXPTwzHS+JUse7Dee0ViQEyVMnOJa6lao53swrBZUDSKV8VXA6migh4vWyrvZkPmFZRuR0e64cisbSmPm43AvcDhFweQjbSYLUXnnU3TWA1Dp8Z8B4WK+DPjE2pYP7dT1RhlyKzbWzK4gwr")



#define ALI_DEMO_BUTTON_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 40.0f)
#define ALI_DEMO_BUTTON_HEIGHT (60.0f)
#define ALI_DEMO_BUTTON_GAP    (30.0f)


#define ALI_DEMO_INFO_HEIGHT (200.0f)


@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateButtons];
}


#pragma mark -
#pragma mark   ==============产生随机订单号==============

- (void)generateButtons
{
    // NOTE: 支付按钮，模拟支付流程
    CGFloat originalPosX = 20.0f;
    CGFloat originalPosY = 100.0f;
    UIButton* payButton = [[UIButton alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, ALI_DEMO_BUTTON_HEIGHT)];
    payButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    payButton.layer.masksToBounds = YES;
    payButton.layer.cornerRadius = 4.0f;
    [payButton setTitle:@"支付宝支付Demo" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(doAlipayPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    // NOTE: 授权按钮，模拟授权流程
    originalPosY += (ALI_DEMO_BUTTON_HEIGHT + ALI_DEMO_BUTTON_GAP);
    UIButton* authButton = [[UIButton alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, ALI_DEMO_BUTTON_HEIGHT)];
    authButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    authButton.layer.masksToBounds = YES;
    authButton.layer.cornerRadius = 4.0f;
    [authButton setTitle:@"支付宝授权Demo" forState:UIControlStateNormal];
    [authButton addTarget:self action:@selector(doAlipayAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authButton];
    
    // NOTE: 重要说明
    NSString* text = @"重要说明:\n本Demo为了方便向商户展示支付宝的支付流程，所以订单信息的加签过程放在客户端完成；\n在商户的真实App内，为了防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；\n商户privatekey等数据严禁放在客户端，订单信息的加签过程也务必放在服务端完成；\n若商户接入时不遵照此说明，因此造成了损失，需自行承担。";
    CGFloat infoHeight = [text boundingRectWithSize:CGSizeMake(ALI_DEMO_BUTTON_WIDTH, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}
                                            context:nil].size.height;
    originalPosY = ([UIScreen mainScreen].bounds.size.height) - (infoHeight + 2) - ALI_DEMO_BUTTON_GAP;
    UILabel* information = [[UILabel alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, infoHeight + 2)];
    information.numberOfLines = 0;
    information.backgroundColor = [UIColor clearColor];
    [information setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [information setTextColor:[UIColor redColor]];
    information.text = text;
    [self.view addSubview:information];
    
}

- (NSString *)generateTradeNO
{
	static int kNumber = 15;
	
	NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *resultStr = [[NSMutableString alloc] init];
	srand((unsigned)time(0));
	for (int i = 0; i < kNumber; i++)
	{
		unsigned index = rand() % [sourceStr length];
		NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
		[resultStr appendString:oneStr];
	}
	return resultStr;
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay
{
    

    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
    NSString *appID = @"";
    appID = APPID;
    NSString *privateKey = @"";
    privateKey = PRIVATEKEY;
/*============================================================================*/
/*============================================================================*/
/*============================================================================*/
	
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"\n####################\norderSpec = %@\n#######################",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        NSLog(@"\n####################\norderString = %@\n####################",orderString);
        
#if 0
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
#pragma mark --此处注意了：使用支付宝网页版的回调 会在这里  但是使用支付宝客户端的回调 会在Appdelegate的回调方法中[两者本质不同 后者是应用之间的跳转(应用间跳转 openURL)  前者只是页面加载而已]
            
            [self paymentResultNew:resultDic];
        }];
        
#elif 1
        
        
        [self paymentResultNew:nil];
        
#endif
        

    }

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
            NSLog(@"resultDic[@\"result\"] = %@",resultDic[@"result"]);
            
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
        
        
        
#if 1
#pragma mark -测试 使用model解析 --不使用字符串截取
        [self testModel:resultStr];
        
#elif 0
        
        
        //验签
        //分割字符串获取订单信息和签名
        //返回的订单信息
        NSString *orderString = @"{\"code\":\"10000\",\"msg\":\"Success\",\"app_id\":\"2016122904720193\",\"auth_app_id\":\"2016122904720193\",\"charset\":\"utf-8\",\"timestamp\":\"2017-01-03 12:11:05\",\"total_amount\":\"0.01\",\"trade_no\":\"2017010321001004550232501630\",\"seller_id\":\"2088521538362085\",\"out_trade_no\":\"DHOECO9EPO95K7Y\"}";
        //返回的订单签名
        NSString *signedString = @"uUDBTmP9QtgQtXGwv6VEwgojckHvPvuDyQxrtqF7Y/PpeqLlmxLBAupQQMCB0V7dwWfk7pEX8wupl3mIJa4Ik9XAMQeWXOmAS18HuAlPggB3PTNDOEcGo+/lbwzuVeD1ndyw6qc5znxeOVLJ2n4m4qPld3syTNR425M/89HOo7I=";
        
        //验签
        //去掉返回字典中result值里面的“{\"alipay_trade_app_pay_response\":” 头部
        NSString *result = [resultStr stringByReplacingOccurrencesOfString:@"{\"alipay_trade_app_pay_response\":" withString:@""];
        //去掉返回字典中result值里面的“\",\"sign_type\":\"RSA\"}” 尾部
        result = [result stringByReplacingOccurrencesOfString:@"\",\"sign_type\":\"RSA\"}" withString:@""];
        //分割字符串获取订单信息和签名
        NSArray *array = [result componentsSeparatedByString:@",\"sign\":\""];//中间 分割
        
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
#endif

    }
}


- (void)testModel:(NSString *)resultStr{
    
    //支付宝公钥（目前所有支付宝公钥都是这个）
    NSString* key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB";
    //这个方法应该是初始化公钥并保存到本地吧
    id<DataVerifier> verifier = CreateRSADataVerifier(key);

    //验签
    //分割字符串获取订单信息和签名
    //返回的订单信息--必须保证顺序 不变 才可以验证签名成功
    NSString *orderString = @"{\"code\":\"10000\",\"msg\":\"Success\",\"app_id\":\"2016122904720193\",\"auth_app_id\":\"2016122904720193\",\"charset\":\"utf-8\",\"timestamp\":\"2017-01-03 12:11:05\",\"total_amount\":\"0.01\",\"trade_no\":\"2017010321001004550232501630\",\"seller_id\":\"2088521538362085\",\"out_trade_no\":\"DHOECO9EPO95K7Y\"}";
    
    //NSString *orderString = @"{\"msg\":\"Success\",\"code\":\"10000\",\"app_id\":\"2016122904720193\",\"auth_app_id\":\"2016122904720193\",\"charset\":\"utf-8\",\"timestamp\":\"2017-01-03 12:11:05\",\"total_amount\":\"0.01\",\"trade_no\":\"2017010321001004550232501630\",\"seller_id\":\"2088521538362085\",\"out_trade_no\":\"DHOECO9EPO95K7Y\"}";
    //返回的订单签名
    NSString *signedString = @"uUDBTmP9QtgQtXGwv6VEwgojckHvPvuDyQxrtqF7Y/PpeqLlmxLBAupQQMCB0V7dwWfk7pEX8wupl3mIJa4Ik9XAMQeWXOmAS18HuAlPggB3PTNDOEcGo+/lbwzuVeD1ndyw6qc5znxeOVLJ2n4m4qPld3syTNR425M/89HOo7I=";
    
    NSError *jsonErr = nil;
    RealResultDicModel *realResultDicModel = [[RealResultDicModel alloc]initWithString:resultStr error:&jsonErr];
    
    NSLog(@"#####################################");
    NSLog(@"#####################################");
    NSLog(@"#####################################");
    
    NSLog(@"alipay_trade_app_pay_response = %@",realResultDicModel.alipay_trade_app_pay_response);
    NSLog(@"sign = %@",realResultDicModel.sign);
    NSLog(@"sign_type = %@",realResultDicModel.sign_type);
    
    if (jsonErr) {
        NSLog(@"数据 转 model失败 ：%@",jsonErr);
        
        return;
    }
    
    //NSLog(@"数据 转 model OK ：%@",realResultDicModel);
    NSLog(@"数据 转 model OK");
    
//    //realResultDicModel.alipay_trade_app_pay_response  字典 转字符串
//    NSDictionary *alipay_trade_app_pay_responseDic = realResultDicModel.toDictionaryData;
//    NSString *str = [self dictionaryToJson:alipay_trade_app_pay_responseDic];
//    NSLog(@"str = %@",str);
    
    
#pragma mark -为保证原始串的顺序 只能进行字符串截取 千万注意啊
    //验签
    //去掉返回字典中result值里面的“{\"alipay_trade_app_pay_response\":” 头部
    NSString *result = [resultStr stringByReplacingOccurrencesOfString:@"{\"alipay_trade_app_pay_response\":" withString:@""];
//    //去掉返回字典中result值里面的“\",\"sign_type\":\"RSA\"}” 尾部
//    result = [result stringByReplacingOccurrencesOfString:@"\",\"sign_type\":\"RSA\"}" withString:@""];
    //分割字符串获取订单信息和签名
    NSArray *array = [result componentsSeparatedByString:@",\"sign\":\""];//中间 分割
    
    //返回的订单信息
    NSString *orderString1 = array[0];
    NSString *signedString1 = realResultDicModel.sign;
    
    if ([orderString isEqualToString:orderString1]) {
        NSLog(@"截取的订单信息 OK");
    }
    
    if ([signedString isEqualToString:signedString1]) {
        NSLog(@"截取的订单签名 OK");
    }
    
    //验证返回信息与签名
    if ([verifier verifyString:orderString1 withSign:signedString1])
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


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//词典转换为字符串

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//- (void)paymentResult:(NSString *)resultDicToString
//{
//    //结果处理
//    AlixPayResult *result = [[AlixPayResult alloc] initWithString:resultDicToString];
//    if (result)
//    {
//        if (result.statusCode == 9000)        {
//            /**            * 支付成功用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//             */
//            // 就是在生产订单时，需要使用私钥生成签名值；在处理返回的支付结果时，需要使用公钥验证返回结果是否被篡改了。
//            // resultDic 返回结果所对应的值可以到支付宝开发平台上去查
//            // 在处理结果之前应该先对支付结果进行签名验证，防止支付数据被篡改。
//            // 返回的支付结果中的result字段里是带有订单信息和签名信息的，所以签名验证就是需要这个字段的值。            // 分发出得公钥
//            // 验证的步骤：首先把订单信息和签名值分别提取出来
//            // 订单信息就是sign_type的连字符&之前的所有字符串
//            // 签名值是sign后面双引号内的内容，注意签名的结尾也是=，所以不要用split字符串的方式提取
//            NSString* key = AlipayPublicKey;//签约帐户后获取到的支付宝公钥
//            id<DataVerifier>verifier;
//            verifier = CreateRSADataVerifier(key);
//            // 参数1：订单信息
//            // 参数2：签名值
//            if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                // 验证签名成功，交易结果无篡改
//                NSLog(@"支付成功!");
//            }
//            
//        }
//        else
//        {
//            // 支付失败
//            NSLog(@"%d%@", result.statusCode, result.statusMessage);
//        }
//    }
//    
//    else
//    {
//        // 支付失败
//        NSLog(@"支付失败!");
//    }
//    
//}


#pragma mark -
#pragma mark   ==============点击模拟授权行为==============

- (void)doAlipayAuth
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *pid = @"";
    pid = PID;
    NSString *appID = @"";
    appID = APPID;
    NSString *privateKey = @"";
    privateKey = PRIVATEKEY;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = pid;
    authInfo.appID = appID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"\n###################\nauthInfoStr = %@\n###################",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:authInfoStr];
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA"];
        
        NSLog(@"\n###################\nauthInfoStr:%@\n###################",authInfoStr);
        
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
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
}

@end
