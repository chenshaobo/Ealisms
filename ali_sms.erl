%%%-------------------------------------------------------------------
%%% @author chenshaobo0428
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2016 16:47
%%%-------------------------------------------------------------------
-module(ali_sms).
-author("chenshaobo0428").

%% API
-export([gen_ali_sms_url/4]).
-export([format_date/0]).
-define(DEFAULT_PARAMS,[
    {"method",<<"alibaba.aliqin.fc.sms.num.send">>},
    {"app_key",<<"YOUR KEY">>},
    {"secret","YOUR SECRET"},
    {"v",<<"2.0">>},
    {"sign_method",<<"md5">>},
    {"format",<<"json">>},
    {"sms_type",<<"normal">>}
]).

-define(BASE_URL,"http://gw.api.taobao.com/router/rest?").
%% 传入参数 返回 通过阿里大鱼（get方式)发送短信的完整url

gen_ali_sms_url(PhoneNumber,SMSParam,SignName,TemplateCode)->

    {"secret", SecretKey} = lists:keyfind("secret", 1, ?DEFAULT_PARAMS),

    Params=
    [{"rec_num", to_bin(PhoneNumber)}, {"sms_param", to_bin(SMSParam)},
        {"sms_free_sign_name", to_bin(SignName)}, {"sms_template_code", TemplateCode},
        {"timestamp", to_bin(format_date())}] ++ ?DEFAULT_PARAMS,
    lager:info("~p",[format_date()]),
%%     按照字母排序
    SortList = lists:sort(fun({Key1, _}, {Key2, _}) ->
        Key1 < Key2
    end, Params),
    MD5Source = SecretKey ++ lists:flatten([io_lib:format("~s~s", [Key, Val]) || {Key, Val} <- SortList]) ++ SecretKey,
    SignMd5 = to_bin(string:to_upper(mpr_utils:to_list(mpr_utils:to_md5(MD5Source)))),
%%
    RequestQuery = lists:flatten([io_lib:format("~s=~s&", [Key, http_uri:encode(mpr_utils:to_list(Val))]) || {Key, Val} <- [{"sign", SignMd5} | SortList]]),
    ?BASE_URL ++ RequestQuery.


-define(FILL_ZERO(X) ,case X > 9 of
                         true ->
                             erlang:integer_to_list(X);
                         false ->
                             "0"++ erlang:integer_to_list(X)
                     end).

format_date()->
    {Y,M,D} = erlang:date(),
    {H,Min,S}= time(),
    lists:flatten(io_lib:format("~s-~s-~s ~s:~s:~s", [?FILL_ZERO(Y),?FILL_ZERO(M),?FILL_ZERO(D),?FILL_ZERO(H),?FILL_ZERO(Min),?FILL_ZERO(S)])).

to_bin(Int) when is_integer(Int) ->
    erlang:integer_to_binary(Int);
to_bin(Float) when is_float(Float)->
    erlang:float_to_binary(Float,[{decimals, 2}, compact]);
to_bin(Atom) when is_atom(Atom) ->
    erlang:atom_to_binary(Atom, utf8);
to_bin(List) when is_list(List) ->
    erlang:list_to_binary(List);
to_bin(Binary) when is_binary(Binary) ->
    Binary;
to_bin(_) ->
    erlang:throw(error_type).