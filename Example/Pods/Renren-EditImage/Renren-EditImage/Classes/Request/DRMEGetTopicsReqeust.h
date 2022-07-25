//
//  DRMEGetTopicsReqeust.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import "DRMEBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEGetTopicsReqeust : DRMEBaseGlobalRequest

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) NSInteger page_size;

@end

NS_ASSUME_NONNULL_END
