
#import <Foundation/Foundation.h>

#define HOST @"192.168.1.1"
#ifndef KMQTTData
#define KMQTTData               @"MQTTData"
#endif
#ifndef KMQTTCMD
#define KMQTTCMD               @"MQTTCMD"
#endif
#ifndef KDeviceID
#define KDeviceID               @"deviceID"
#endif
#ifndef KMQTTPushS00
#define KMQTTPushS00               @"MQTTPushS00"
#endif
#ifndef KMQTTPushSEE
#define KMQTTPushSEE               @"MQTTPushSEE"
#endif

static const int TIMEOUT = 10;
static const int PORT = 2000;


@interface SNDirectConnect : NSObject

/**
 *  连接状态：1已连接，-1未连接，0连接中
 */
@property (nonatomic, assign) NSInteger connectStatus;


/**
 *  获取单例
 *
 *  @return 单例对象
 */
+ (nullable SNDirectConnect *)sharedInstance;

- (void)connectSocketOnHost:(nonnull NSString *)host  onPort:(uint16_t)port success:(void ( ^ _Nonnull )())success failure:(void (^ _Nonnull)( NSError * _Nonnull  ))failure;

/**
 *  向服务器发送数据
 *
 *  @param data 数据
 */
- (BOOL)socketWriteDataWithCmd:(nonnull NSString *)cmd data:(nonnull NSString *)data ;


/**
 *  停止连接,释放资源
 */
- (void)stopDirectConnect;



@end
