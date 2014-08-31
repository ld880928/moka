//
//  MMoka.h
//  linker
//
//  Created by 李迪 on 14-8-31.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMoka : NSObject

@property (nonatomic,strong)NSNumber *ID;

@property (nonatomic,strong)NSString *f_moka_type; //send   receive

@property (nonatomic,strong)NSString *f_moka_order_id;     //order_id
@property (nonatomic,strong)NSString *f_moka_increment_id; //increment_id
@property (nonatomic,strong)NSString *f_moka_status;       //status
@property (nonatomic,strong)NSString *f_moka_merchan_name; //merchan_name
@property (nonatomic,strong)NSString *f_moka_icon;         //icon
@property (nonatomic,strong)NSString *f_moka_store_name;   //store_name
@property (nonatomic,strong)NSString *f_moka_price;        //price

@property (nonatomic,strong)NSString *f_moka_sender;        //sender
@property (nonatomic,strong)NSString *f_moka_place;        //place

@property (nonatomic,strong)NSString *f_moka_validtime;    //validtime
@property (nonatomic,strong)NSString *f_moka_background_img; //background_img
@property (nonatomic,strong)NSString *f_moka_message;      //message
@property (nonatomic,strong)NSNumber *f_moka_can_consume_num; //can_consume_num

/* 
 "combo": {
 "combo_id": null,
 "combo_name": null
 },
 */
@property (nonatomic,strong)NSString *f_moka_combo_id;
@property (nonatomic,strong)NSString *f_moka_combo_name;

/*
 "can_consume_store": {
 "4": {
 "store_name": "肯德基佳丽广场店",
 "store_address": "佳丽广场负一楼",
 "store_contact": "88087707"
 }
 }
 */
@property (nonatomic,strong)NSArray *f_moka_can_consume_store; //can_consume_store

- (instancetype)initWithDictionary:(NSDictionary *)dic_;

@end
