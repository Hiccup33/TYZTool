//
//  TagView.h
//  test_tag1
//
//  Created by Hiccup on 2020/8/25.
//  Copyright © 2020 Hiccup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TagType_Forward, ///tag加入文字后面
    TagType_Frant    ///tag加入文字前面
} TagType;

@interface TagView : UIView

///标题颜色
@property (nonatomic, strong) UIColor *titleColor;
///标签字体颜色
@property (nonatomic, strong) UIColor *tagColor;
///标签背景颜色
@property (nonatomic, strong) UIColor *tagBgColor;
///标签允许显示的最大字符长度
@property (nonatomic, assign) int tagMaxLength;
///最大宽度
@property (nonatomic, assign) int maxWidth;
///左右边距
@property (nonatomic, assign) int margin;
///标题字体大小
@property (nonatomic, assign) CGFloat fontSize;
///标签字体大小
@property (nonatomic, assign) CGFloat tagFontSize;
///标签高度, 默认16
@property (nonatomic, assign) CGFloat tagHeight;
///标签位置,前,后
@property (nonatomic, assign) TagType tagType;
///行间距
@property (nonatomic, assign) int lineSpacing;
///首行缩进
@property (nonatomic, assign) int firstLineHeadIndent;
///段间距
@property (nonatomic, assign) int paragraphSpacingBefore;
///字间距
@property (nonatomic, assign) CGFloat wordspace;

- (CGFloat)initWithTitle:(NSString *)title tagString:(NSString *)tagString;

@end

NS_ASSUME_NONNULL_END
