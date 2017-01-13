//
//  ResultDicModel.h
//  AliSDKDemo
//
//  Created by liuyang on 17/1/3.
//  Copyright © 2017年 Alipay.com. All rights reserved.
//

#import "JSONModel.h"

@class RealResultDicModel;
@interface ResultDicModel : JSONModel

@property(nonatomic,copy)NSString *memo;

@property(nonatomic,assign)NSInteger *resultStatus;

@property(nonatomic,strong)NSObject *result;
//@property (nonatomic,strong) NSObject <Optional> *resultMap;


- (NSDictionary *)toDictionaryData;
- (NSArray *)toArrayData;
- (NSString *)toStringData;
- (RealResultDicModel *)toModelData;

@end



@interface RealResultDicModel : JSONModel

@property(nonatomic,strong)NSObject *alipay_trade_app_pay_response;

@property(nonatomic,copy)NSString *sign;

@property(nonatomic,copy)NSString *sign_type;

- (NSDictionary *)toDictionaryData;
- (NSArray *)toArrayData;
- (NSString *)toStringData;

@end