//
//  JWPerInfoVC.m
//  JXT
//
//  Created by JWX on 15/8/14.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWPerInfoVC.h"
#import "PrefixHeader.pch"
#import "RJBlurAlertView.h"
#import "JWQZMNVC.h"
#import "exam.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+MJExtension.h"

@interface JWPerInfoVC ()
@property (nonatomic, strong)JWQZMNVC *qzmnVC;
//存放题
@property (nonatomic, strong) NSArray *dataArr;
//车型
@property (nonatomic, strong) NSString *strCX;

@end

@implementation JWPerInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnQZMN.layer.cornerRadius=15;
    _btnWZT.layer.cornerRadius=15;
    
    [self cxPD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnSelectQZMN:(id)sender {
    NSString *title;
    if(_lblKSCX.text == nil){
        [MBProgressHUD showError:@"请选择题库"];
    }else{
    if([_lblKSTM_name isEqualToString:@"科目一"]){
        title = @"科目一考试答题后不能修改答案，每做一题，系统自动计算错题数量，如果累计错题数量超过11题时（共100题），系统会自动提交答卷，本次考试不通过。";
    }else{
        title = @"科目四考试答题后不能修改答案，每做一题，系统自动计算错题数量，如果累计错题数量超过11题时（共50题），系统会自动提交答卷，本次考试不通过。";
    }
    RJBlurAlertView *alertView = [[RJBlurAlertView alloc] initWithTitle:@"考试须知" text:title cancelButton:nil];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setCompletionBlock:^(RJBlurAlertView *alert, UIButton *button) {
        if (button == alert.okButton) {
            [self loadData];
        }
    }];
    [alertView show];
    }
}

//车型判断
- (void)cxPD{
    if ([_lblKSCX_name isEqualToString:@"C"]){
        _strCX = @"小车（C1,C2,C3）";
    }
    if ([_lblKSCX_name isEqualToString:@"B"])
    {
        _strCX= @"货车（A2,B2）";
    }
    if ([_lblKSCX_name isEqualToString:@"A"])
    {
        _strCX = @"客车（A1,A3,B1）";
    }
    if ([_lblKSCX_name isEqualToString:@"DEF"])
    {
        _strCX = @"摩托（D,E,F）";
    }
    if ([_lblKSCX_name isEqualToString:@"ZJ"])
    {
        _strCX = @"教练员";
    }
    if ([_lblKSCX_name isEqualToString:@"ZB"])
    {
        _strCX = @"货运";
    }
    if ([_lblKSCX_name isEqualToString:@"ZC"])
    {
        _strCX = @"危险品";
    }
    if ([_lblKSCX_name isEqualToString:@"ZA"])
    {
        _strCX = @"客运";
    }
    if ([_lblKSCX_name isEqualToString:@"ZD"])
    {
        _strCX = @"出租车";
    }

    _lblKSTM.text= [NSString stringWithFormat:@"%@理论考试", _lblKSTM_name];
    _lblKSCX.text= _strCX;
    
    
    /**存模拟考title*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    self.lblKSTM.text =[NSString stringWithFormat:@"%@", [ud objectForKey:@"pageTitle"]];
    //学员头像
    [_imagePerson sd_setImageWithURL:[ud objectForKey:@"per_photo"] placeholderImage:[UIImage imageNamed:@"PersonImage"]];
    _imagePerson.layer.masksToBounds = YES;
    _imagePerson.layer.cornerRadius = _imagePerson.mj_h/2.0;
    //学员姓名
    _lblName.text = [ud objectForKey:@"per_name"];
    
    if([self.lblKSTM.text isEqualToString:@"科目四理论考试"]){
        _lblKSBZ.text = @"50题,30分钟";
        [ud setObject:@"30分钟" forKey:@"lblTime"];
        [ud setObject:@"50题" forKey:@"lblTS"];
    }else{
        [ud setObject:@"45分钟" forKey:@"lblTime"];
        [ud setObject:@"100题" forKey:@"lblTS"];
    }
    [ud setObject:self.lblKSTM.text forKey:@"lblKSKM"];
    //    [ud setObject:self.title forKey:@"DTTitle"];
}

- (void)loadData{
    NSString *info = [NSString stringWithFormat:@"carType like '%%%@%%' and className='%@' ",_lblKSCX_name, _lblKSTM_name];
    _dataArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
    _qzmnVC = [[JWQZMNVC alloc] init];
    _qzmnVC.title = @"全真模拟考试";
    if([_lblKSTM_name isEqualToString:@"科目一"]){
        _qzmnVC.cellCount = 100;
    }else{
        _qzmnVC.cellCount = 50;
    }
    NSMutableArray *arr = [NSMutableArray array];
    //随机添加题
    if(_qzmnVC.cellCount > _dataArr.count){
//        for(int i=0; i < _dataArr.count; i++){
//            [arr addObject:[_dataArr objectAtIndex:i]];
//        }
        _qzmnVC.cellDataArr = _dataArr;
    }else{
        for(int i=0; i < _qzmnVC.cellCount; i++){
            [arr addObject:[_dataArr objectAtIndex:arc4random_uniform(_qzmnVC.cellCount)]];
        }
        _qzmnVC.cellDataArr = arr;
    }
    
    [self.navigationController pushViewController:_qzmnVC animated:YES];
}

- (IBAction)btnXKWZT:(id)sender {
    [self loadData];
}
@end
