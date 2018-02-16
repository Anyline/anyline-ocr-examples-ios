//
//  NSArray+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ALExamplesAdditions)

- (nullable id)first:(BOOL(^ _Nonnull)(id _Nonnull object))function;

- (nonnull NSArray *)map:(id _Nonnull(^ _Nonnull)(id _Nonnull object))function;

- (nonnull NSArray *)mapWithIndex:(id _Nonnull(^ _Nonnull)(id _Nonnull object, NSUInteger index))function;

- (NSUInteger)indexOfFirst:(BOOL(^ _Nonnull)(id _Nonnull object))function;
    
@end
