//
//  MMoka.m
//  linker
//
//  Created by 李迪 on 14-8-31.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import "MMoka.h"

@implementation MMoka

- (instancetype)initWithDictionary:(NSDictionary *)dic_
{
    if (self=[super init]) {
        self.f_moka_order_id = [dic_ objectForKey:@"order_id"];
        self.f_moka_increment_id = [dic_ objectForKey:@"increment_id"];
        self.f_moka_status = [dic_ objectForKey:@"status"];
        self.f_moka_merchan_name = [dic_ objectForKey:@"merchan_name"];
        self.f_moka_icon = [dic_ objectForKey:@"icon"];
        self.f_moka_store_name = [dic_ objectForKey:@"store_name"];
        self.f_moka_price = [dic_ objectForKey:@"price"];
        self.f_moka_sender = [dic_ objectForKey:@"sender"];
        self.f_moka_place = [dic_ objectForKey:@"place"];
        self.f_moka_validtime = [dic_ objectForKey:@"validtime"];
        self.f_moka_background_img = [dic_ objectForKey:@"background_img"];
        self.f_moka_message = [dic_ objectForKey:@"message"];
        self.f_moka_can_consume_num = [dic_ objectForKey:@"can_consume_num"];
        
        NSDictionary *combo = [dic_ objectForKey:@"combo"];
        self.f_moka_combo_id = [combo objectForKey:@"combo_id"];
        self.f_moka_combo_name = [combo objectForKey:@"combo_name"];
        
        //NSArray *can_consume_store = [dic_ objectForKey:@"can_consume_store"];

        self.f_moka_can_consume_store = [dic_ objectForKey:@"can_consume_store"];


    }
    
    return self;
}
@end
