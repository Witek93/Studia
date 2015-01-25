-module(database).
-author(kaska).

-include("records.hrl").

-export([hasChanged/0, start/0, isAd/1, getByIdStr/1, getAll/0, insert/6, getTitle/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzymy nowy schemat i odpowiednią tabelę na nasze rekordy
start() ->
    mnesia:create_schema(node()),
    mnesia:wait_for_tables([ogloszenia], 1000),
    mnesia:start(),
    mnesia:create_table(ogloszenia,
        [{disc_copies, nodes()},
        {attributes, record_info(fields, ogloszenia)}]
        ),

    ets:new(table, [set, named_table]),
    ets:insert(table, {stara_wartosc, 0}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hasChanged() ->
    [{stara_wartosc, StoredSize}] = ets:lookup(table, stara_wartosc),
    CurrentSize = mnesia:table_info(ogloszenia, size),
    case (StoredSize /= CurrentSize) of
    false ->
        false;
    true ->
        ets:insert(table, {stara_wartosc, CurrentSize}),
        true
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isAd(Id) ->
    F = fun() -> case mnesia:read({ogloszenia, list_to_integer(Id)}) of
            [] -> false;
            _ -> true
        end
    end,
    mnesia:activity(transaction, F).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
insert(Title, FirstName, LastName, PhoneNumber, Email, Advertisement) ->
    Record = #ogloszenia{
            uniqueId      = mnesia:table_info(ogloszenia, size) + 1,
            title         = Title,
            firstName     = FirstName,
            lastName      = LastName,
            phoneNumber   = PhoneNumber,
            email         = Email,
            advertisement = Advertisement},
    F = fun()-> mnesia:write(ogloszenia, Record, write)
        end,
    mnesia:transaction(F).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getTitle(Id) ->
    [Ad] = getById(Id),
    Ad#ogloszenia.title.
    %{R#ogloszenia.uniqueId, R#ogloszenia.title}.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getByIdStr(Id) -> getById(list_to_integer(Id)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getById(Id) ->
    F = fun() -> mnesia:read({ogloszenia, Id}) end,
    mnesia:activity(transaction, F).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getAll() ->
    Keys = mnesia:dirty_all_keys(ogloszenia),
    getAll(Keys, []).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getAll([], Acc) -> Acc;
getAll([Key|Keys], Acc) ->
    NewAcc = Acc ++ getById(Key),
    getAll(Keys, NewAcc).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
