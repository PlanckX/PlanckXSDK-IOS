#  PlanckXSDK-IOS

### What is PlanckXSDK-IOS？

> Welcome to the PlanckX Studio SDK！
>
> The PlanckX Studio SDK contains the basic SDK tools. You can embed the SDK into your game creation to support the mint and issuance of NFT (Non-fungible-token) assets in your game creation, Match the PlanckX platform account with your game account, And link the NFT assets holder（Usually the player who bought the NFT） by the asset owner to the game for use.

### How to use in my project？

> pod 'PlanckXSDK-iOS'

### How to use? 

```objective-c
#import "SWPlanckXManager.h"
or
#import <SWPlanckXManager.h>

// init SDK
[[SWPlanckXManager shared] initWithApiKey:apiKey secreKey:secreKey];

// judge player's bind status
[[SWPlanckXManager shared] judgeBindStatus:playerId completeBlock:^(NSDictionary * _Nonnull response) {
    
}];

// query game‘s NFTs
[[SWPlanckXManager shared] queryGamesNFTs:^(NSDictionary * _Nonnull response) {
    
}];

// query player’s NFTs
[[SWPlanckXManager shared] queryPlayersNFTs:playerId completeBlock:^(NSDictionary * _Nonnull response) {
    
}];

// query specified NFT
[[SWPlanckXManager shared] queryNFT:NFTTokenId completeBlock:^(NSDictionary * _Nonnull response) {
    
}];
```

