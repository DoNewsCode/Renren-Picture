//
//  DRMEMosaiView.h
//

#import <UIKit/UIKit.h>
@protocol MosaiViewDelegate;
@interface DRMEMosaiView : UIView


- (void)setupSubview;

//底图为马赛克图
@property (nonatomic, strong) UIImage *mosaicImage;
//表图为正常图片
@property (nonatomic, strong) UIImage *originalImage;
//OperationCount
@property (nonatomic, assign, readonly) NSInteger operationCount;
//CurrentIndex
@property (nonatomic, assign, readonly) NSInteger currentIndex;
//Delegate
@property (nonatomic, weak) id<MosaiViewDelegate> deleagate;

//ResetMosai
-(void)resetMosaiImage;

//Redo
-(void)redo;

//Undo
-(void)undo;

-(BOOL)canUndo;

-(BOOL)canRedo;

//Render
-(UIImage*)render;
@end


@protocol MosaiViewDelegate<NSObject>

@optional

-(void)mosaiView:(DRMEMosaiView*)view TouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

-(void)mosaiView:(DRMEMosaiView*)view TouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)mosaiView:(DRMEMosaiView*)view TouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
