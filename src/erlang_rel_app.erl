-module(erlang_rel_app).
-behaviour(application).
-include("erlang_rel.hrl").

%% API
-export([start/0]).
%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowlib),
    application:start(cowboy),
    application:start(erlang_rel).

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/release", cowboy_static, {priv_file, erlang_rel, "web/release/index.html"}},
			{"/release/upload", cowboy_static, {priv_file, erlang_rel, "web/release/upload.html"}},
			{"/ws/release", erlang_rel_web_release_ws_handler, []},
			{"/api/release", erlang_rel_web_release_api_handler, []},
			{"/static/[...]", cowboy_static, {priv_dir, erlang_rel, "web/static"}}
		]}
	]),
    PrivDir = code:priv_dir(?CURRENT_APP_NAME),
    {ok, Port} = application:get_env(web_port),
    {ok, _Pid} = cowboy:start_https(https, 6, [
                        {port, Port},
                        {cacertfile, PrivDir ++ "/ssl/cacert.pem"},
                        {certfile, PrivDir ++ "/ssl/cert.pem"},
                        {keyfile, PrivDir ++ "/ssl/key.pem"}
                    ],
                    [
                        {env, [{dispatch, Dispatch}]},
                        {middlewares, [erlang_rel_web_auth_middleware, cowboy_router, cowboy_handler]}
                    ]),

    erlang_rel_sup:start_link().

stop(_State) ->
    ok.
