-module(erlang_rel_web_release_api_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

%% ===================================================================
%% API Function Definitions
%% ===================================================================
init(_, Req, _Opts) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req),
    {PathInfo, Req3} = cowboy_req:path_info(Req2),
    {ok, Req4} = case {Method, PathInfo} of
                     {<<"POST">>, [<<"upload">>]} ->
                         handle_upload(Req3);
                     _ ->
                         cowboy_req:reply(404, [{<<"content-type">>, <<"text/plain">>}], <<"Page not found.">>, Req3)
                 end,
    {ok, Req4, State}.

terminate(_Reason, _Req, _State) ->
    ok.

%% ===================================================================
%% Internal Function Definitions
%% ===================================================================
handle_upload(Req) ->
    receive_multipart(Req).

receive_multipart(Req) ->
    %% there is only one part in the request, so only get part once
    {ok, Headers, Req2} = cowboy_req:part(Req), 
    {file, <<"inputfile">>, Filename, _ContentType, _CTransferEncoding} = cow_multipart:form_data(Headers),
    %% receive the whole file
    {Data, Req3} = stream_file(<<>>, Req2),
    %% filename must have file extension ".tar.gz"
    FilenameStr = erlang:binary_to_list(Filename),
    WithRightExt = string:str(FilenameStr, ".tar.gz") == erlang:length(FilenameStr) - 6,
    case WithRightExt of
        true -> 
            Path = io_lib:format("~s/../releases/~s", [code:lib_dir(), FilenameStr]),
            file:write_file(Path, Data),
            cowboy_req:reply(200, [{<<"content-type">>, <<"text/plain">>}], <<"Succeeded.">>, Req3);
        _ ->
            cowboy_req:reply(400, [{<<"content-type">>, <<"text/plain">>}], <<"File must be with extension \".tar.gz\".">>, Req3)
    end.

stream_file(ReceivedData, Req) ->
    case cowboy_req:part_body(Req) of
        {ok, Data, Req2} ->
            {<<ReceivedData/binary, Data/binary>>, Req2};
        {more, Data, Req2} ->
            stream_file(<<ReceivedData/binary, Data/binary>>, Req2)
    end.
