-module(mydemo_ab_find_by_email).
-export([
    init/1,
    to_html/2
]).

-record(ns, {name, surname}).
-include_lib("webmachine/include/webmachine.hrl").

-spec init(list()) -> {ok, term()}.
init([]) ->
    {ok, undefined}.

-spec to_html(wrq:reqdata(), term()) -> {iodata(), wrq:reqdata(), term()}.
to_html(ReqData, State) ->
	[{email, Email}] = wrq:path_info(ReqData),
	Contact = gen_server:call(ab, {findByEmail, [Email]}),
	Body = io_lib:format("<html><body>The contact is ~s ~s.</body></html>", [Contact#ns.name, Contact#ns.surname]),
    {Body, ReqData, State}.

