//
//  JPLineView.m
//  JPChartView
//
//  Created by 贾萍 on 16/5/30.
//  Copyright © 2016年 贾萍. All rights reserved.
//

#import "JPLineView.h"
#import <math.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "JPDotItem.h"

#pragma mark -
#pragma mark MACRO

#define POINT_CIRCLE  6.0f
#define NUMBER_VERTICAL_ELEMENTS (10)
#define HORIZONTAL_LINE_SPACES (20)
#define HORIZONTAL_LINE_WIDTH (0.2)
#define HORIZONTAL_START_LINE (0.17)
#define POINTER_WIDTH_INTERVAL  (20)
#define AXIS_FONT_SIZE    (8)

#define AXIS_BOTTOM_LINE_HEIGHT (30)
#define AXIS_LEFT_LINE_WIDTH (35)

#define FLOAT_NUMBER_FORMATTER_STRING  @"%.2f"

#define DEVICE_WIDTH   (320)

#define AXIX_LINE_WIDTH (0.5)



#pragma mark -
@interface JPLineView()
{
    UIPinchGestureRecognizer *pinchGesture;
    BOOL isPinch;
    CGPoint touchViewPoint;
    UIView *movelineone;
    UIView *movelinetwo;
    UILabel *movelineoneLable;
    UILabel *movelinetwoLable;
}
@property(nonatomic,retain)NSMutableArray *itemArray;
@end
@implementation JPLineView

#pragma mark -
#pragma mark init

-(void)commonInit{
    self.itemArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.fontName=@"Helvetica";
    self.numberOfVerticalElements=NUMBER_VERTICAL_ELEMENTS;
    self.xAxisFontColor = [UIColor darkGrayColor];
    self.xAxisFontSize = AXIS_FONT_SIZE;
    self.horizontalLinesColor = [UIColor lightGrayColor];
    
    self.horizontalLineInterval = HORIZONTAL_LINE_SPACES;
    self.horizontalLineWidth = HORIZONTAL_LINE_WIDTH;
    
    self.pointerInterval = POINTER_WIDTH_INTERVAL;
    
    self.axisBottomLinetHeight = AXIS_BOTTOM_LINE_HEIGHT;
    self.axisLeftLineWidth = AXIS_LEFT_LINE_WIDTH;
    self.axisLineWidth = AXIX_LINE_WIDTH;
    
    self.floatNumberFormatterString = FLOAT_NUMBER_FORMATTER_STRING;
    
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pintchAction:)];
    [self addGestureRecognizer:pinchGesture];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.3f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    
  
}
#pragma mark 捏合手势
-(void)pintchAction:(UIPinchGestureRecognizer*)pintchResture{
    NSLog(@"状态：%li==%f",(long)pintchResture.state,pintchResture.scale);
    if (pintchResture.state==2) {
        if (pintchResture.scale>1) {
            // 放大手势
            isPinch  = YES;
            [self setNeedsDisplay];
        }else{
            isPinch  = NO;
            // 缩小手势
            [self setNeedsDisplay];
        }
    }
    if (pintchResture.state==3) {
    }

}

#pragma mark 长按就开始生成十字线
-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    touchViewPoint = [longResture locationInView:self];
    if(longResture.state == UIGestureRecognizerStateBegan){
        [self setView];
        [self isKPointWithPoint:touchViewPoint];
    }
    if (longResture.state == UIGestureRecognizerStateChanged) {
        
        [self isKPointWithPoint:touchViewPoint];
    }
    
    if (longResture.state == UIGestureRecognizerStateEnded) {
        [movelineone removeFromSuperview];
        [movelinetwo removeFromSuperview];
        [movelineoneLable removeFromSuperview];
        [movelinetwoLable removeFromSuperview];
        
        movelineone = nil;
        movelinetwo = nil;
        movelineoneLable = nil;
        movelinetwoLable = nil;
    }
}
-(void)update{
    
}
#pragma mark 判断并在十字线上显示提示信息
-(void)isKPointWithPoint:(CGPoint)point{
    CGFloat itemPointX = 0;
    for (JPDotItem *item in self.itemArray) {
        itemPointX = item.x;
        int itemX = (int)itemPointX;
        int pointX = (int)point.x;
        NSLog(@"^^^^====%@===%f=%f==%f",NSStringFromCGPoint(point),item.y,item.x,_contentScroll.x);

        if (itemX==pointX || (point.x+fabsf(_contentScroll.x))-itemX<=self.pointerInterval/2) {

            movelineone.frame = CGRectMake(itemPointX+_contentScroll.x,movelineone.frame.origin.y, movelineone.frame.size.width, movelineone.frame.size.height);
//            if (_contentScroll.x>self.frame.size.width) {
//                movelinetwo.frame = CGRectMake(movelinetwo.frame.origin.x,item.y, movelinetwo.frame.size.width, movelinetwo.frame.size.height);
//
//            }else{
//                movelinetwo.frame = CGRectMake(movelinetwo.frame.origin.x,self.frame.size.height-item.y, movelinetwo.frame.size.width, movelinetwo.frame.size.height);
//
//            }
            movelinetwo.frame = CGRectMake(movelinetwo.frame.origin.x,self.frame.size.height-item.y, movelinetwo.frame.size.width, movelinetwo.frame.size.height);

            // 垂直提示日期控件
            movelineoneLable.text = [NSString stringWithFormat:@"%@\n%f",item.date,item.price]; // 日期
            movelineoneLable.hidden = NO;
            movelineoneLable.center = CGPointMake(movelineone.frame.origin.x, movelinetwo.frame.origin.y);
                       break;
        }
    }

}
- (instancetype)init {
    if((self = [super init])) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    
    [self commonInit];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)addData:(NSDictionary *)dic{
    if (dic==nil) {
        return;
    }
    if (dic.allKeys.count == 0) {
        return;
    }
    if (self.dataDic == nil) {
        self.dataDic = [[NSDictionary alloc]initWithDictionary:dic];
    }
    [self setView];
    [self layoutIfNeeded];

}
-(void)setView{
    if (movelineone==Nil) {
        movelineone = [[UIView alloc] initWithFrame:CGRectMake(50,0, 0.5,
                                                               self.frame.size.height-30)];
        movelineone.backgroundColor = [UIColor blackColor];
        [self addSubview:movelineone];
        //        movelineone.hidden = YES;
    }
    if (movelinetwo==Nil) {
        movelinetwo = [[UIView alloc] initWithFrame:CGRectMake(40,130, self.frame.size.width,0.5)];
        movelinetwo.backgroundColor = [UIColor blackColor];
        movelinetwo.hidden = YES;
        [self addSubview:movelinetwo];
    }
    if (movelineoneLable==Nil) {
        movelineoneLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
        movelineoneLable.font = [UIFont systemFontOfSize:11];
        movelineoneLable.numberOfLines = 0;
        movelineoneLable.lineBreakMode = NSLineBreakByWordWrapping;
        movelineoneLable.layer.cornerRadius = 5;
        movelineoneLable.backgroundColor = [UIColor blueColor];
        movelineoneLable.textColor = [UIColor whiteColor];
        movelineoneLable.textAlignment = UITextAlignmentCenter;
        movelineoneLable.alpha = 0.8;
        movelineoneLable.hidden = YES;
        [self addSubview:movelineoneLable];
    }
    
    movelineone.frame = CGRectMake(touchViewPoint.x,0, 0.5,
                                   self.frame.size.height-30);
    movelinetwo.frame = CGRectMake(40,touchViewPoint.y, self.frame.size.width,0.5);
    
    CGRect oneFrame = movelineone.frame;
    oneFrame.size = CGSizeMake(50, 12);
    
    
    movelineone.hidden = NO;
    movelinetwo.hidden = NO;
    [self isKPointWithPoint:touchViewPoint];

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark -
#pragma mark Draw the lineChart
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (isPinch) {
        self.pointerInterval = 40;
    }else{
        self.pointerInterval = 20;
    }
    CGFloat startHeight = self.axisBottomLinetHeight;
    CGFloat startWidth = self.axisLeftLineWidth;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f , self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // set text size and font
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSelectFont(context, [self.fontName UTF8String], self.xAxisFontSize, kCGEncodingMacRoman);
    
    
    // draw yAxis
    for (int i=0; i<=self.numberOfVerticalElements; i++) {
        int height =self.horizontalLineInterval*i;
        float verticalLine = height + startHeight - self.contentScroll.y;
        
        CGContextSetLineWidth(context, self.horizontalLineWidth);
        
        [self.horizontalLinesColor set];
        
        CGContextMoveToPoint(context, startWidth, verticalLine);
        CGContextAddLineToPoint(context, self.bounds.size.width, verticalLine);
        CGContextStrokePath(context);
        
        
        NSNumber* yAxisVlue = [self.yDataArray objectAtIndex:i];
        
        NSString* numberString = [NSString stringWithFormat:self.floatNumberFormatterString, yAxisVlue.floatValue];
        
        NSInteger count = [numberString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        CGContextShowTextAtPoint(context, 0, verticalLine - self.xAxisFontSize/2, [numberString UTF8String], count);
    }
    
    
    // draw lines
    
        [[UIColor redColor] set];
        CGContextSetLineWidth(context, 3.0);
        // draw lines
        for (int i=0; i<self.dataDic.allKeys.count; i++) {
            
            JPDotItem *item = [[JPDotItem alloc]init];
            
            NSString *keyStr = self.xDataArray[i];
            
            NSString* dateStr = [self.dataDic objectForKey:keyStr];
           
            float floatValue = [dateStr floatValue];
            
            float height = (floatValue-self.yMin)/self.yInterval*self.horizontalLineInterval-self.contentScroll.y+startHeight;
            float width =self.pointerInterval*(i+1)+self.contentScroll.x+ startHeight+5;
            
            if (width<startWidth) {
                
                NSString *nextKeyStr = self.xDataArray[i+1];
                NSString* nextDateStr = [self.dataDic objectForKey:nextKeyStr];
                float nextFloatValue = [nextDateStr floatValue];
                float nextHeight = (nextFloatValue-self.yMin)/self.yInterval*self.horizontalLineInterval+startHeight;
                item.x = width;
                item.y = height;
                item.date = nextKeyStr;
                item.price = nextFloatValue;
                CGContextMoveToPoint(context, startWidth, nextHeight);
                
                //
                continue;
            }
            
            if (i==0) {
                item.x = width;
                item.y = height;
                item.date = keyStr;
                item.price = floatValue;
                CGContextMoveToPoint(context,  width, height);
            }
            else{
                item.date = keyStr;
                item.x = width;
                item.y = height;
                item.price = floatValue;
                CGContextAddLineToPoint(context, width, height);
            }
            
            NSLog(@"$$$$$==%f",item.x);
            [self.itemArray addObject:item];
        }
    NSLog(@"===%lu===%lu===%@",(unsigned long)self.itemArray.count,(unsigned long)self.xDataArray.count,self.xDataArray);
        
        CGContextStrokePath(context);
        
    
    [self.xAxisFontColor set];
    CGContextSetLineWidth(context, self.axisLineWidth);
    CGContextMoveToPoint(context, startWidth, startHeight);
    
    CGContextAddLineToPoint(context, startWidth, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, startWidth, startHeight);
    CGContextAddLineToPoint(context, self.bounds.size.width, startHeight);
    CGContextStrokePath(context);
    
    // x axis text
    for (int i=0; i<self.xDataArray.count; i++) {
        
        float width =self.pointerInterval*(i+1)+self.contentScroll.x+ startHeight;
        float height = self.xAxisFontSize;
        
        if (width<startWidth) {
            continue;
        }
        
        
        NSInteger count = [[self.xDataArray objectAtIndex:i] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        CGContextShowTextAtPoint(context, width, height, [[self.xDataArray objectAtIndex:i] UTF8String], count);
    }


}
#pragma mark -
#pragma mark touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
    float xDiffrance=touchLocation.x-prevouseLocation.x;
    float yDiffrance=touchLocation.y-prevouseLocation.y;
    
    _contentScroll.x+=xDiffrance;
    _contentScroll.y+=yDiffrance;
    
    if (_contentScroll.x >0) {
        _contentScroll.x=0;
    }
    
    if(_contentScroll.y<0){
        _contentScroll.y=0;
    }
    
    if (-_contentScroll.x>(self.pointerInterval*(self.xDataArray.count +3)-DEVICE_WIDTH)) {
        _contentScroll.x=-(self.pointerInterval*(self.xDataArray.count +3)-DEVICE_WIDTH);
    }
    
    if (_contentScroll.y>self.frame.size.height/2) {
        _contentScroll.y=self.frame.size.height/2;
    }
    
    
    _contentScroll.y =0;// close the move up
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
