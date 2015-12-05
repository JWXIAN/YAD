//
//  Bespoke_verify.m
//  JXT
//
//  Created by 1039soft on 15/7/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "Bespoke_verify.h"
#import "JiaxiaotongAPI.h"
#import "DynamicPeriodList.h"
#import "MBProgressHUD+MJ.h"
#import "PeriodListContent.h"
#import "JWgetappointment.h"
#import "PopoverView.h"
@interface Bespoke_verify ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *type;

@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *select_gap;//选择科目类型距离右侧侧
@property(strong,nonatomic) NSArray*  period,* typeCode,* typeName;//获取联动时间段 ,存放科目代码 ,存放科目名称
@property(strong,nonatomic) NSMutableArray* conjunction;//保存联动时间
@property(strong,nonatomic) NSMutableString* conjunction_time,* conjunction_code;//联动时间，联动时间代码
@property(strong,nonatomic) NSString*  thisday,* selectType;//当前日期 - 年月日   ,选择的科目类别代码


@end

@implementation Bespoke_verify
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if (self.view.frame.size.width<=320) {
        _select_gap.constant=0;
    }
    else if (self.view.frame.size.width>320&&self.view.frame.size.width<414)
    {
        _select_gap.constant-=17;
    }
}
#pragma - mark  按钮
- (IBAction)select:(UIButton *)sender {
    CGPoint point = CGPointMake(_type.center.x , _type.frame.origin.y + _type.frame.size.height);
    
    NSArray* titles=_typeName;
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        [_type setTitle:titles[index] forState:UIControlStateNormal];
//        _type.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//        _type.titleLabel.textAlignment=NSTextAlignmentLeft;
        _selectType=_typeCode[index];
        
    };
    
    [pop show];

}
- (IBAction)submit:(UIButton *)sender {
    
   
    
    if (_selectType==nil) {
        [MBProgressHUD showError:@"请选择科目类型"];
    }
    else
    {
    sender.enabled=NO;
    [MBProgressHUD showMessage:@"正在预约"];
    NSString* type =[_selectType stringByReplacingOccurrencesOfString:@"<" withString:@""];
    type=[type stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSArray* arr = [_conjunction_code componentsSeparatedByString:@","];

    NSMutableString* conjunction=[NSMutableString string];
    NSMutableString* dayNow = [NSMutableString string];
   
    for (int i=0; i<arr.count-1; i++) {
        [conjunction appendString:[NSString stringWithFormat:@"%@,",_thisday]];
        [dayNow appendString:[NSString stringWithFormat:@"%@,",_thisday]];

    }

        for (int i = 0; i<arr.count-1; i++) {
            [conjunction appendString:arr[i]];
            [conjunction appendString:@","];
        
        }
    conjunction=(NSMutableString* )[conjunction substringToIndex:[conjunction length] - 1];
   dayNow= (NSMutableString*)[dayNow substringToIndex:[dayNow length] - 1];
   
    
 
    NSDictionary* dic=@{@"shiduan":conjunction,@"kemu":type,@"carid":_driTeaListInfo.code};
      
    [JWgetappointment Verificationappointment:dic andCallback:^(id obj) {
         sender.enabled=YES;
        if ([obj[@"body"][@"result"] isEqualToString:@"1"]) {
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-M-d"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
          
           
            _conjunction_code= (NSMutableString* )[_conjunction_code substringToIndex:[_conjunction_code length] - 1];
           
            NSDictionary* dican=@{@"yue_ddate":dayNow,@"yue_t":_conjunction_code,@"carid":_driTeaListInfo.carcode,@"yue_type":type,@"yue_today":currentDateStr,@"teacher":_driTeaListInfo.name,@"tearcharID":_driTeaListInfo.code};

            [JWgetappointment saveappointment:dican andCallback:^(id obj) {
                if ([obj[@"body"][@"result"] isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"预约成功"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"yuyuechenggong" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"预约失败"];
                }
            }];
            
        }
        else
        {
            [MBProgressHUD hideHUD];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:obj[@"body"][@"result"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.frame = CGRectMake(50, 200, 200, 50);
            [alertView show];
            
            
        }
        
    }];
        
    }
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约确认";

    
    _typeCode=[_driTeaListInfo.type componentsSeparatedByString:@","];
    _typeName=[_driTeaListInfo.type_name componentsSeparatedByString:@","];
    _conjunction=[NSMutableArray array];
    _conjunction_time=[NSMutableString string];
    _conjunction_code=[NSMutableString string];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Do any additional setup after loading the view.
    

 
    //获取联动时间

    [JiaxiaotongAPI requestDynamicPeriodListByDynamicPeriodList:_shiduan view:self.view andCallback:^(id obj) {
      
        DynamicPeriodList* dyp=obj;
        if ([dyp.stateinfo isEqualToString:@"有数据"])
        {
          _period=dyp.dynPeriodListContents;//联动时间
            for (PeriodListContent* pers in _period) {
              
                [_conjunction_time appendString:[NSString stringWithFormat:@"%@\n                                ",pers.period]];//取得联动时间
                [_conjunction_code appendString:[NSString stringWithFormat:@"%@,",pers.code]];
            }
            
        }
        
        else//无联动时间
        {
            _conjunction_time.string=[NSString stringWithFormat:@"%@                            ",_shiduan];
            _conjunction_code.string=[NSString stringWithFormat:@"%@,",_periodCode];
        }
        
    
               //时间
        _time.numberOfLines=0;
        _time.textColor=[UIColor colorWithRed:76.f/255.f green:185.f/255.f blue:245.f/255.f alpha:1];
 
        NSMutableAttributedString* astring4 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预约时段                  %@",_conjunction_time]];
   
        
        //添加字体颜色
        [astring4 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor blackColor]
                         range:NSMakeRange(0, 4)];
        
        _time.attributedText=astring4;
        
        
        //姓名
         NSMutableAttributedString* astring =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"教练姓名                  %@",_driTeaListInfo.name]];
        NSString* string =astring.string;
        NSRange range = [string rangeOfString:[NSString stringWithFormat:@"%@",_driTeaListInfo.name]];//匹配得到的下标
      

        //添加字体颜色
        [astring addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:76.f/255.f green:185.f/255.f blue:245.f/255.f alpha:1]
                            range:range];
        _name.attributedText=astring;
        
        
        
        //培训类型
        if (_typeCode.count>1) {
          
            [_type setTitle:@"点击选择科目" forState:UIControlStateNormal];
            

        }
        else
        {
            [_type setTitle:_typeName[0] forState:UIControlStateNormal];
            
            _selectType=_typeCode[0];
        }
        _type.titleLabel.numberOfLines=0;
        
        //日期
        
        _day.textColor=[UIColor colorWithRed:76.f/255.f green:185.f/255.f blue:245.f/255.f alpha:1];

        NSArray *array2 = [_nowtime componentsSeparatedByString:@" "]; //从字符" "中分隔成2个元素的数组
        _thisday=array2[0];

        NSMutableAttributedString* astring3 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"上车日期                  %@",array2[0]]];
     
//        添加字体颜色
        [astring3 addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]
                        range:NSMakeRange(0, 4)];

        _day.attributedText=astring3;
        
        
        for (id obj in self.view.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel* label=obj;
                
                if (self.view.frame.size.width<=320) {
                    label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.3];
                }
                else
                {
                    label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.4];
                }
            }
            if ([obj isKindOfClass:[UIButton class]]) {
                 UIButton* button=obj;
                if (![button.titleLabel.text isEqualToString:@"提交"]) {
                    if (self.view.frame.size.width<=320) {
                        button.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:button.frame.size.height*0.3];
                    }
                    else
                    {
                        button.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:button.frame.size.height*0.4];
                    }
                }
                
            }
        }
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


@end
