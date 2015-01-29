-module(mydemo_ab_add_email).
-export([
    init/1,
    to_html/2
]).

-include_lib("webmachine/include/webmachine.hrl").

-spec init(list()) -> {ok, term()}.
init([]) ->
    {ok, undefined}.

-spec to_html(wrq:reqdata(), term()) -> {iodata(), wrq:reqdata(), term()}.
to_html(ReqData, State) ->
	CallState = gen_server:call(ab, {
		addEmail, 
		[wrq:get_qs_value("name", ReqData),
		wrq:get_qs_value("surname", ReqData),
		wrq:get_qs_value("email", ReqData)]
	}),
	Body = io_lib:format("<html><body>Added new record (~s)! <a href=list>List</a></body></html>", [CallState]),
    {Body, ReqData, State}.

