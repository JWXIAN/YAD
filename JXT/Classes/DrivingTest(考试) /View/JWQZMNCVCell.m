//
//  JWQZMNCVCell.m
//  JXT
//
//  Created by JWX on 15/8/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWQZMNCVCell.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "JWQZMNCell.h"
#import "exam.h"
#import "MBProgressHUD+MJ.h"
#import "JWQZMNVC.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface JWQZMNCVCell()
/**控制Cell约束*/
@property (nonatomic, strong) UITableViewCell *prototypeCell;
/**题目类型*/
@property (nonatomic, strong) NSString *dtType;
/**答题数组*/
@property (nonatomic, strong) NSArray *dtArr;

/**错题数组*/
@property (nonatomic, strong) NSMutableArray *ctCountArr;
/**对题数组*/
@property (nonatomic, strong) NSMutableArray *dtCountArr;
/**点击Cell统计数组*/
@property (nonatomic, strong) NSMutableArray *selectCountArr;
/**判断数组*/
@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, strong) NSArray *arrText;
/**是否收藏*/
@property (nonatomic, strong) NSString *strSC;

/**解决cell重用问题*/
@property (nonatomic, strong) NSMutableArray *cellData;
@property (nonatomic, strong) NSIndexPath *cellRowIndex;
@property (nonatomic, assign) int cellNum;
@property (nonatomic, strong) NSString *strDTType;
@property (nonatomic, strong) NSString *dtPD;
@property (nonatomic, strong) UIView *headView;

/**多选题*/
@property (nonatomic, strong) UIButton *btnCell;
@property (nonatomic, assign) int dxCellCount;
@end
@implementation JWQZMNCVCell
//
//
//- (id)initWithCoder:(NSCoder*)coder
//{
//    if (self =[super initWithCoder:coder]) {
//        
//        
//    }
//    
//    return self;
//    
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dtTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.mj_w, self.contentView.mj_h)];
        [self.contentView addSubview:_dtTV];
        
        //初始化答题数组
        _selectCountArr = [NSMutableArray array];
        _ctCountArr = [NSMutableArray array];
        _dtCountArr = [NSMutableArray array];
        _cellData = [NSMutableArray array];
        
        _dtTV.delegate = self;
        _dtTV.dataSource = self;
        //判断题数组
        _arrTitle = @[@"A", @"B"];
        _arrText = @[@"正确", @"错误"];
        
        self.dtTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dtTV.backgroundColor = JWColor(245, 245, 245);
        //注册cell
        UINib *cellNib = [UINib nibWithNibName:@"JWQZMNCell" bundle:nil];
        [self.dtTV registerNib:cellNib forCellReuseIdentifier:@"JWQZMNCell"];
        self.prototypeCell  = [self.dtTV dequeueReusableCellWithIdentifier:@"JWQZMNCell"];
    }
    return self;
}

- (void)awakeFromNib{
    
}

#pragma mark - CV传模型，Collection行数
- (void)setTVCell:(exam *)exam cellNum:(NSIndexPath *)cellNum{
    
    _cellRowIndex = cellNum;
    _exam = exam;
    NSString *type = _exam.questionType;
    if([type isEqualToString:@"单选题"]){
        _cellNum = 4;
        _dtTV.tableFooterView.hidden = YES;
    }else if ([type isEqualToString:@"判断题"]){
        _cellNum = 2;
        _dtTV.tableFooterView.hidden = YES;
    }else{
        _cellNum = 4;
    }
    [self.dtTV reloadData];
    JWQZMNCell *cell;
    BOOL a =false;
        for(NSString *key in _dtdic.allKeys){
            if([key isEqualToString:[NSString stringWithFormat:@"%ld", (long)cellNum.row]]){
                a = true;
            }
        }
        
        if(a == true){
            
        for(NSString *key in _dtdic.allKeys){
            NSMutableDictionary *dic = [_dtdic valueForKey:key];
            NSArray *keys = dic.allKeys;
            
        if([key isEqualToString:[NSString stringWithFormat:@"%ld", (long)cellNum.row]]){

                for(int i=0; i<keys.count; i++){
                    NSIndexPath *index = [NSIndexPath indexPathForRow:[[keys objectAtIndex:i] intValue] inSection:0];
                    cell = (JWQZMNCell *)[_dtTV cellForRowAtIndexPath:index];
                    cell.userInteractionEnabled = false;
                    cell.lblText.textColor = [dic valueForKey:[keys objectAtIndex:i]];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.lblText.backgroundColor = [UIColor whiteColor];
                    cell.lblTitle.backgroundColor = [UIColor whiteColor];
                }
            }

        }
        }else{
            for(int i=0; i<_cellNum; i++){
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                JWQZMNCell *cell = (JWQZMNCell *)[_dtTV cellForRowAtIndexPath:index];
                cell.lblText.textColor = [UIColor blackColor];
                cell.imgaeDC.hidden = YES;
                cell.userInteractionEnabled = true;
                cell.backgroundColor = [UIColor whiteColor];
                cell.lblText.backgroundColor = [UIColor whiteColor];
                cell.lblTitle.backgroundColor = [UIColor whiteColor];
            }
    }
    //顶部View
    [self loadHeadView:_exam.questionType lblText:_exam.questionBody imageT:_exam.questionPicture];
}

/**答题顶部视图*/
- (void)loadHeadView:(NSString *)imageType lblText:(NSString *)lblT imageT:(NSString *)imageT{
    // 1. 题类型
    UIImageView *imageTypeView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 40, 20)];
    if([imageType isEqualToString:@"单选题"]){
        imageTypeView.image = [UIImage imageNamed:@"dx"];
    }else if([imageType isEqualToString:@"判断题"]){
        imageTypeView.image = [UIImage imageNamed:@"pd"];
    }else{
        imageTypeView.image = [UIImage imageNamed:@"duox"];
    }
    
    // 2. 题目
    UILabel *lblText = [[UILabel alloc] init];
    //    lblText.backgroundColor = JWRandomColor;
    //设置自动行数与字符换行
    lblText.numberOfLines = 0;
    lblText.lineBreakMode = NSLineBreakByTruncatingTail;
    //设置字体
    UIFont *ft = [UIFont systemFontOfSize:16];
    lblText.font = ft;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:ft, NSFontAttributeName,nil];
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize =[lblT boundingRectWithSize:CGSizeMake(self.contentView.mj_w - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    lblText.text =lblT;
    lblText.frame = CGRectMake(70, 20, labelsize.width, labelsize.height);
    
    // 3. 题目附加图片
    UIImageView *imageFJView = [[UIImageView alloc] init];
    if([imageT isEqualToString:@"&nbsp;"]){
        imageFJView.frame = CGRectMake(20, CGRectGetMaxY(lblText.frame)+10, self.contentView.mj_w - 40, 0);
        imageFJView.hidden = YES;
    }else{
        
        //        imageFJView.backgroundColor = [UIColor redColor];
        imageFJView.frame = CGRectMake(20, CGRectGetMaxY(lblText.frame)+10, self.contentView.mj_w - 40, 100);
        if ([imageT hasPrefix:@"http"]) {
           [imageFJView sd_setImageWithURL:[NSURL URLWithString:imageT]];
        }
        else
        {
            imageFJView.image=[UIImage imageNamed:imageT];
        }
        
//
        //        imageFJView.image = [UIImage imageNamed:imageT];
        //自适应图片宽高比例
        imageFJView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    // 4. 添加下划线
    UIView *igView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageFJView.frame)+10, self.contentView.mj_w, 1)];
    igView.backgroundColor = JWColor(244, 244, 244);
    
    // 5. 主视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.mj_w, CGRectGetMaxY(imageFJView.frame)+11)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    NSArray *arrView = @[imageTypeView, lblText, imageFJView, igView];
    for(int i =0;i<arrView.count;i++){
        [_headView addSubview:arrView[i]];
    }
    
    self.dtTV.tableHeaderView = _headView;
    [self.dtTV reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWQZMNCell *cell = [JWQZMNCell cellWithTableView:tableView];
    cell.imgaeDC.hidden = YES;
    if([_exam.questionType isEqualToString:@"判断题"]){
        cell.lblTitle.text = [_arrTitle objectAtIndex:indexPath.row];
        cell.lblText.text = [_arrText objectAtIndex:indexPath.row];
    }else{
        switch(indexPath.row){
            case 0:
                cell.lblTitle.text = @"A";
                cell.lblText.text = _exam.answerA;
                break;
            case 1:
                cell.lblTitle.text = @"B";
                cell.lblText.text = _exam.answerB;
                break;
            case 2:
                cell.lblTitle.text = @"C";
                cell.lblText.text = _exam.answerC;
                break;
            case 3:
                cell.lblTitle.text = @"D";
                cell.lblText.text = _exam.answerD;
                break;
        }
        
    }
    if ([_exam.questionType isEqualToString:@"多选题"]) {
        _btnCell = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnCell.frame = CGRectMake(0, 0, _dtTV.mj_w, 44);
        [_btnCell setTitle:@"确定" forState:UIControlStateNormal];
        [_btnCell setTintColor:[UIColor whiteColor]];
        [_btnCell setBackgroundColor:JWColor(210, 210, 210)];
        _btnCell.enabled = false;
        [_btnCell addTarget:self action:@selector(dxBtnCell) forControlEvents:UIControlEventTouchUpInside];
        _dtTV.tableFooterView = _btnCell;
    }
    if(cell.lblText.textColor == [UIColor redColor]){
        cell.imgaeDC.hidden = NO;
        cell.imgaeDC.image = [UIImage imageNamed:@"错"];
    }else if(cell.lblText.textColor == [UIColor greenColor]){
        cell.lblText.textColor = JWColor(86, 181, 34);
        cell.imgaeDC.hidden = NO;
        cell.imgaeDC.image = [UIImage imageNamed:@"对"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWQZMNCell *cell = (JWQZMNCell *)self.prototypeCell;
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.lblText.translatesAutoresizingMaskIntoConstraints = NO;
    cell.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
//点击后判断答案
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_exam.questionType isEqualToString:@"多选题"]){
        JWQZMNCell *dxCell = (JWQZMNCell *)[tableView cellForRowAtIndexPath:indexPath];
        [_selectCountArr addObject:dxCell.lblTitle.text];
        if (dxCell.backgroundColor == [UIColor groupTableViewBackgroundColor]){
            _dxCellCount--;
            dxCell.backgroundColor = [UIColor whiteColor];
            dxCell.lblText.backgroundColor = [UIColor whiteColor];
            dxCell.lblTitle.backgroundColor = [UIColor whiteColor];
        }else{
            _dxCellCount++;
            dxCell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            dxCell.lblText.backgroundColor = [UIColor groupTableViewBackgroundColor];
            dxCell.lblTitle.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }

        if (_dxCellCount > 1) {
            NSLog(@"%d", _dxCellCount);
            [_btnCell setBackgroundColor:JWColor(79, 192, 103)];
            _btnCell.enabled = true;
        }else{
            [_btnCell setBackgroundColor:JWColor(210, 210, 210)];
            _btnCell.enabled = false;
        }
    }else{
        JWQZMNCell *cell = (JWQZMNCell *)[tableView cellForRowAtIndexPath:indexPath];
        /**将行数存入数组*/
        [_selectCountArr addObject:cell.lblTitle.text];
        
        //禁用点击Cell
        //    self.tableView.allowsSelection = NO;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int answer;
        
        if([[ud objectForKey:@"tmZQDA"] rangeOfString:@"1"].location !=NSNotFound){
            answer = 0;
        }else if([[ud objectForKey:@"tmZQDA"] rangeOfString:@"2"].location !=NSNotFound){
            answer = 1;
        }else if([[ud objectForKey:@"tmZQDA"] rangeOfString:@"3"].location !=NSNotFound){
            answer = 2;
        }else{
            answer = 3;
        }
        
        
//        
//        if([[ud objectForKey:@"tmZQDA"] isEqualToString:@"1,"]){
//            answer = 0;
//        }else if([[ud objectForKey:@"tmZQDA"] isEqualToString:@"2,"]){
//            answer = 1;
//        }else if([[ud objectForKey:@"tmZQDA"] isEqualToString:@"3,"]){
//            answer = 2;
//        }else{
//            answer = 3;
//        }
//        
        if(indexPath.row == answer){
            //JWColor(83, 164, 43)
            cell.lblText.textColor = [UIColor greenColor];
            cell.imgaeDC.hidden = NO;
            cell.imgaeDC.image = [UIImage imageNamed:@"对"];
            /**存对题*/
            [_dtCountArr addObject:cell.lblTitle.text];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dtDTvCellCount" object:_dtCountArr];
            //替换上面通知 -- 对题行数
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dtCellRow" object:[NSString stringWithFormat:@"对%ld",(long)_cellRowIndex.row]];
            _exam.answerWere = @"false";
            [exam update:_exam];
        }else{
            cell.lblText.textColor = [UIColor redColor];
            cell.imgaeDC.hidden = NO;
            cell.imgaeDC.image = [UIImage imageNamed:@"错"];
            //查找对题
            NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:answer inSection:0];
            JWQZMNCell *dCell = (JWQZMNCell *)[tableView cellForRowAtIndexPath:cellIndex];
            dCell.lblText.textColor = [UIColor greenColor];
            dCell.imgaeDC.hidden = NO;
            dCell.imgaeDC.image = [UIImage imageNamed:@"对"];
            /**存错题*/
            [_ctCountArr addObject:cell.lblTitle.text];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dtCTvCellCount" object:_ctCountArr];
            //替换上面通知 -- 错题行数
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ctCellRow" object:[NSString stringWithFormat:@"错%ld",(long)_cellRowIndex.row]];
            _exam.answerWere = @"true";
            [exam update:_exam];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        int i =0;
        for(id obj in self.dtTV.visibleCells){
            JWQZMNCell *celll = obj;
            celll.userInteractionEnabled =false;
            [dic setObject:celll.lblText.textColor forKey:[NSString stringWithFormat:@"%d", i]];
            i++;
        }
        
        //    [[NSNotificationCenter defaultCenter] postNotificationName:@"dtDic" object:nil userInfo:dic];
        //    发出答题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dtDic" object:dic];
        //
        //    发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dtTVCellselectRow" object:_selectCountArr];
    }
}
- (void)dxBtnCell{
    //取出正确答案
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *rightAnswer = [ud objectForKey:@"tmZQDA"];
    rightAnswer = [rightAnswer stringByReplacingOccurrencesOfString:@"1" withString:@"0"];
    rightAnswer = [rightAnswer stringByReplacingOccurrencesOfString:@"2" withString:@"1"];
    rightAnswer = [rightAnswer stringByReplacingOccurrencesOfString:@"3" withString:@"2"];
    rightAnswer = [rightAnswer stringByReplacingOccurrencesOfString:@"4" withString:@"3"];
    
    //题号
    NSString *rowC;
    int cellRow=0;
    NSMutableString *cellXH = [NSMutableString string];
    for (id obj in _dtTV.visibleCells) {
        JWQZMNCell *cell = obj;
        if (cell.backgroundColor == [UIColor groupTableViewBackgroundColor]) {
            rowC = [NSString stringWithFormat:@"%d,", cellRow];
            [cellXH appendString:rowC];
        }
        cellRow++;
    }
    //保存处理好的选择的cell序号
    NSString *cellTH = [cellXH substringToIndex:cellXH.length-1];
    
    NSArray *arr = [rightAnswer componentsSeparatedByString:@","];
    if (arr.count>4) {
        arr = [NSArray array];
    }
    
    //回答正确
    if ([rightAnswer rangeOfString:cellTH].location !=NSNotFound) {
        _exam.answerWere = @"false";
        [exam update:_exam];
        for (id obj in arr) {
            NSString *objs = obj;
            NSIndexPath *ip = [NSIndexPath indexPathForRow:objs.integerValue inSection:0];
            JWQZMNCell *dCell = (JWQZMNCell *)[_dtTV cellForRowAtIndexPath:ip];
            dCell.lblText.textColor = [UIColor greenColor];
            dCell.imgaeDC.hidden = NO;
            dCell.imgaeDC.image = [UIImage imageNamed:@"对"];
            /**存对题*/
            [_dtCountArr addObject:dCell.lblTitle.text];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dtDTvCellCount" object:_dtCountArr];
            //替换上面通知 -- 对题行数
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dtCellRow" object:[NSString stringWithFormat:@"对%ld",(long)_cellRowIndex.row]];
        }
    }else{
        _exam.answerWere = @"true";
        [exam update:_exam];
        /**存错题*/
        [_ctCountArr addObject:_exam.answerWere];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dtCTvCellCount" object:_ctCountArr];
        //替换上面通知 -- 错题行数
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ctCellRow" object:[NSString stringWithFormat:@"错%ld",(long)_cellRowIndex.row]];
        
        for (id obj in arr) {
            NSString *objs = obj;
            NSIndexPath *ip = [NSIndexPath indexPathForRow:objs.integerValue inSection:0];
            JWQZMNCell *dCell = (JWQZMNCell *)[_dtTV cellForRowAtIndexPath:ip];
            dCell.lblText.textColor = [UIColor greenColor];
            dCell.imgaeDC.hidden = NO;
            dCell.imgaeDC.image = [UIImage imageNamed:@"对"];
        }
        
        NSArray *th = [cellTH componentsSeparatedByString:@","];
        for (id obj in th) {
            int num = [obj intValue];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:num inSection:0];
            JWQZMNCell *cell = (JWQZMNCell *)[_dtTV cellForRowAtIndexPath:ip];
            if (cell.lblText.textColor != [UIColor greenColor]) {
                cell.lblText.textColor = [UIColor redColor];
                cell.imgaeDC.hidden = NO;
                cell.imgaeDC.image = [UIImage imageNamed:@"错"];
            }
        }
    }
    //保存Cell
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    int i = 0;
    for (id obj in _dtTV.visibleCells) {
        JWQZMNCell *cell = obj;
        cell.userInteractionEnabled =false;
        if (i<4) {
            [dic setObject:cell.lblText.textColor forKey:[NSString stringWithFormat:@"%d", i]];
        }
        i++;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dtDic" object:dic];
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dtTVCellselectRow" object:_selectCountArr];
}

@end
