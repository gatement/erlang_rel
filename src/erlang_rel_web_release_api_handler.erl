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
    {ok, Headers, Req2} = cowboy_req:part(Req),
    {ok, Data, Req3} = cowboy_req:part_body(Req2),
    {file, <<"inputfile">>, Filename, _ContentType, _TE} = cow_multipart:form_data(Headers),
    FilenameStr = erlang:binary_to_list(Filename),
    %% Filename starts with ".tar.gz"
    EndsWithExt = string:str(FilenameStr, ".tar.gz") == erlang:length(FilenameStr) - 6,
    case EndsWithExt of
        true -> 
            Path = io_lib:format("~s/../releases/~s", [code:lib_dir(), FilenameStr]),
            file:write_file(Path, Data),
            cowboy_req:reply(200, [{<<"content-type">>, <<"text/plain">>}], <<"Succeeded.">>, Req3);
        _ ->
            cowboy_req:reply(400, [{<<"content-type">>, <<"text/plain">>}], <<"File must be with extension \".tar.gz\".">>, Req3)
    end.
