//
//  DRMEMosaiPath.m
//

#import "DRMEMosaiPath.h"

@interface DRMEMosaiPath()<NSCopying,NSMutableCopying>

@end

@implementation DRMEMosaiPath

- (instancetype)init
{
    self = [super init];
    if (self) {
        _startPoint = CGPointZero;
        _endPoint = CGPointZero;
        _pathPointArray = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)resetStatus{
    _startPoint = CGPointZero;
    _endPoint = CGPointZero;
    [_pathPointArray removeAllObjects];
}



- (id)copyWithZone:(NSZone *)zone
{
    DRMEMosaiPath *obj = [[[self class] allocWithZone:zone] init];
    obj.pathPointArray = [self.pathPointArray copyWithZone:zone];
    obj.startPoint = self.startPoint;
    obj.endPoint = self.endPoint;
    
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    DRMEMosaiPath *obj = [[[self class] allocWithZone:zone] init];
    obj.pathPointArray = [self.pathPointArray copyWithZone:zone];
    obj.startPoint = self.startPoint;
    obj.endPoint = self.endPoint;
    return obj;
}

@end


@implementation DRMEPathPoint

- (instancetype)init
{
    self = [super init];
    if (self) {
        _xPoint = _yPoint = 0;
    }
    return self;
}

@end
