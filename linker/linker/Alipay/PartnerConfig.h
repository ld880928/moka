//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

#define APPScheme @"MOKA"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088211116843513"
//收款支付宝账号
#define SellerID  @"zhifubao@mo-fang.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"ckvqsllqszrqdnych53mf0dvi8j1ugmu"

#define Notif_URL @"http%3A%2F%2Flinker.demo.evebit.com%2Findex.php%2Fap%2Fapi%2Fapipayed"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALY0by9DUBbXrI4y7/tNh+dHJzcoB+szwzNp3n6FXzDORbNEPvaRcxLSk4GHM8e5s+oFGuYh6EaztOdJ+qGwyda4b5jxekYuv1Xl8T6ifiGjoUfLoZuii2d0XtxB7ELsXZ7jJAVfqdVdSOMbw98n+nfT0g0NMEAIugkhfTXdVwQFAgMBAAECgYB7la0kfZ/BHqCoAtzLs5bOxHBQ9RIJ8p4gLVsAri4WyJJ2OYALdjR7O+FZJf91JPxnavcHyU/nRNUbXA5nxaXgnVRm9OvYxm6E7zZJWeUgg4RIFtL+O5FMUGqHAhNmNRPeDx3JQtVAmJrwvi2EDPoTZfjN7d1jrkHxPHsAjjGJsQJBANkljOhMkw8avn8+lCRoIufM8js0+lclBFmYwtRRJ932Ve3PEFS2xZheH5c+mRiRelyiUCfxwS/Ey3MMxbPSzhsCQQDWzl1YecFM+2UgX4xt7GDFheYNN1GHY3w6IfKQE7iTAp9NrRdRID0X8RdFOjt45zPgZB9b/8JkLcBZ5Tmg/hhfAkB2rJAC0P66DYq47hF2iDczag2kkAKVJ9TlxpgMA0J/i0ZRDo5FThJVgHNRbFOtWqx9/fNCsVw8aBgsi3ltGrOrAkA08LdgzuEtL+hEikf574AKLm38Y93cGFDNowA9Mh8TXFoWsspEXEWyWOD7VtbBfXnzm7l+2xH1zrDRdwU1AGrRAkBjZ4hit/aay1xzSRaVuXEXVPSlswrlP75hIzMyy/bh6agwcZa+r+VtEG+KtuW/lylv7lvWa+xfTgNK+QEKyT1U"


//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC2NG8vQ1AW16yOMu/7TYfnRyc3KAfrM8Mzad5+hV8wzkWzRD72kXMS0pOBhzPHubPqBRrmIehGs7TnSfqhsMnWuG+Y8XpGLr9V5fE+on4ho6FHy6GbootndF7cQexC7F2e4yQFX6nVXUjjG8PfJ/p309INDTBACLoJIX013VcEBQIDAQAB"

static NSString *kPaySuccessNotification = @"kPaySuccessNotification";

#endif
