%%%-------------------------------------------------------------------
%%% @author sjchmiela
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. gru 2014 10:28
%%%-------------------------------------------------------------------
-module(rAddressBookOtp).
-behaviour(gen_server).
-version('1.0').
-author("sjchmiela").

%% API
-export([start_link/0, init/1, handle_call/3, terminate/2]).


start_link() ->
  gen_server:start_link(rAddressBookOtp,[], []).

init(_Value) ->
  register(ab, self()),
  io:format("rab_server started (~w) ~n", [self()]),
  {ok, addressBook:createAddressBook()}.

handle_call({addContact, [Name, Surname]}, _From, AB) ->
  {reply, ok, addressBook:addContact(Name, Surname, AB)};
handle_call({addEmail, [Name, Surname, Email]}, _From, AB) ->
  {reply, ok, addressBook:addEmail(Name, Surname, Email, AB)};
handle_call({addPhone, [Name, Surname, Phone]}, _From, AB) ->
  {reply, ok, addressBook:addPhone(Name, Surname, Phone, AB)};
handle_call({removeContact, [Name, Surname]}, _From, AB) ->
  {reply, ok, addressBook:removeContact(Name, Surname, AB)};
handle_call({removeEmail, [Name, Surname, Email]}, _From, AB) ->
  {reply, ok, addressBook:removeEmail(Name, Surname, Email, AB)};
handle_call({getEmails, [Name, Surname]}, _From, AB) ->
  {reply, addressBook:getEmails(Name, Surname, AB), AB};
handle_call({getPhones, [Name, Surname]}, _From, AB) ->
  {reply, addressBook:getPhones(Name, Surname, AB), AB};
handle_call({findByEmail, [Email]}, _From, AB) ->
  {reply, addressBook:findByEmail(Email, AB), AB};
handle_call({findByPhone, [Email]}, _From, AB) ->
  {reply, addressBook:findByPhone(Email, AB), AB};
handle_call({filterByCompany, [Company]}, _From, AB) ->
  {reply, addressBook:filterByCompany(Company, AB), AB};
handle_call({setCompany, [Name, Surname, Company]}, _From, AB) ->
  {reply, addressBook:setCompany(Name, Surname, Company, AB), AB};
handle_call({setJob, [Name, Surname, Job]}, _From, AB) ->
  {reply, addressBook:setJob(Name, Surname, Job, AB), AB};
handle_call({getContacts}, _From, AB) ->
  {reply, AB, AB};
handle_call(terminate, _From, AB) ->
  {stop, normal, ok, AB}.

terminate(Reason, Value) ->
  io:format("exit with value ~p~n", [Value]),
  Reason.