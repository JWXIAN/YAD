//
//  JWEvaluateVIew.m
//  JXT
//
//  Created by JWX on 15/7/6.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWEvaluateVIew.h"
#import "MBProgressHUD+MJ.h"
#import "JsonPaser.h"
#import "JWTrainCell.h"
#import "AFNetworking.h"
#import "PrefixHeader.pch"
#import "JWEvaluateModel.h"
#import "AMRatingControl.h"

@interface JWEvaluateVIew ()
@property (weak, nonatomic) IBOutlet UIView *starView;
/**选中星星数量*/
@property (nonatomic, strong)NSString *seldStarNum;

@property (nonatomic, strong)AMRatingControl *starOne;
@property (nonatomic, strong)AMRatingControl *starTwo;
@property (nonatomic, strong)AMRatingControl *starThree;
@property (nonatomic, strong)AMRatingControl *starFour;
@end

@implementation JWEvaluateVIew

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lbName.text = self.name;
    self.lbKM.text = self.km;
    self.lbDate.text = self.date;
    self.lbHour.text = self.hour;
    [self star];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**五星评价*/
- (void)star
{
    //1.创建star
    
    self.starOne = [[AMRatingControl alloc] initWithLocation:CGPointMake(self.lbOne.frame.origin.x, self.lbOne.frame.origin.y) emptyColor:JWColor(234, 141, 46) solidColor:JWColor(234, 141, 46) andMaxRating:5];
    self.starTwo = [[AMRatingControl alloc] initWithLocation:CGPointMake(self.lbTwo.frame.origin.x, self.lbTwo.frame.origin.y) emptyColor:JWColor(234, 141, 46) solidColor:JWColor(234, 141, 46) andMaxRating:5];
    self.starThree = [[AMRatingControl alloc] initWithLocation:CGPointMake(self.lbThree.frame.origin.x, self.lbThree.frame.origin.y) emptyColor:JWColor(234, 141, 46) solidColor:JWColor(234, 141, 46) andMaxRating:5];
    self.starFour = [[AMRatingControl alloc] initWithLocation:CGPointMake(self.lbFour.frame.origin.x, self.lbFour.frame.origin.y) emptyColor:JWColor(234, 141, 46) solidColor:JWColor(234, 141, 46) andMaxRating:5];
    self.starOne.starFontSize = 23;
    self.starTwo.starFontSize = 23;
    self.starThree.starFontSize = 23;
    self.starFour.starFontSize = 23;
    /**默认星星*/
    [self.starOne setRating:5];
    /**星星间距*/
    //    [self.starOne setStarSpacing:10];
    /**默认星星*/
    [self.starTwo setRating:5];
    /**星星间距*/
    //    [self.starTwo setStarSpacing:10];
    /**默认星星*/
    [self.starThree setRating:5];
    /**星星间距*/
    //    [self.starThree setStarSpacing:10];
    /**默认星星*/
    [self.starFour setRating:5];
    /**星星间距*/
    //    [self.starFour setStarSpacing:10];
//    /**正在点击*/
//    starOne.editingChangedBlock = ^(NSUInteger rating)
//    {
//        JWLog(@"%ld", rating);
//    };
    /**点击结束*/
    self.starOne.editingDidEndBlock = ^(NSUInteger starOne)
    {
        JWLog(@"%ld", starOne);
    };
    /**点击结束*/
    self.starTwo.editingDidEndBlock = ^(NSUInteger starTwo)
    {
        JWLog(@"%ld", starTwo);
    };
    /**点击结束*/
    self.starThree.editingDidEndBlock = ^(NSUInteger starThree)
    {
        JWLog(@"%ld", starThree);
    };
    /**点击结束*/
    self.starFour.editingDidEndBlock = ^(NSUInteger starFour)
    {
        JWLog(@"%ld", starFour);
    };
    UIImage *star;
    star = [UIImage imageNamed:@"star.png"];
    [self.starView addSubview:self.starOne];
    [self.starView addSubview:self.starTwo];
    [self.starView addSubview:self.starThree];
    [self.starView addSubview:self.starFour];
}
//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)btnPL:(id)sender {

    if (self.PJText.text.length == 0) {
        self.PJText.text = @"用户未填写评价内容";
    }
    [MBProgressHUD showMessage:@"感谢评论"];
    self.seldStarNum = [NSString stringWithFormat:@"%ld%ld%ld%ld", self.starOne.rating, self.starTwo.rating, self.starThree.rating, self.starFour.rating];
    JWLog(@"%@  %@", self.seldStarNum, self.PJText.text);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    NSString *stuid = [ud objectForKey:@"stuID"];
    NSString *scid=[ud objectForKey:@"drivecode"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=insertPingjia&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><ordercode>%@</ordercode><score>%@</score><pingjiacontent>%@</pingjiacontent><pingjiatype>手机</pingjiatype><methodName>insertPingjia</methodName></MAP_TO_XML>",scid, self.pxid, self.seldStarNum, self.PJText.text];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
   

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWLog(@"%@",dic);
        JWEvaluateModel *ty = [JsonPaser jsonPJ:dic];
        if ([ty.result isEqual:@"10001"]||[ty.result isEqual:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"评论失败"];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"评论成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];

}

@end
