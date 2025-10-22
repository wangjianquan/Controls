//
//  PreHelper.m
//  HistoryPlayer
//
//  Created by wjq on 15/8/31.
//  Copyright (c) 2015年 wjq. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "PreHelper.h"

//*尺寸设置*/


static CGRect oldframe;

@interface GlobalState : NSObject
extern NSString *const DATE_FORMAT;
extern NSString *const DATE_FORMAT_;
extern NSString *const DATE_FORMAT_MIN;
extern NSString *const TIME_FORMAT;
extern NSString *const DATE_FORMAT_TAKE_MIN;
//图片类型
extern NSString *const TYPE_IMAGE;
extern NSString *const TYPE_DATA;

@end

@implementation GlobalState
NSString *const DATE_FORMAT = @"yyyy年MM月dd";
NSString *const DATE_FORMAT_ = @"yyyy-MM-dd";
NSString *const DATE_FORMAT_MIN = @"yyyy-MM-dd HH:mm:ss";
NSString *const TIME_FORMAT = @"yyyymmddHHmmssSSSS";
NSString *const DATE_FORMAT_TAKE_MIN = @"yyyy-MM-dd HH:mm";
//图片类型
NSString *const TYPE_IMAGE = @"image";
NSString *const TYPE_DATA = @"data";

@end

@implementation PreHelper

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor*)randomColor{

     UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    return randomColor;

}

#pragma mark -- 随机字符(UUID + time)
+ (NSString *)randomKey{
    /* Get Random UUID */
    NSString *UUIDString;
    CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
    CFStringRef UUIDStringRef = CFUUIDCreateString(NULL, UUIDRef);
    UUIDString = (NSString *)CFBridgingRelease(UUIDStringRef);
    CFRelease(UUIDRef);
    /* Get Time */
    double time = CFAbsoluteTimeGetCurrent();
    /* MD5 With Sale */
    return [NSString stringWithFormat:@"%@%f", UUIDString, time];
}

#pragma mark -- 标签颜色
+ (UIColor *)textColorWithText:(NSString *)typeString{
    NSDictionary * dic = @{
                           @"幸福家庭" : [self colorWithHexString:@"#FF4949" alpha:1.0],
                           @"健康知识" : [self colorWithHexString:@"#78C535" alpha:1.0],
                           @"个人提升" : [self colorWithHexString:@"#FF6F09" alpha:1.0],
                           @"营销技巧" : [self colorWithHexString:@"#A05AFF" alpha:1.0],
                           };
    return dic[typeString] ? dic[typeString] : [UIColor clearColor];
}
//NSDate转NSString
+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)setCreateTime:(NSString *)createTime {
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:[createTime longLongValue] / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:DATE_FORMAT_];
    NSString *dateString = [formatter stringFromDate:dateTime];
    return dateString;
}

+ (NSString *)getHourAndMinute:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* nowHour = [cal components:NSHourCalendarUnit fromDate:date];
    NSDateComponents* nowMinute = [cal components:NSMinuteCalendarUnit fromDate:date];
    NSDateComponents* nowSceond = [cal components:NSCalendarUnitSecond fromDate:date];
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)nowHour.hour];
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)nowMinute.minute];
    NSString *sceonds = [NSString stringWithFormat:@"%ld",(long)nowSceond.second];
    if (minute.length == 1) {
        minute = [@"0" stringByAppendingString:minute];
    }
    if (sceonds.length == 1) {
        sceonds = [@"0" stringByAppendingString:sceonds];
    }
    return [[[[hour stringByAppendingString:@":"]stringByAppendingString:minute]stringByAppendingString:@":"]stringByAppendingString:sceonds];
}

+ (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (void)setTapGestureRecognierTextResignFirstResponder:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMargin:)];
    [view  addGestureRecognizer:tap];
}

+ (NSString *)stringFormatDateMin:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_TAKE_MIN];
    return [dateFormatter stringFromDate:date];
}


+(int)sinaCountWord:(NSString *)word
{
    int i,n=[word length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[word characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

+ (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0){
        return jsonData;
    }else{
        return nil;
    }
    
    
}

+ (long long)getTimeSince1970InMsLongLong {
    NSDate *dateNow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateNow];
    NSDate *localeDate = [dateNow dateByAddingTimeInterval:interval];
    return (long long) [localeDate timeIntervalSince1970] * 1000;
}


+ (NSString *)getHourAndMin{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    [formatter setDateFormat:@"hh:mm:ss"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];//将NSDate  ＊对象 转化为 NSString ＊对象。
    return currentTime;
}

+ (NSString *)newCompareCurrentTime:(NSString *)time {
    long long temp = [time longLongValue];
    long long currentTime = [self getTimeSince1970InMsLongLong];
    
    long long timeInterval = currentTime - temp;
    timeInterval = timeInterval / 1000;
    
    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    
    timeInterval = timeInterval / 60;
    if (timeInterval < 60) {
        return [[NSString stringWithFormat:@"%lld", timeInterval] stringByAppendingString:@"分钟前"];
    }
    
    timeInterval = timeInterval / 60;
    if (timeInterval < 24) {
        return [[NSString stringWithFormat:@"%lld", timeInterval] stringByAppendingString:@"小时前"];
    }
    
    timeInterval = timeInterval / 24;
    if (timeInterval < 30) {
        return [[NSString stringWithFormat:@"%lld", timeInterval] stringByAppendingString:@"天前"];
    }
    
    timeInterval = timeInterval / 30;
    if (timeInterval < 12) {
        return [[NSString stringWithFormat:@"%lld", timeInterval] stringByAppendingString:@"月前"];
    }
    
    timeInterval = timeInterval / 12;
    return [[NSString stringWithFormat:@"%lld", timeInterval] stringByAppendingString:@"年前"];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage; 
}

+(NSString *)getNowTimeTimestamp2{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

+ (NSString *)getCurrentDataAndTime {
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
//    m_labDate.text=[NSString stringWithFormat:@"%d年%d月",year,month];
//    m_labToday.text=[NSString stringWithFormat:@"%d",day];
//    m_labWeek.text=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]];
    NSString *weekDay = [arrWeek objectAtIndex:week-1];
    return [[[[[NSString stringWithFormat:@"%d",month]stringByAppendingString:@"月"]stringByAppendingFormat:@"%d",day] stringByAppendingString:@"日  "]stringByAppendingString:weekDay];
}

+ (void)setTableViewAnimation:(UITableView *)currentTableView offsetY:(NSInteger)offsetY{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3]; //动画的内容
    currentTableView.frame = CGRectMake(currentTableView.frame.origin.x, -offsetY, currentTableView.frame.size.width, currentTableView.frame.size.height);
    [UIView commitAnimations]; //动画结束
}

+ (void)setTableViewReduction:(UITableView *)currentTableView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    currentTableView.frame =CGRectMake(currentTableView.frame.origin.x, 0, currentTableView.frame.size.width, currentTableView.frame.size.height);
    [UIView commitAnimations];
}

+ (void)setUpNavigaitonBar{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"20%"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicAtt = [NSMutableDictionary dictionary];
    dicAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dicAtt[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [bar setTitleTextAttributes:dicAtt];
    //设置状态栏的样式,默认的状态栏的样式由控制器决定 ,并且子啊plist文件中添加该字段View controller-based status bar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
      * 中国移动：China Mobile
     */
    NSString * CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
      * 中国联通：China Unicom
     */
    NSString * CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
      * 中国电信：China Telecom
     */
    NSString * CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum]
         || [regextestcm evaluateWithObject:mobileNum]
         || [regextestct evaluateWithObject:mobileNum]
         || [regextestcu evaluateWithObject:mobileNum])) {
        return YES;
    }
    
    return NO;
    
}
//判断手机号码格式是否正确

+ (BOOL)checkTelNumber:(NSString*) telNumber{
    //@"^1+[34578]+\\d{9}"
    NSString * pattern = @"1\\d{10}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
    
}

+(BOOL)isPhoneNumber:(NSString *)patternStr{
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}


//判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}


//判断是否为正确邮箱
+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}


//限制只能输入数字
+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}
//判断是否是纯汉字
+ (BOOL)isChinese:(NSString *) password
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    BOOL isChinese = [predicate evaluateWithObject:password];
    return isChinese;
}
//判断是否含有汉字
+ (BOOL)includeChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

//判断是否为纯数字
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (void)showImage:(UIImageView *)imageview{

    UIImage * image = imageview.image;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView * backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    oldframe = [imageview convertRect:imageview.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}


+ (void)hideImage:(UITapGestureRecognizer *)tap{
    UIView * backgroundView = tap.view;
    UIImageView * imageView = (UIImageView *)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+ (NSInteger)getLines:(NSMutableArray *)imageArray {
    if (imageArray.count % 5 == 0) {
        return imageArray.count / 5;
    }
    return imageArray.count / 5 + 1;
}

+ (CGFloat)getLineHeights:(NSString *)content {
    UIFont *font = [UIFont systemFontOfSize:15];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 104, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    return rect.size.height;
}

+ (long)timestamp{
    long recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return recordTime;
}


+ (void)setCenterLineWithLabelStr:(NSString *)string label:(UILabel *)strikeLabel{

        NSString *textStr = [NSString stringWithFormat:@"%@", string];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];

        // 赋值
    // 赋值
    strikeLabel.attributedText = attribtStr;
}

+ (void)setBottomLineWithLabelStr:(NSString *)string label:(UILabel *)underlineLabel{
    NSString *textStr = [NSString stringWithFormat:@"%@", string];
    
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    
    //赋值
    underlineLabel.attributedText = attribtStr;
}


#pragma mark -- 计算纯文本行高
+ (CGSize)getStringSizeByFont:(NSString *)str width:(CGFloat)width font:(CGFloat)fontSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;

    return size;
}
#pragma mark -- 计算NSAttributedString 文本高度
+ (CGFloat)attributStringHeightWithString:(NSAttributedString *)attributStr contentWidth:(CGFloat)contentWidth{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    return [attributStr boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    if (!color) {
        color = [UIColor whiteColor];
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)circleImage:(UIImage*)image strokeColor:(UIColor *)color withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset*2, image.size.height - inset*2);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg   = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
+ (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)layerCornerRadius:(UIImageView *)imageView rect:(CGRect)rect{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
}

// Center Square Image
+ (NSURL *)qiniuImageCenter:(NSString *)link
                  withWidth:(NSString *)width
                 withHeight:(NSString *)height
{
    
    NSString *url = [[NSString alloc] init];
    if([height isEqualToString:@"0"]) {
        url = [NSString stringWithFormat:@"%@?imageView2/2/w/%@/", link, width];
    } else {
        url = [NSString stringWithFormat:@"%@?imageView/1/w/%@/h/%@", link, width, height];
    }
    return [NSURL URLWithString:url];
}

+ (NSURL *)qiniuImageCenter:(NSString *)link
                  withWidth:(NSString *)width
                 withHeight:(NSString *)height
                       mode:(NSInteger)model
{
    NSString *url = [[NSString alloc] init];
    url = [NSString stringWithFormat:@"%@?imageView/%ld/w/%@/h/%@", link, (long)model, width, height];
    return [NSURL URLWithString:url];
}
#pragma mark -- url含中文转码
+ (NSString *)encodedUrl:(NSString *)url{
    if ([self includeChinese:url] == YES) {
        NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return encodedUrl;
    }
    return url;
}
+ (CAGradientLayer *)graditentWithToView:(CGRect)frame cgColors:(NSArray*)colors{
    CAGradientLayer * graditentLayer = [CAGradientLayer layer];
    graditentLayer.frame = frame;
    graditentLayer.startPoint = CGPointMake(0, 0);
    graditentLayer.endPoint = CGPointMake(1, 0);
    graditentLayer.locations = @[@(0.3),@(0.5),@(1.0)];
    //渐变数组
    graditentLayer.colors = colors;
    
    
    return graditentLayer;
   
}

+ (NSString *)htmlEntityDecode:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    return string;
}
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString{
    NSDictionary * options = @{
                               NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding),
                               };
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];

}
//去掉 HTML 字符串中的标签
+ (NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+ (NSString*)formatTimeFromSeconds:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (UIViewController *)viewControllerFromView:(UIView *)view{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (UINavigationController *)navigationControllerFromView:(UIView *)view {
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

+ (UIViewController *)getCurrentViewControll{
    UIViewController *result = nil;
    
    // 获取默认的window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取window的rootViewController
    result = window.rootViewController;
    
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    
    return result;
}

#pragma mark -- 左右晃动动画
- (void)shake:(UIView *)animateView
{
    CGFloat t = 4.0;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    animateView.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        animateView.transform = translateRight;
    } completion:^(BOOL finished) {
        if(finished)
        {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                animateView.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
#pragma mark -- 360°旋转 ( MAXFLOAT )
+ (void)animateRotationZ:(UIView *)view{
    [view.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 10;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [view.layer addAnimation:animation forKey:nil];
}

//暂停动画
+ (void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
//继续动画
+ (void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
#pragma mark -- 登录状态

//+ (void)loginState:(UIViewController *)vc login:(void (^)(void))login{
+ (void)loginState:(void (^)(void))login{
//    if ([self isEmptyString:UserId]) {
////        [BaseTool showLoginView];
//        UIViewController * VC = [self getCurrentViewControll];
//        DLog(@"%@",[VC class]);
////        [[AppDelegate sharedApplication].window ]
//        LoginVC *login = [[LoginVC alloc]init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:nil];
//        
////        [VC presentViewController:[[LoginVC alloc]init] animated:NO completion:nil];
//    }else{
//        login();
//    }
}

#pragma mark --判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"null"] || [string isEqualToString:@"<null>"])
    {
        return YES;
    }
    
    return NO;
}
#pragma mark -- 可变数组去重
+ (NSMutableArray *)removeRepeat:(NSMutableArray *)repeatArray{
    NSMutableArray * result = [NSMutableArray array];
    NSMutableSet * set = [NSMutableSet set];
    for (id objc in repeatArray) {
        if (![set containsObject:objc]) {
            [result addObject:objc];
            [set addObject:objc];
        }
    }
    return result;
}


#define kAudioSavePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"audio.json"]
+ (void)saveMusicList:(NSArray *)musicList{
    [NSKeyedArchiver archiveRootObject:musicList toFile:kAudioSavePath];
}

+ (NSArray *)musicList{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kAudioSavePath];
}
#pragma mark -- 去除分割线
+ (void)drawRectTableCellClear:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [PreHelper colorWithHexString:@"#ffffff" alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [PreHelper colorWithHexString:@"e2e2e2" alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}

#pragma mark -- 客服电话
+ (void)customerService{
    NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4006123029"]];
    [[UIApplication sharedApplication] openURL:URL
                                       options:@{}
                             completionHandler:nil];
}

+ (NSString *)systemVersion{
    NSString * systemVersion = [UIDevice currentDevice].systemVersion;

    return systemVersion;
}

/**
 根据目标图片制作一个盖水印的图片
 
 @param originalImage 源图片
 @param title 水印文字
 @param markFont 水印文字font(如果不传默认为23)
 @param markColor 水印文字颜色(如果不传递默认为源图片的对比色)
 @return 返回盖水印的图片
 */
#define HORIZONTAL_SPACE 30//水平间距
#define VERTICAL_SPACE 50//竖直间距
#define CG_TRANSFORM_ROTATION (M_PI_2 / 3)//旋转角度(正旋45度 || 反旋45度)
+ (UIImage *)getWaterMarkImage: (UIImage *)originalImage andTitle: (NSString *)title andMarkFont: (UIFont *)markFont andMarkColor: (UIColor *)markColor{
    
    UIFont *font = markFont;
    if (font == nil) {
        font = [UIFont systemFontOfSize:23];
    }
    UIColor *color = markColor;
    if (color == nil) {
        color = [self mostColor:originalImage];
    }
    //原始image的宽高
    CGFloat viewWidth = originalImage.size.width;
    CGFloat viewHeight = originalImage.size.height;
    //为了防止图片失真，绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
    //先将原始image绘制上
    [originalImage drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
    //文字的属性
    NSDictionary *attr = @{
                           //设置字体大小
                           NSFontAttributeName: font,
                           //设置文字颜色
                           NSForegroundColorAttributeName :color,
                           };
    NSString* mark = title;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    //绘制文字的宽高
    CGFloat strWidth = attrStr.size.width;
    CGFloat strHeight = attrStr.size.height;
    
    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();

    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(CG_TRANSFORM_ROTATION));
    //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    
    //计算需要绘制的列数和行数
    int horCount = sqrtLength / (strWidth + HORIZONTAL_SPACE) + 1;
    int verCount = sqrtLength / (strHeight + VERTICAL_SPACE) + 1;
    
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = -(sqrtLength-viewWidth)/2;
    CGFloat orignY = -(sqrtLength-viewHeight)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = orignX;
    //在每行绘制时Y坐标叠加
    CGFloat tempOrignY = orignY;
    for (int i = 0; i < horCount * verCount; i++) {
        [mark drawInRect:CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight) withAttributes:attr];
        if (i % horCount == 0 && i != 0) {
            tempOrignX = orignX;
            tempOrignY += (strHeight + VERTICAL_SPACE);
        }else{
            tempOrignX += (strWidth + HORIZONTAL_SPACE);
        }
    }
    //根据上下文制作成图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    return finalImg;
}


//根据图片获取图片的主色调
+(UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width/2, image.size.height/2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
//第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
 
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

+ (UIWindow *)currentKeyWindow {
    // iOS 13+ 使用 Scene 管理窗口
    if (@available(iOS 13.0, *)) {
        // 获取所有连接的场景
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        
        // 1. 优先查找前台活跃的窗口场景
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                
                // 1.1 优先返回当前场景的 keyWindow
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
                
                // 1.2 无 keyWindow 时，查找最顶层可见窗口
                // 反向遍历（后添加的窗口在上层）
                for (UIWindow *window in [windowScene.windows reverseObjectEnumerator]) {
                    if (window.windowLevel == UIWindowLevelNormal && !window.isHidden) {
                        return window;
                    }
                }
                
                // 1.3 最后返回场景中的第一个窗口
                if (windowScene.windows.count > 0) {
                    return windowScene.windows.firstObject;
                }
            }
        }
        
        // 2. 无前台活跃场景时，查找其他前台场景
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundInactive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                
                // 同样优先查找 keyWindow 或可见窗口
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
                
                for (UIWindow *window in [windowScene.windows reverseObjectEnumerator]) {
                    if (window.windowLevel == UIWindowLevelNormal && !window.isHidden) {
                        return window;
                    }
                }
                
                if (windowScene.windows.count > 0) {
                    return windowScene.windows.firstObject;
                }
            }
        }
    }
    
    // iOS 12 及以下版本兼容方案
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow) return keyWindow;
    
    // 无 keyWindow 时查找可见窗口
    for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        if (window.windowLevel == UIWindowLevelNormal && !window.isHidden) {
            return window;
        }
    }
    
    // 最后返回任意窗口
    return [UIApplication sharedApplication].windows.firstObject;
}

@end
