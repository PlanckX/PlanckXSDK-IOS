//
//  SWPlanckXManager.h
//  Foo
//
//  Created by apple on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWPlanckXManager : NSObject

+ (instancetype)shared;

- (void)initWithApiKey:(NSString *)apiKey secreKey:(NSString *)secreKey;

- (void)judgeBindStatus:(NSString *)playerId
          completeBlock:(void(^)(NSDictionary *response))completeBlock;

- (void)queryGamesNFTs:(void(^)(NSDictionary *response))completeBlock;

- (void)queryPlayersNFTs:(NSString *)playerId
         completeBlock:(void(^)(NSDictionary *response))completeBlock;

- (void)queryNFT:(NSString *)tokenId
 completeBlock:(void(^)(NSDictionary *response))completeBlock;

@end

NS_ASSUME_NONNULL_END
