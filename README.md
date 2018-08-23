# MyIOSDemo
IOS控件、组件Demo
1.Animations
常用动画，正在收集中～

![image](https://github.com/klbest1/MyIOSDemo/blob/master/Images/anim.gif)

2.BadgeView
数量标记，爆炸动画，使用方便。已在实际项目中使用。
使用实例：
//
   let config = BageConfig()
        config.backGroundColor = UIColor.orange
        config.txtFront = UIFont.systemFont(ofSize: 10)
        config.txtColor = UIColor.white
        badgeView.frame = CGRect(x: 150, y: 300, width: 150, height: 150)
        badgeView.setBadgeNumber(num: "28",config: config)
        badgeView.finishBolock = {
            (finish:Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.badgeView.setBadgeNumber(num: "310+",config:config)
            })
        }
        self.view.addSubview(badgeView)

3.ImageSwiper
模仿陌陌图片切换

4.YKCharts
自定义折线图，已在实际项目中使用。
使用：
//y轴
    YKUIConfig *config = [YKUIConfig new];
    config.yDescFront = [UIFont fontWithName:@"PingFang-SC-Medium" size:10.0f];
    config.yDescColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    config.ylineColor =  [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.3f];
    
    //x轴
    config.xDescFront = [UIFont fontWithName:@"PingFang-SC-Medium" size:10.0f];
    config.xDescColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    //线
    config.lineWidth = 2;
    config.lineColor = [UIColor orangeColor];
    config.circleWidth = 3;
    
    YKLineDataObject *dataObject = [YKLineDataObject new];
    dataObject.ySuffix = @"K";
    dataObject.xDescriptionDataSource = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周七"];
    dataObject.showNumbers = @[@(1000.2),@(-100.2),@(2000.23),@(600.62),@(700.82),@(800.2),@(100.72)];
    [_chartView setupDataSource:dataObject withUIConfgi:config];
    
    5.YKPhotoMediaBroswer
    仿微信朋友圈图片视频浏览，图片来源网络，本地，相册。已在实际项目中使用。
    
    6.ZoomAndCropperImage
    图片裁剪，可用于头像
    
