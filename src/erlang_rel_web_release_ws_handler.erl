-module(erlang_rel_web_release_ws_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3
         ,websocket_init/3
         ,websocket_handle/3
         ,websocket_info/3
         ,websocket_terminate/3]).

%% ===================================================================
%% API Function Definitions
%% ===================================================================
init({ssl, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(ssl, Req, _Opts) ->
    {ok, Req, undefined_state}.

websocket_handle({text, Msg}, Req, State) ->
    Tokens = string:tokens(erlang:binary_to_list(Msg), "|"),
    [Cmd|RestParam] = Tokens,
    Result = case Cmd of
                 "which_releases" ->
                     handle_which_releases(RestParam);
                 "unpack_release" ->
                     handle_unpack_release(RestParam);
                 "install_release" ->
                     handle_install_release(RestParam);
                 "remove_release" ->
                     handle_remove_release(RestParam);
                 "make_permanent" ->
                     handle_make_permanent(RestParam);
                 "reboot" ->
                     handle_reboot(RestParam);
                 "shutdown" ->
                     handle_shutdown(RestParam);
                 _ ->
                     <<"unknown command">>
             end,
    {reply, {text, << "msg|", Result/binary >>}, Req, State};
websocket_handle(_Data, Req, State) ->
    {ok, Req, State}.

websocket_info(_Info, Req, State) ->
    {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.

%% ===================================================================
%% Handler Functions
%% ===================================================================
handle_which_releases(_) ->
    Releases = release_handler:which_releases(),

    Fun = fun({_Name, Vsn, _Apps, Status}) -> {Vsn, Status} end,
    Releases2 = lists:map(Fun, Releases),

    erlang:list_to_binary(io_lib:format("~p", [Releases2])).

handle_unpack_release([ReleaseName]) ->
    Result = release_handler:unpack_release(ReleaseName),
    erlang:list_to_binary(io_lib:format("~p", [Result])).

handle_install_release([Vsn]) ->
    Result = release_handler:install_release(Vsn),
    erlang:list_to_binary(io_lib:format("~p", [Result])).

handle_remove_release([Vsn]) ->
    Result = release_handler:remove_release(Vsn),
    erlang:list_to_binary(io_lib:format("~p", [Result])).

handle_make_permanent([Vsn]) ->
    Result = release_handler:make_permanent(Vsn),
    erlang:list_to_binary(io_lib:format("~p", [Result])).

handle_reboot(_) ->
    Result = init:reboot(),
    erlang:list_to_binary(io_lib:format("~p", [Result])).

handle_shutdown(_) ->
    Result = init:stop(),
    erlang:list_to_binary(io_lib:format("~p", [Result])).

%% ===================================================================
%% Internal Function Definitions
%% ===================================================================
