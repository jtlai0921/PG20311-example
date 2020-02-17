//
//  ObjectPool.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "ObjectPool.h"

// 物件儲存池類別
@implementation HPObjectPool

// 初始化
-(id)initWithClass:(Class)class {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		objectClass=class;
		activeObjects=[[NSMutableArray alloc] init];
		freeObjects=[[NSMutableArray alloc] init];
	}
	return self;
}

// 拋棄
-(void)dealloc {
	[activeObjects release];
	[freeObjects release];
	[super dealloc];
}

// 動態物件的追加
-(id)addObject {
	id obj;
	
	// 沒有自由物件的話，就製作新的實體
	if ([freeObjects count]==0) {
		obj=[[[objectClass alloc] init] autorelease];
		[activeObjects addObject:obj];
	} else 
	
	// 有自由物件的話，就用現成的實體
	{
		obj=[freeObjects lastObject];
		[activeObjects addObject:obj];
		[freeObjects removeLastObject];
	}
	return obj;
}

// 動態物件的刪除
-(void)removeObjectAtIndex:(NSUInteger)index {
	
	// 將動態物件變更為自由物件
	id obj=[activeObjects objectAtIndex:index];
	[freeObjects addObject:obj];
	[activeObjects removeObjectAtIndex:index];
}

// 動態物件的取得
-(id)objectAtIndex:(NSUInteger)index {
	return [activeObjects objectAtIndex:index];
}

// 動態物件的個數
-(NSUInteger)objectCount {
	return [activeObjects count];
}

@end

