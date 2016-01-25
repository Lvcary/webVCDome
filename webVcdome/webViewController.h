//
//  webViewController.h
//  webVCDome
//
//  Created by 刘康蕤 on 16/1/25.
//  Copyright © 2016年 Lvcary. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    webRightItemNo,
    webRightItemShare,
    webrightItemCare,
    webRightItemCustom
}rightItemType;
@interface webViewController : UIViewController

@property (nonatomic, copy) NSString *webUrlStr;   ///<请求的url
@property (nonatomic, assign) rightItemType itemType;   ///<右item类型  默认nil

@end
