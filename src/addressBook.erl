%%%-------------------------------------------------------------------
%%% @author sjchmiela
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. lis 2014 10:14
%%%-------------------------------------------------------------------
-module(addressBook).
-author("sjchmiela").

-record(ns, {name, surname}).
-record(ci, {companyName, job}).
-record(contact, {ns, company, phone = [], email =  []}).

%% API
-export([createAddressBook/0]).
-export([addContact/3]).
-export([addEmail/4]).
-export([addPhone/4]).
-export([removeContact/3]).
-export([removeEmail/4]).
-export([getEmails/3]).
-export([getPhones/3]).
-export([findByEmail/2]).
-export([findByPhone/2]).
-export([filterByCompany/2]).
-export([setCompany/4]).
-export([setJob/4]).

createAddressBook() -> [].

addContact(NewName, NewSurname, AB) ->
  case lists:keymember(#ns{name = NewName, surname = NewSurname}, 2, AB) of
    false -> [#contact{ns = #ns{name = NewName, surname = NewSurname} } ] ++ AB;
    true -> AB
  end.

addToUndefinedList(List, ToAdd) ->
  case List == undefined of
    false -> List ++ [ToAdd];
    true -> [ToAdd]
  end.

addEmail(Name, Surname, Email, AB) ->
  case lists:keymember(#ns{name = Name, surname = Surname}, 2, AB) of % czy mamy (imię, nazwisko)
    false ->
      case findByEmail(Email, AB) of % czy mamy (email)
        false -> [#contact{ns = #ns{name = Name, surname = Surname}, email = [Email]}] ++ AB; % czysto
        _ -> AB % ktoś już ma taki email
       end;
    true ->
      case findByEmail(Email, AB) of
        false -> {value, Contact} = lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB),
          NewContact = Contact#contact{email = addToUndefinedList(Contact#contact.email, Email)},
          lists:keyreplace(#ns{name = Name, surname = Surname}, 2, AB, NewContact); % dopisujemy email kontaktowi
        _ -> AB % ktoś ma takiego maila
      end
  end.

addPhone(Name, Surname, Phone, AB) ->
  case lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB) of
    false ->
      [#contact{ns = #ns{name = Name, surname = Surname}, phone = [Phone]}] ++ AB;
    {value, Contact} ->
      NewContact = Contact#contact{phone = addToUndefinedList(Contact#contact.phone, Phone)},
      lists:keyreplace(#ns{name = Name, surname = Surname}, 2, AB, NewContact)
  end.

removeContact(Name, Surname, AB) -> lists:keydelete(#ns{name = Name, surname = Surname}, 2, AB).

removeEmail(Name, Surname, Email, AB) ->
  case lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB) of
    {value, Contact} -> NewContact = Contact#contact{email = lists:delete(Email,Contact#contact.email)},
    lists:keyreplace(#ns{name = Name, surname = Surname}, 2, AB, NewContact);
    false -> AB
  end.

getEmails(Name, Surname, AB) ->
  case lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB) of
    {value, Contact} -> Contact#contact.email;
    false -> []
  end.

getPhones(Name, Surname, AB) ->
  case lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB) of
    {value, Contact} -> Contact#contact.phone;
    false -> []
  end.

findByEmail(Email, [H|T]) ->
  case lists:member(Email, H#contact.email) of
    false -> findByEmail(Email, T);
    true -> H#contact.ns
  end;
findByEmail(_, []) -> false.

findByPhone(Phone, [H|T]) ->
  case lists:member(Phone, H#contact.phone) of
    false -> findByPhone(Phone, T);
    true -> H#contact.ns
  end;
findByPhone(_, []) -> false.

filterByCompany(Company, AB) ->
  lists:filter(fun(X) -> ((X#contact.company) /= undefined ) andalso ((X#contact.company)#ci.companyName == Company) end, AB).

setCompany(Name, Surname, Company, AB) ->
  case lists:keymember(#ns{name = Name, surname = Surname}, 2, AB) of
    false ->
      [#contact{ns = #ns{name = Name, surname = Surname}, company = #ci{companyName = Company}}] ++ AB;
    true ->
      {value, Contact} = lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB),
      NewContact = case Contact#contact.company /= undefined of
        true -> Contact#contact{company = Contact#contact.company#ci{companyName = Company}};
        false -> Contact#contact{company = #ci{companyName = Company}}
      end,
      lists:keyreplace(#ns{name = Name, surname = Surname}, 2, AB, NewContact)
  end.

setJob(Name, Surname, Job, AB) ->
  case lists:keymember(#ns{name = Name, surname = Surname}, 2, AB) of
    false ->
      [#contact{ns = #ns{name = Name, surname = Surname}, company = #ci{job = Job}}] ++ AB;
    true ->
      {value, Contact} = lists:keysearch(#ns{name = Name, surname = Surname}, 2, AB),
      NewContact = case Contact#contact.company /= undefined of
        true -> Contact#contact{company = Contact#contact.company#ci{job = Job}};
        false -> Contact#contact{company = #ci{job = Job}}
      end,
      lists:keyreplace(#ns{name = Name, surname = Surname}, 2, AB, NewContact)
  end.