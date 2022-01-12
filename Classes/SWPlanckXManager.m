//
//  SWPlanckXManager.m
//  Foo
//
//  Created by apple on 2021/11/10.
//

#import "SWPlanckXManager.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "base64.h"

static NSString *judgeBindStatusUrl =       @"https://api.planckx.io/v1/api/sdk/checkBind";
static NSString *getGamesAllNFTsURL =       @"https://api.planckx.io/v1/api/sdk/NFT/list";
static NSString *getPlayersAllNFTsURL =     @"https://api.planckx.io/v1/api/sdk/NFT/player/list";
static NSString *getNFTURL =                @"https://api.planckx.io/v1/api/sdk/NFT/token";

static SWPlanckXManager *manager = nil;

@interface SWPlanckXManager ()

@property (nonatomic, copy) NSString *apiKey;

@property (nonatomic, copy) NSString *secreKey;

@end

@implementation SWPlanckXManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SWPlanckXManager alloc] init];
    });
    
    return manager;
}

- (void)initWithApiKey:(NSString *)apiKey secreKey:(NSString *)secreKey {
    
    self.apiKey = apiKey;
    self.secreKey = secreKey;
}

- (void)judgeBindStatus:(NSString *)playerId
          completeBlock:(void (^)(NSDictionary *response))completeBlock {

    [self requestWithUrlStr:[NSString stringWithFormat:@"%@/%@", judgeBindStatusUrl, playerId] HTTPMethod:@"GET" para:nil completeBlock:^(NSDictionary *response) {
        if (completeBlock) {
            completeBlock(response);
        }
    }];
}

- (void)queryGamesNFTs:(void (^)(NSDictionary * _Nonnull))completeBlock {
    
    [self requestWithUrlStr:getGamesAllNFTsURL HTTPMethod:@"GET" para:nil completeBlock:^(NSDictionary *response) {
        if (completeBlock) {
            completeBlock(response);
        }
    }];
}

- (void)queryPlayersNFTs:(NSString *)playerId completeBlock:(void (^)(NSDictionary * _Nonnull))completeBlock {
    
    [self requestWithUrlStr:[NSString stringWithFormat:@"%@/%@", getPlayersAllNFTsURL, playerId] HTTPMethod:@"GET" para:nil completeBlock:^(NSDictionary *response) {
        if (completeBlock) {
            completeBlock(response);
        }
    }];
}

- (void)queryNFT:(NSString *)tokenId completeBlock:(void (^)(NSDictionary * _Nonnull))completeBlock {
    
    [self requestWithUrlStr:[NSString stringWithFormat:@"%@/%@", getNFTURL, tokenId] HTTPMethod:@"GET" para:nil completeBlock:^(NSDictionary *response) {
        if (completeBlock) {
            completeBlock(response);
        }
    }];
}

- (void)requestWithUrlStr:(NSString *)urlStr
               HTTPMethod:(NSString *)HTTPMethod
                     para:(NSDictionary *)para
            completeBlock:(void (^)(NSDictionary *response))completeBlock {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setTimeoutIntervalForRequest:20];
    
    // header
    NSDictionary *headerPara = @{
        @"access_key" : self.apiKey,
        @"timestamp" : [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970] * 1000.0)],
        @"nonce" : [NSUUID UUID].UUIDString,
    };
    NSArray *headerKeys = [headerPara allKeys];
    NSArray *sortedHeaderKeys = [headerKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *sortedHeaderKeyValueStr = [NSString string];
    for (NSString *key in sortedHeaderKeys) {
        sortedHeaderKeyValueStr = [sortedHeaderKeyValueStr stringByAppendingFormat:@"%@=%@&", key, headerPara[key]];
    }
    NSString *sign = [self hmacsha1:sortedHeaderKeyValueStr key:self.secreKey];
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionaryWithDictionary:headerPara];
    headerDic[@"sign"] = sign;
    request.allHTTPHeaderFields = headerDic;
    
    if ([HTTPMethod isEqualToString:@"POST"]) {
        // body
        if (para && para.allKeys.count) {
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted  error:nil];
        }
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"%@", urlStr);
        if (data && data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"%@", dict);
            if (completeBlock) {
                completeBlock(dict);
            }
        } else {
            if (completeBlock) {
                completeBlock(@{
                    
                });
            }
        }
        
    }];
    [task resume];
}

- (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
//    NSLog(@"hmacsha1 started");
//    NSLog(@"original value: %@", text);
//    NSLog(@"secret: %@", secret);
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength,YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
//    NSLog(@"result value: %@", base64EncodedResult);
    return base64EncodedResult;
}



@end
