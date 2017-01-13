//
//  ResultDicModel.m
//  AliSDKDemo
//
//  Created by liuyang on 17/1/3.
//  Copyright © 2017年 Alipay.com. All rights reserved.
//

#import "ResultDicModel.h"

@implementation ResultDicModel

-(NSDictionary *)toDictionaryData
{
    if ([self.result isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)self.result;
    }
    return nil;
}

-(NSArray *)toArrayData
{
    if ([self.result isKindOfClass:[NSArray class]]) {
        return (NSArray *) self.result;
    }
    return nil;
}


- (NSString *)toStringData{
    if ([self.result isKindOfClass:[NSString class]]) {
        return (NSString *) self.result;
    }
    return nil;
}
- (RealResultDicModel *)toModelData{
    
    NSString *jsonModelStr = self.toStringData;
   
    if (jsonModelStr) {
        
        //根据具体 情况书写
        NSError *jsonErr = nil;
        RealResultDicModel *realResultDicModel = [[RealResultDicModel alloc]initWithString:jsonModelStr error:&jsonErr];
        
        if (!jsonErr) {
            NSLog(@"数据转model错误:%@",jsonErr);
            return nil;
        }
        return realResultDicModel;
    }
    return nil;
}

@end



@implementation RealResultDicModel

-(NSDictionary *)toDictionaryData
{
    if ([self.alipay_trade_app_pay_response isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)self.alipay_trade_app_pay_response;
    }
    return nil;
}

-(NSArray *)toArrayData
{
    if ([self.alipay_trade_app_pay_response isKindOfClass:[NSArray class]]) {
        return (NSArray *) self.alipay_trade_app_pay_response;
    }
    return nil;
}


- (NSString *)toStringData{
    if ([self.alipay_trade_app_pay_response isKindOfClass:[NSString class]]) {
        return (NSString *) self.alipay_trade_app_pay_response;
    }
    return nil;
}



@end