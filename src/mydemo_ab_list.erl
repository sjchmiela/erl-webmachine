-module(mydemo_ab_list).
-export([
    init/1,
    to_html/2
]).
-record(ns, {name, surname}).
-record(ci, {companyName, job}).
-record(contact, {ns, company, phone = [], email =  []}).

-include_lib("webmachine/include/webmachine.hrl").

-spec init(list()) -> {ok, term()}.
init(Args) ->
    {ok, Args}.

-spec to_html(wrq:reqdata(), term()) -> {iodata(), wrq:reqdata(), term()}.
to_html(ReqData, State) ->
	AB = gen_server:call(ab, {getContacts}),
	Body = io_lib:format("<html><body><h1>Address Book</h1><ul>~s</ul></body></html>", [ab_to_text(AB)]),
    {Body, ReqData, State}.

ab_to_text([H|T]) ->
	"<li>" ++ H#contact.ns#ns.name ++ " " ++ 
	H#contact.ns#ns.surname ++ " ("++ lists:foldl(fun(X, Str) -> X ++ ", " ++ Str end, "", H#contact.email) ++ ")</li>" ++ ab_to_text(T);
ab_to_text([]) -> "".
