-module(erlang_rel_web_release_api_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_, Req, _Opts) ->
	{ok, Req, undefined}.

handle(Req, State) ->
   % {PathInfo, Req2} = cowboy_req:path_info(Req),
   % case {Method, PathInfo} of
   %     {<<"GET">>, [<<"upload">>]} ->

	{ok, Headers, Req2} = cowboy_req:part(Req),
	{ok, Data, Req3} = cowboy_req:part_body(Req2),
	{file, <<"inputfile">>, Filename, ContentType, _TE} = cow_multipart:form_data(Headers),
	io:format("Received file ~p of content-type ~p of length:~p~n", [Filename, ContentType, erlang:size(Data)]),
    Path = io_lib:format("~s/../releases/~s", [code:lib_dir(), erlang:binary_to_list(Filename)]),
    file:write_file(Path, Data),
	{ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
	ok.
