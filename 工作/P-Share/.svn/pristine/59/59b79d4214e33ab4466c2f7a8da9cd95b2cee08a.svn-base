//
//  InvoiceController.h
//  P-Share
//
//  Created by 亮亮 on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger , CLLIsNotInvoiceState){
    CLLIsNotInvoiceStateMonth      =  0,
    CLLIsNotInvoiceStateProperty
};

@interface InvoiceController : BaseViewController
@property (nonatomic,copy)void (^invoiceControllerBlock)(NSString *);
@property (nonatomic,assign)BOOL hasInvoice;

@property (nonatomic,assign)CLLIsNotInvoiceState state;
@property (nonatomic,strong)OrderModel *order;
@end
