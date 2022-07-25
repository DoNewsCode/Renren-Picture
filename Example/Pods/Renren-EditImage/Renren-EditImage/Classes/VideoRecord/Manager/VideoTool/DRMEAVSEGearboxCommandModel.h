//
//  DRMEAVSEGearboxCommandModel.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEGearboxCommandModel : NSObject

@property (nonatomic , assign) CMTime beganDuration;

@property (nonatomic , assign) CMTime duration;

@property (nonatomic , assign) CGFloat scale;


@end

NS_ASSUME_NONNULL_END
