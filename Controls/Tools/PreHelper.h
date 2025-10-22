//
//  PreHelper.h
//  HistoryPlayer
//
//  Created by wjq on 15/8/31.
//  Copyright (c) 2015年 wjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PreHelper : NSObject
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)randomColor;
#pragma mark -- 标签颜色
+ (UIColor *)textColorWithText:(NSString *)typeString;

#pragma mark -- 随机字符(UUID + time)
+ (NSString *)randomKey;

+ (NSString *)dateToString:(NSDate *)date;

+ (NSString *)getNowTimeTimestamp2;

+ (NSString *)setCreateTime:(NSString *)createTime;

+ (NSString *)getHourAndMinute:(NSDate *)date;

+ (long long)getTimeSince1970InMsLongLong;

+ (NSString *)getHourAndMin;

+ (void)setExtraCellLineHidden:(UITableView *)tableView;

+ (void)setTapGestureRecognierTextResignFirstResponder:(UIView *)view;

+ (NSString *)stringFormatDateMin:(NSDate *)date;

+(int)sinaCountWord:(NSString *)word;

+ (NSData *)toJSONData:(id)theData;

+ (NSString *)newCompareCurrentTime:(NSString *)time;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (NSString *)getCurrentDataAndTime;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;//json字符串转字典

+ (void)setTableViewAnimation:(UITableView *)currentTableView offsetY:(NSInteger)offsetY;
+(void)setTableViewReduction:(UITableView *)currentTableView;


+ (void)setUpNavigaitonBar;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)checkTelNumber:(NSString*)telNumber;

+(BOOL)isPhoneNumber:(NSString *)patternStr;

#pragma mark -- 判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;

#pragma mark -- 判断是否为正确邮箱
+ (BOOL)isValidateEmail:(NSString *)Email;

#pragma mark -- 限制职能输入数字
+ (BOOL)validateNumber:(NSString*)number;

+ (BOOL)checkPassword:(NSString *) password;

#pragma mark -- 判断是否是纯汉字
+ (BOOL)isChinese:(NSString *) password;

#pragma mark -- 判断是否为纯数字
+ (BOOL)isPureInt:(NSString*)string;
#pragma mark -- 判断是否含有汉字
+ (BOOL)includeChinese:(NSString *)string;

+ (void)showImage:(UIImageView * )imageView;

#pragma mark --  获取当前时间戳
+ (long)timestamp;

+ (void)setCenterLineWithLabelStr:(NSString *)string label:(UILabel *)strikeLabel;

+ (void)setBottomLineWithLabelStr:(NSString *)string label:(UILabel *)underlineLabel;


#pragma mark -- 计算纯文本行高
+ (CGSize)getStringSizeByFont:(NSString *)str width:(CGFloat)width font:(CGFloat)fontSize;

#pragma mark -- 计算NSAttributedString 文本高度
+ (CGFloat)attributStringHeightWithString:(NSAttributedString *)attributStr contentWidth:(CGFloat)contentWidth;


+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;
#pragma mark -- 绘图
+ (UIImage*)imageChangeColor:(UIColor *)color;
+ (UIImage*)circleImage:(UIImage*)image strokeColor:(UIColor *)color withParam:(CGFloat) inset;


+ (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr;

+ (void)layerCornerRadius:(UIImageView *)imageView;


+ (NSURL *)qiniuImageCenter:(NSString *)link
                  withWidth:(NSString *)width
                 withHeight:(NSString *)height;

+ (NSURL *)qiniuImageCenter:(NSString *)link
                  withWidth:(NSString *)width
                 withHeight:(NSString *)height
                       mode:(NSInteger)model;


#pragma mark -- 渐变色
+ (CAGradientLayer *)graditentWithToView:(CGRect)frame cgColors:(NSArray*)colors;


#pragma mark -- url含中文转码
+ (NSString *)encodedUrl:(NSString *)url;

#pragma mark -- 将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string;

#pragma mark -- 将HTML字符串转化为NSAttributedString富文本字符串
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString;
#pragma mark -- 去掉 HTML 字符串中的标签
+ (NSString *)filterHTML:(NSString *)html;

#pragma mark -- 时长 时分秒
+ (NSString*) formatTimeFromSeconds:(int)totalSeconds;

#pragma mark --  获取当前View的ViewController
+ (UIViewController *)viewControllerFromView:(UIView *)view;
#pragma mark -- 获取当前View的导航控制器
+ (UINavigationController *)navigationControllerFromView:(UIView *)view;
+ (UIViewController *)getCurrentViewControll;

#pragma mark -- 左右晃动动画
+ (void)shake:(UIView *)animateView;

#pragma mark -- 360°旋转 ( MAXFLOAT )
+ (void)animateRotationZ:(UIView *)view;
#pragma mark -- 暂停动画
+ (void)pauseLayer:(CALayer*)layer;
#pragma mark -- 继续动画
+ (void)resumeLayer:(CALayer*)layer;

#pragma mark --判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string;

#pragma mark -- 登录状态
//+ (void)loginState:(UIViewController *)vc login:(void (^)(void))login{
+ (void)loginState:(void (^)(void))login;
    
#pragma mark -- 可变数组去重
+ (NSMutableArray *)removeRepeat:(NSMutableArray *)repeatArray;

/**
 此方法用于保存当前正在播放的音乐列表
 
 @param musicList 当前正在播放的音乐列表
 */
+ (void)saveMusicList:(NSArray *)musicList;

/**
 此方法用于获取本地保存的播放器正在播放的音乐列表
 
 @return 音乐列表
 */
+ (NSArray *)musicList;

#pragma mark -- 去除分割线
+ (void)drawRectTableCellClear:(CGRect)rect;

#pragma mark -- 客服电话
+ (void)customerService;

#pragma mark -- 获取 Version
+ (NSString *)systemVersion;


/**
根据目标图片制作一个盖水印的图片

@param originalImage 源图片
@param title 水印文字
@param markFont 水印文字font(如果不传默认为23)
@param markColor 水印文字颜色(如果不传递默认为源图片的对比色)
@return 返回盖水印的图片
*/
+ (UIImage *)getWaterMarkImage:(UIImage *)originalImage andTitle:(NSString *)title andMarkFont:(UIFont *)markFont andMarkColor:(UIColor *)markColor;

#pragma mark - 根据图片获取图片的主色调
+(UIColor *)mostColor:(UIImage *)image;

+ (UIWindow *)currentKeyWindow;

@end
