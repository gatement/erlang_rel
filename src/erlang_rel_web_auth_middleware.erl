-module(erlang_rel_web_auth_middleware).
-include("erlang_rel.hrl").

-export([execute/2]).
-define(APP, erlang_rel).

%% ===================================================================
%% API Function Definitions
%% ===================================================================
execute(Req, Env) ->
    case is_authorized(Req) of
        {true, _User, Req2} ->
            {ok, Req2, Env};
        {false, AuthHeader, Req2} ->
            Req3 = cowboy_req:reply(401, [AuthHeader], <<"Unauthorized">>, Req2),
            {stop, Req3}
    end.

%% ===================================================================
%% Internal Function Definitions
%% ===================================================================
is_authorized(Req) ->
    {ok, Username} = application:get_env(?CURRENT_APP_NAME, web_username),
    {ok, Password} = application:get_env(?CURRENT_APP_NAME, web_password),

    case cowboy_req:parse_header(<<"authorization">>, Req) of
        {ok, {<<"basic">>, {Username, Password}}, Req2} ->
            {true, Username, Req2};
        {_, _, Req2} ->
            AuthHeader = {<<"WWW-Authenticate">>, <<"Basic realm=\"no permition on access\"">>},
            {false, AuthHeader, Req2}
    end.
