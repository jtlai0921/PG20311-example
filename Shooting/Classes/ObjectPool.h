//
//  ObjectPool.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 物件儲存池類別
@interface HPObjectPool : NSObject
{
	// 動態物件
	NSMutableArray* activeObjects;
	
	// 自由物件
	NSMutableArray* freeObjects;
	
	// 物件的類別
	Class objectClass;
}

// 初始化
-(id)initWithClass:(Class)class;

// 拋棄
-(void)dealloc;

// 動態物件的追加
-(id)addObject;

// 動態物件的刪除
-(void)removeObjectAtIndex:(NSUInteger)index;

// 動態物件的取得
-(id)objectAtIndex:(NSUInteger)index;

// 動態物件的個數
-(NSUInteger)objectCount;

@end

