//
//  LightVCViewController.m
//  JXT
//
//  Created by 1039soft on 15/9/24.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "LightVC.h"
#import "VoiceCollectionCell.h"
#import "const.h"
#import <AVFoundation/AVFoundation.h>
#import "LightDetailCell.h"
#import "NSString+Extension.h"

@interface LightVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) UIButton* lightButton,* voiceButton;//navigationitem中间button

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scroll_w;//scroview宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_w;
//第一个视图的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_gap;
//第二个视图距离参考点距离
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(assign,nonatomic) CGFloat selfW, selfH;//屏幕宽高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LigthtCollection_H;//第一个collection的高
@property (weak, nonatomic) IBOutlet UITableView *lightTable;//灯光下面的tableview
@property(strong,nonatomic) LightDetailCell* lightTableCell ;
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollection;//灯光界面上半部分
@property (weak, nonatomic) IBOutlet UICollectionView *secondCollection;

@property(nonatomic,strong)AVSpeechSynthesizer* player;//播放声音

@property(strong,nonatomic) NSArray* DetailData;//灯光table的详细信息数据

@property(strong,nonatomic) NSString*  thisImageName,* thisImageName2;//记录当前按钮图片
@property(strong,nonatomic) NSString* thisButtonName,* thisButtonName2;//记录当前选中的按钮
@property(strong,nonatomic) dispatch_queue_t queue ;
@property(strong,nonatomic) dispatch_source_t timer;


@end

@implementation LightVC
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    CGFloat w = self.view.frame.size.width;
    _scroll_w.constant=w*2;
    _left_w.constant=w;
    _right_gap.constant=w;
    _LigthtCollection_H.constant=w/2;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //初始化
    
    _selfW=self.view.frame.size.width;
    _selfH=self.view.frame.size.height;
    _player=[[AVSpeechSynthesizer alloc]init];

    _DetailData=@[@"详解：左手放在操纵杆顶部，往前拧到第一档打开灯光总开关，然后拧入第二档打开前照灯",
                  @"详解：往驾驶员方向拨动控制杆使之复位",
                  @"详解：往车头方向波动控制杆打开远光灯",
                  @"详解：往驾驶员方向拨动控制杆使之复位",
                  @"详解：开启示宽灯和警示灯往后拧一下灯组开关，关闭大灯开启示宽灯，按压警示灯按钮开启警示灯",
                  @"详解：将灯组开关往后拧一档，将雾灯开关往前拧两档，按压警示灯按钮",
                  @"详解：往驾驶员方向拨一下操纵杆，松开操纵杆使其复位，再往驾驶员方向拨一下操纵杆，松开操纵杆使其复位",
                  @"详解：往驾驶员方向拨一下操纵杆，松开操纵杆使其复位，再往驾驶员方向拨一下操纵杆，松开操纵杆使其复位",
                  @"详解：往驾驶员方向拨一下操纵杆，松开操纵杆使其复位，再往驾驶员方向拨一下操纵杆，松开操纵杆使其复位",
                  @"详解：向下按压操纵杆，往驾驶员方向拨一下操纵杆，松开操纵杆使其复位，再往驾驶员方向拨一下操纵杆，松开操纵杆使其复位",
                  @"详解：将所有操纵杆复位，用力按压警示灯按钮然后松开使其复位"];
  
    if ([[UIDevice currentDevice]systemVersion].floatValue>8.0) {
        _lightTable.layoutMargins=UIEdgeInsetsZero;
        _lightTable.rowHeight = UITableViewAutomaticDimension;
        _lightTable.estimatedRowHeight = 300;
    }
   //创建navigationitem上面两个按钮
   //创建盛放view
    CGFloat top_H = self.navigationController.navigationBar.frame.size.height;
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.navigationController.navigationBar.frame.size.width,top_H)];
    CGFloat gap = 0;
    if (self.view.frame.size.width>320) {
        gap = 35;
    }
    
    //创建灯光button
     _lightButton = [[UIButton alloc]initWithFrame:CGRectMake(gap, 0,80, top_H)];
    _lightButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [_lightButton setTitle:@"灯光操作" forState:UIControlStateNormal];
    _lightButton.alpha=0.5;
    [_lightButton addTarget:self action:@selector(light:) forControlEvents:UIControlEventTouchUpInside];
    //创建语音button
   _voiceButton = [[UIButton alloc]initWithFrame:CGRectMake(gap+5+80 , 0, 80, top_H)];
    [_voiceButton setTitle:@"语音模拟" forState:UIControlStateNormal];
    _voiceButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    _voiceButton.alpha=0.5;
    [_voiceButton addTarget:self action:@selector(voice:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:_lightButton];
    [topView addSubview:_voiceButton];

    self.navigationItem.titleView=topView;
   [self light:_lightButton];
   //接收按钮通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openLight:) name:OpenLightNotification object:nil];//打开灯光详细
}
#pragma mark - navigationitem 中间按钮
-(void)light:(UIButton* )sender//灯光
{
    sender.alpha=1;
    sender.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    _voiceButton.alpha=0.5;
    _voiceButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    [_scroll scrollRectToVisible:CGRectMake(0, -110, _selfW, _selfH) animated:YES];
}
-(void)voice:(UIButton* )sender//声音
{
    sender.alpha=1;
    sender.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    _lightButton.alpha=0.5;
    _lightButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [_scroll scrollRectToVisible:CGRectMake(_selfW, -110, _selfW, _selfH) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scrollview 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView//减速结束调用
{
    // 不可以用self.scrollView.contentOffset.x/pageWidth直接计算
    CGFloat pageWidth = sView.frame.size.width;
    int page = floor((sView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
  
    if (page==0) {
         [self light:_lightButton];
       
    }
    if (page==1) {
        [self voice:_voiceButton];
       
    }
    
}


////这个方法效果不好
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//   CGFloat Offset = scrollView.contentOffset.x / _selfW;
//    if (Offset == 0) {
//        [self light:_lightButton];
//    }
//    if (Offset == 1) {
//        [self voice:_voiceButton];
//    }
// 
//}
#pragma mark - collection 代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag==1)//声音
    {
        return 19;
    }
    else//灯光
    {
        return 8;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==1)//声音collection
    {
    VoiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
        NSNumber* tempNu = [[NSNumber alloc]initWithInteger:indexPath.item];
        cell.layer.borderColor=[UIColor colorWithWhite:0.9 alpha:1].CGColor;
        cell.layer.borderWidth=0.3;
        
        [cell VoiceSetButtonWithCellNum:tempNu];
        return cell;
    }
   else//灯光collection
   {
       VoiceCollectionCell *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
       NSNumber* tempNu = [[NSNumber alloc]initWithInteger:indexPath.item];
       cell2.layer.borderColor=[UIColor colorWithWhite:0.9 alpha:1].CGColor;
       cell2.layer.borderWidth=0.3;
      
       [cell2 setButtonWithCellNum:tempNu];
       return cell2;
   }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return  CGSizeMake(_selfW/4, _selfW/4);
}

#pragma  mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#warning 替换成动态
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID=@"mycell";
    //从重用对象池中找不用的cell对象
   _lightTableCell =[tableView dequeueReusableCellWithIdentifier:cellID];
    //未找到创建
    if (_lightTableCell==nil) {
        _lightTableCell=[[LightDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([[UIDevice currentDevice]systemVersion].floatValue>8.0) {
        _lightTableCell.layoutMargins=UIEdgeInsetsZero;
    }
    [_lightTableCell setDetailCellWithIndexPathRow:indexPath.row andData:_DetailData];
    return _lightTableCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID=@"mycell";
    //从重用对象池中找不用的cell对象
    _lightTableCell=[tableView dequeueReusableCellWithIdentifier:cellID];
   
      return _lightTableCell.detail.frame.origin.y+[self textSize:_DetailData[indexPath.row]].height+100;
    
    
   
}
#pragma mark - 通知
-(void)openLight:(NSNotification* )sender
{
    NSString* str =sender.object;
    NSString* ButtonTitle = sender.object;
    if([str hasPrefix:@"灯光"])//灯光
    {
    _lightTable.hidden=NO;
   
       
    }
    [self playMusicWithButtonTitle:ButtonTitle imageName:sender.userInfo[@"imageName"]];

}
#pragma mark - 声音
//播放声音
-(void)play:(NSString*)text
{
    if(![text isEqualToString:NULL])
    {
        
        AVSpeechUtterance* u=[[AVSpeechUtterance alloc]initWithString:text];//设置要朗读的字符串
        u.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
        u.volume=1;  //设置音量（0.0~1.0）默认为1.0
        u.rate=0.5;  //设置语速
        u.pitchMultiplier=1;  //设置语调
        [_player speakUtterance:u];
    }
}
//停止
-(void)playStop
{
    [_player stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer=nil;
    }
    

}
-(void)playMusicWithButtonTitle:(NSString* )buttonTitle imageName:(NSString* )imageName
{
 
    if (_thisImageName==nil) {
        _thisImageName=imageName;
    }
    if (_thisImageName2==nil) {
        _thisImageName2=imageName;
    }
    if ([buttonTitle hasPrefix:@"灯光"])
    {
        for (id obj in _firstCollection.subviews) {
            if ([obj isKindOfClass:[VoiceCollectionCell class]]) {
                VoiceCollectionCell* voiceCell = obj;
                for (id obj2 in voiceCell.subviews) {
                    if ([obj2 isKindOfClass:[UIView class]]) {
                        UIView* v2 = obj2;
                        for (id obj3 in v2.subviews) {
                            
                            if ([obj3 isKindOfClass:[ExamButton class]]) {
                                ExamButton* ebutton = obj3;
                                if (![ebutton.titleLabel.text isEqualToString:buttonTitle])//设置其他按钮
                                {

                                    [ebutton setImage:[UIImage imageNamed:@"灯光"] forState:UIControlStateNormal];
                                   
                                  
                                }
                                else//当前选中按钮
                                {
                                    if ([_thisButtonName isEqualToString:buttonTitle])//继续点击当前按钮
                                    {
                                        if ([_thisImageName isEqualToString:@"播放声音"])//关闭
                                        {
                                            [ebutton setImage:[UIImage imageNamed:@"灯光"] forState:UIControlStateNormal];
                                            _thisImageName=@"灯光";
                                            [self playStop];
                                        }
                                        else//开启
                                        {
                                             [ebutton setImage:[UIImage imageNamed:@"播放声音"] forState:UIControlStateNormal];
                                            _thisImageName=@"播放声音";
                                            [self play:LightTitle];
                                          
                                            NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
                                            [_lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                            [self play:LightVoice1];
                                            [self OpenTimeWithButtonName:buttonTitle];



                                            
                                        }
                                    }
                                    else//点击了别的按钮
                                    {
                                        _thisButtonName=buttonTitle;
                                        if ([imageName isEqualToString:@"播放声音"])//开启
                                        {
                                            [ebutton setImage:[UIImage imageNamed:@"播放声音"] forState:UIControlStateNormal];
                                            _thisImageName=@"播放声音";
                                            [self play:LightTitle];
                                            NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
                                            [_lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                            [self play:LightVoice1];
                                            [self OpenTimeWithButtonName:buttonTitle];

                                        }
                                        else//关闭
                                        {
                                            [ebutton setImage:[UIImage imageNamed:@"灯光"] forState:UIControlStateNormal];
                                            _thisImageName=@"灯光";
                                            [self playStop];
                                        }

                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    else//第二个collection
    {
        for (id obj in _secondCollection.subviews) {
            if ([obj isKindOfClass:[VoiceCollectionCell class]]) {
                VoiceCollectionCell* voiceCell = obj;
                for (id obj2 in voiceCell.subviews) {
                    if ([obj2 isKindOfClass:[UIView class]]) {
                        UIView* v2 = obj2;
                        for (id obj3 in v2.subviews) {
                            
                            if ([obj3 isKindOfClass:[ExamButton class]]) {
                                ExamButton* ebutton = obj3;
                                if (![ebutton.titleLabel.text isEqualToString:buttonTitle]) {

                                    [ebutton setImage:[UIImage imageNamed:ebutton.titleLabel.text] forState:UIControlStateNormal];
                                    
                                }
                                else//当前选中按钮
                                {
                                    if ([_thisButtonName2 isEqualToString:buttonTitle])//继续点击当前按钮
                                    {
                                        if ([_thisImageName2 isEqualToString:@"播放声音"])//关闭
                                        {
                                            [ebutton setImage:[UIImage imageNamed:ebutton.titleLabel.text] forState:UIControlStateNormal];

                                            _thisImageName2=ebutton.titleLabel.text;
                                            [self playStop];
                                        }
                                        else//开启
                                        {
                                            [ebutton setImage:[UIImage imageNamed:@"播放声音"] forState:UIControlStateNormal];
                                            _thisImageName2=@"播放声音";
                                           
                                             NSInteger temp =  [self began:_thisButtonName2];
                                            [self OpenTime3:temp button:ebutton];
                                            
                                        }
                                    }
                                    else//点击了别的按钮
                                    {
                                        _thisButtonName2=buttonTitle;
                                        if ([imageName isEqualToString:@"播放声音"])//开启
                                        {
                                            [ebutton setImage:[UIImage imageNamed:@"播放声音"] forState:UIControlStateNormal];
                                            _thisImageName2=@"播放声音";
                                          NSInteger temp = [self began:_thisButtonName2];
                                             [self OpenTime3:temp button:ebutton];
                                          
                                            
                                        }
                                        else//关闭
                                        {
                                            [ebutton setImage:[UIImage imageNamed:ebutton.titleLabel.text] forState:UIControlStateNormal];

                                            _thisImageName2=ebutton.titleLabel.text;
                                            [self playStop];
                                        }
                                        
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
}

-(CGSize)textSize:(NSString*)text
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)];
    return size;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self playStop];
}
#pragma mark 计时器
-(void)OpenTimeWithButtonName:(NSString* )TheName
{
    __block NSInteger timeout=0; //倒计时时间
    __block LightVC* thisSelf = self;
     _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //没秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (timeout==19) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice2];
                
            }
            if (timeout==26) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:2 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice3];
            }
            if (timeout==26+7) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:3 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice4];
            }
            if (timeout==26+14) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:4 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice5];
                
                
            }
            if (timeout==26+14+7) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:5 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice5_2];
            }
            if (timeout==26+28) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:6 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice5_3];
            }
            if (timeout==26+28+7) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:7 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice5_4];
            }
            if (timeout==26+28+14) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:8 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice5_5];
            }
            if (timeout==26+28+28) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:9 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice5_6];
            }
            if (timeout==26+28+28+7) {
                NSIndexPath* index = [NSIndexPath indexPathForRow:10 inSection:0];
                [thisSelf.lightTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [thisSelf play:LightVoice6];
                [thisSelf playStop];
            }
          
           
          
        });

        timeout++;
        
    });
    dispatch_resume(_timer);
}
//计时器2
-(void)OpenTime2WichName:(NSString* )name
{
    __block NSInteger timeout=0; //倒计时时间
    __block LightVC* thisSelf = self;
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //没秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout==10)
        {
            if ([name isEqualToString:Sound7]) {
                [thisSelf play:Sound7_2];
            }
            if ([name isEqualToString:Sound14]) {
                [thisSelf play:Sound14_2];
            }
            if ([name isEqualToString:Sound16]) {
                [thisSelf play:Sound16_2];
            }
            [thisSelf playStop];
        }
               timeout++;
        
    });
    dispatch_resume(_timer);
}
//计时器3
-(void)OpenTime3:(NSInteger)num button:(ExamButton* )button
{
    __block NSInteger timeout=0; //倒计时时间
    __block LightVC* thisSelf = self;
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //没秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
         
            if (timeout==num) {
                [button setImage:[UIImage imageNamed:@"灯光"] forState:UIControlStateNormal];
                _thisImageName2=@"灯光";
                [thisSelf playStop];
            }

        });
    timeout++;
        
    });
    dispatch_resume(_timer);
}
-(NSInteger)began:(NSString* )buttonName
{
    NSInteger num = 3;
    [self playStop];
    if ([buttonName isEqualToString:@"考前准备"]) {
        [self play:Sound1];
        num=18;
    }
    if ([buttonName isEqualToString:@"起步"]) {
        [self play:Sound2];
        
    }
    if ([buttonName isEqualToString:@"路口直行"]) {
        [self play:Sound3];
    }
    if ([buttonName isEqualToString:@"变更车道"]) {
        [self play:Sound4];
    }
    if ([buttonName isEqualToString:@"公共汽车站"]) {
        [self play:Sound5];
    }
    if ([buttonName isEqualToString:@"学校"]) {
        [self play:Sound6];
    }
    if ([buttonName isEqualToString:@"直线行驶"]) {
        [self play:Sound7];
        [self OpenTime2WichName:Sound7];
        num=13;
        
    }
    if ([buttonName isEqualToString:@"左转"]) {
        [self play:Sound8];
    }
    if ([buttonName isEqualToString:@"右转"]) {
        [self play:Sound9];
    }
    if ([buttonName isEqualToString:@"加减档"]) {
        [self play:Sound10];
    }
    if ([buttonName isEqualToString:@"会车"]) {
        [self play:Sound11];
    }
    if ([buttonName isEqualToString:@"超车"]) {
        [self play:Sound12];
    }
    if ([buttonName isEqualToString:@"减速"]) {
        [self play:Sound13];
    }
    if ([buttonName isEqualToString:@"限速"]) {
        [self play:Sound14];
        [self OpenTime2WichName:Sound14];
        num=13;
    }
    if ([buttonName isEqualToString:@"人行横道"]) {
        [self play:Sound15];
    }
    if ([buttonName isEqualToString:@"有行人通过"]) {
        [self play:Sound16];
        [self OpenTime2WichName:Sound16];
        num=13;
    }
    if ([buttonName isEqualToString:@"隧道"]) {
        [self play:Sound17];
    }
    if ([buttonName isEqualToString:@"掉头"]) {
        [self play:Sound18];
    }
    if ([buttonName isEqualToString:@"靠边停车"]) {
        [self play:Sound19];
    }
    return num;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
