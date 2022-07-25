//
//  DRUProfileGetInfoRequest.m
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/3.
//

#import "DRUProfileGetInfoRequest.h"

@implementation DRUProfileGetInfoRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.type = DRUProfileInfoTypeGender                  |
                    DRUProfileInfoTypeBirth                   |
                    DRUProfileInfoTypeHometownProvince        |
                    DRUProfileInfoTypeHometownCity            |
                    DRUProfileInfoTypeIsFriend                |
                    DRUProfileInfoTypeVistorCount             |
                    DRUProfileInfoTypeFriendCount             |
                    DRUProfileInfoTypeSignatureWithVoice      |
                    DRUProfileInfoTypeRecentEducationWork     |
//                    DRUProfileInfoTypeWorkplaceInfo           |
//                    DRUProfileInfoTypeSchoolList              |
                    DRUProfileInfoTypeRegion                  |
                    DRUProfileInfoTypeFansCount               |
                    DRUProfileInfoTypePubCount                |
                    DRUProfileInfoTypeUserSignature           |
                    DRUProfileInfoTypeUserBlocked             |
                    DRUProfileInfoTypeIsBanFriend             |
                    DRUProfileInfoTypeRealName                |
                    DRUProfileInfoTypeRealnameAuthStatus      |
                    DRUProfileInfoTypeFissionStep;
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/profile/getInfo");
}

@end
