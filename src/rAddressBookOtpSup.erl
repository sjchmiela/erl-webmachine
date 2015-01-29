%%%-------------------------------------------------------------------
%%% @author sjchmiela
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. gru 2014 10:14
%%%-------------------------------------------------------------------
-module(rAddressBookOtpSup).
-author("sjchmiela").
-version('1.0').
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
  {ok, Pid} = supervisor:start_link({local, rAddressBookOtpSup}, rAddressBookOtpSup, []),
  {ok, Pid}.
init(_InitValue) ->
  io:format("Supervisor started (~w) ~n",[self()]),
  RestartStrategy = {simple_one_for_one, 10, 60},
  ChildSpec = {rAddressBookOtp, {rAddressBookOtp, start_link, []},
    permanent, brutal_kill, worker, [rAddressBookOtp]},
  Children = [ChildSpec],
  {ok, {RestartStrategy, Children}}.