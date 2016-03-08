# Ealisms
阿里大鱼 短信发送接口 alibaba.aliqin.fc.sms.num.send 请求url生成

使用方法
=======
调用接口 前先修改 `ali_sms.erl`里面的 `DEFAULT_PARAM`宏，
```erlang
-define(DEFAULT_PARAMS,[
    {"method",<<"alibaba.aliqin.fc.sms.num.send">>},
    {"app_key",<<"YOUR KEY">>},
    {"secret","YOUR SECRET"},
    {"v",<<"2.0">>},
    {"sign_method",<<"md5">>},
    {"format",<<"json">>},
    {"sms_type",<<"normal">>}
]).
```
修改`app_key` 、`secret`为自己app对应的val。 
