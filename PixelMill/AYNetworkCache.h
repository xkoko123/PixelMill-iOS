#import <Foundation/Foundation.h>
// 过期提醒
#define AYDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)


#pragma mark - 网络数据缓存类
@interface AYNetworkCache : NSObject

/**
 *  缓存网络数据,根据请求的 URL与parameters
 *  做KEY存储数据, 这样就能缓存多级页面的数据
 *
 *  @param httpData   服务器返回的数据
 *  @param URL        请求的URL地址
 *  @param parameters 请求的参数
 */
+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 *  根据请求的 URL与parameters 取出缓存数据
 *
 *  @param URL        请求的URL
 *  @param parameters 请求的参数
 *
 *  @return 缓存的服务器数据
 */
+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;


/**
 *  获取网络缓存的总大小 bytes(字节)
 */
+ (NSInteger)getAllHttpCacheSize;


/**
 *  删除所有网络缓存,
 */
+ (void)removeAllHttpCache;


#pragma mark - 过期方法
/**
 *  缓存网络数据(已过期!!!推荐使用:+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters)
 *
 *  @param httpCache 服务器返回的数据
 *  @param key       缓存数据对应的key值,推荐填入请求的URL
 */
+ (void)saveHttpCache:(id)httpCache forKey:(NSString *)key AYDeprecated("该方法已过期,请使用 +(void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters");

/**
 *  取出缓存的数据(已过期!!!推荐使用+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;)
 *
 *  @param key 根据存入时候填入的key值来取出对应的数据
 *
 *  @return 缓存的数据
 */
+ (id)getHttpCacheForKey:(NSString *)key AYDeprecated("该方法已过期,请使用 +(id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;");

@end
