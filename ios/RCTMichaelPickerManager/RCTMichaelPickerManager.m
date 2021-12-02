//
//  RCTMichaelPickerManager.m
//  RCTMichaelPickerManager
//
//  Created by MFHJ-DZ-001-417 on 16/9/6.
//  Copyright © 2016年 MFHJ-DZ-001-417. All rights reserved.
//

#import "RCTMichaelPickerManager.h"
#import "BzwPicker.h"
#import <React/RCTEventDispatcher.h>

@interface RCTMichaelPickerManager()

@property(nonatomic,strong)BzwPicker *pick;
@property(nonatomic,assign)float height;
@property(nonatomic,weak)UIWindow *window;
@property(nonatomic,weak)UIView *viewBackGround;

@end

@implementation RCTMichaelPickerManager

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(_init:(NSDictionary *)indic){

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    });

    self.window = [UIApplication sharedApplication].keyWindow;

    NSString *pickerConfirmBtnText=indic[@"pickerConfirmBtnText"];
    NSString *pickerCancelBtnText=indic[@"pickerCancelBtnText"];
    NSString *pickerTitleText=indic[@"pickerTitleText"];
    NSArray *pickerConfirmBtnColor=indic[@"pickerConfirmBtnColor"];
    NSArray *pickerCancelBtnColor=indic[@"pickerCancelBtnColor"];
    NSArray *pickerTitleColor=indic[@"pickerTitleColor"];
    NSArray *pickerToolBarBg=indic[@"pickerToolBarBg"];
    NSArray *pickerBg=indic[@"pickerBg"];
    NSArray *selectArry=indic[@"selectedValue"];
    NSArray *weightArry=indic[@"wheelFlex"];
    NSString *pickerToolBarFontSize=[NSString stringWithFormat:@"%@",indic[@"pickerToolBarFontSize"]];
    NSString *pickerFontSize=[NSString stringWithFormat:@"%@",indic[@"pickerFontSize"]];
    NSString *pickerFontFamily=[NSString stringWithFormat:@"%@",indic[@"pickerFontFamily"]];
    NSArray *pickerFontColor=indic[@"pickerFontColor"];
    NSString *pickerRowHeight=indic[@"pickerRowHeight"];
    id pickerData=indic[@"pickerData"];

    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];

    dataDic[@"pickerData"]=pickerData;

    [self.window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([obj isKindOfClass:[BzwPicker class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [obj removeFromSuperview];
            });
        }

    }];

    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0 ) {
        self.height=250;
    }else{
        self.height=220;
    }

    self.pick=[[BzwPicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height) dic:dataDic leftStr:pickerCancelBtnText centerStr:pickerTitleText rightStr:pickerConfirmBtnText topbgColor:pickerToolBarBg bottombgColor:pickerBg leftbtnbgColor:pickerCancelBtnColor rightbtnbgColor:pickerConfirmBtnColor centerbtnColor:pickerTitleColor selectValueArry:selectArry weightArry:weightArry pickerToolBarFontSize:pickerToolBarFontSize pickerFontSize:pickerFontSize pickerFontColor:pickerFontColor  pickerRowHeight: pickerRowHeight pickerFontFamily:pickerFontFamily];

    _pick.bolock=^(NSDictionary *backinfoArry){

        dispatch_async(dispatch_get_main_queue(), ^{

            [self.bridge.eventDispatcher sendAppEventWithName:@"pickerEvent" body:backinfoArry];
        });
    };
  
  _pick.blockClose=^(){
        [self hideAll];
  };
  
  

    dispatch_async(dispatch_get_main_queue(), ^{
     UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
         // 设置UIView对象的属性：设置背景颜色
      self.viewBackGround = view;
      self.viewBackGround.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
         // 将创建好的UIView对象添加到Window上显示
      UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAll)];
      [self.viewBackGround addGestureRecognizer:singleTap];
      [self.window addSubview:self.viewBackGround];
      [self.window addSubview:_pick];
    });

}

RCT_EXPORT_METHOD(show){
    if (self.pick) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{

                [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT-self.height, SCREEN_WIDTH, self.height)];

            }];
        });
    }return;
}

RCT_EXPORT_METHOD(hide){

    if (self.pick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height)];
            }];
        });
    }
//  [self.window removeFromSuperview];
  self.viewBackGround.hidden = YES;
  self.pick.hidden=YES;

    return;
}

RCT_EXPORT_METHOD(select: (NSArray*)data){

    if (self.pick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _pick.selectValueArry = data;
            [_pick selectRow];
        });
    }return;
}

RCT_EXPORT_METHOD(isPickerShow:(RCTResponseSenderBlock)getBack){

    if (self.pick) {

        CGFloat pickY=_pick.frame.origin.y;

        if (pickY==SCREEN_HEIGHT) {

            getBack(@[@YES]);
        }else
        {
            getBack(@[@NO]);
        }
    }else{
        getBack(@[@"picker不存在"]);
    }
}

-(void)hideAll{
  
  if (self.pick) {
      dispatch_async(dispatch_get_main_queue(), ^{
          [UIView animateWithDuration:.3 animations:^{
              [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height)];
          }];
      });
  }
self.viewBackGround.hidden = YES;
self.pick.hidden=YES;

  return;
}

@end
