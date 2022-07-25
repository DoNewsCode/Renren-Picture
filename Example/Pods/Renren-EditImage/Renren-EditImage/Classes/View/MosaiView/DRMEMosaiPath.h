//
//  DRMEMosaiPath.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DRMEPathPoint : NSObject

@property(nonatomic)float xPoint;

@property(nonatomic)float yPoint;

@end


@interface DRMEMosaiPath : NSObject

@property(nonatomic)CGPoint startPoint;
@property(nonatomic)NSMutableArray *pathPointArray;
@property(nonatomic)CGPoint endPoint;

-(void)resetStatus;

@end
