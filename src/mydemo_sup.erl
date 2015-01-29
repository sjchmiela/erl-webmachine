-module(mydemo_sup).
-behaviour(supervisor).

%% External exports
-export([
  start_link/0
]).

%% supervisor callbacks
-export([init/1]).

start_link() ->
	rAddressBookOtpSup:start_link(),
	{ok, ChildPid} = supervisor:start_child(rAddressBookOtpSup, []),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Web = {webmachine_mochiweb,
           {webmachine_mochiweb, start, [mydemo_config:web_config()]},
           permanent, 5000, worker, [mochiweb_socket_server]},
    Processes = [Web],
    {ok, { {one_for_one, 10, 10}, Processes} }.
