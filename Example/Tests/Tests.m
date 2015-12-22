//
//  OSWebViewPreCacheTests.m
//  OSWebViewPreCacheTests
//
//  Created by Olexandr Stepanov on 12/21/2015.
//  Copyright (c) 2015 Olexandr Stepanov. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

SPEC_BEGIN(InitialTests)

describe(@"My initial tests", ^{

  context(@"will pass", ^{
    
      it(@"can do maths", ^{
        [[@1 should] beLessThan:@23];
      });
    
      it(@"can read", ^{
          [[@"team" shouldNot] containString:@"I"];
      });  
  });
  
});

SPEC_END

