-module(path_parser).
-author(witek).

-include("records.hrl").

-export([getContent/1, getPath/1, parsePost/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pobieramy ścieżkę z przesłanego łancucha, np.
%   getPath("/a")         == "a"
%   getPath("/a?b=c")     == "a"
%   getPath("/a?b=c&d=e") == "a"
getPath(Input) ->
    case string:tokens(Input, "/") of
        [] -> "";
        [FullPath] ->
            [Path | _]  = string:tokens(FullPath, "?"),
            Path;
        TokenizedInput ->
            Destination = lists:last(TokenizedInput),
            ExpectedSites = ["style.css"],
            case lists:member(Destination, ExpectedSites) of
                true -> Destination;
                _ -> ""
            end
        end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pobieramy zawartość metody GET z przesłanego łancucha i odpowiednio parsujemy,
%   np. getPath("/a?")        == []
%       getPath("/a?b=c")     == [{"b", "c"}]
%       getPath("/a?b=c&d=e") == [{"b", "c"}, {"d", "e"}]
getContent(Input) ->
    case string:tokens(Input, "?") of
        [_, ContentLine] ->
            ContentRaw = string:tokens(ContentLine, "&"),
            pairs(ContentRaw);
        _ -> []
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% post content parsers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parsePost(Input) ->
    io:format("~p~n", [Input]),
    ContentLine = string:tokens(Input, "&"),
    [{_, FirstName},
     {_, LastName},
     {_, PhoneNumber},
     {_, Email},
     {_, Title},
     {_, Advertisement}
    ] = pairs(ContentLine),
    io:format("~p ~p ~n", [Title, Email]),
    database:insert(parsePostSigns(Title),    parsePostSigns(FirstName),
                    parsePostSigns(LastName), parsePostSigns(PhoneNumber),
                    parsePostSigns(Email),    parsePostSigns(Advertisement)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parsePostSigns(Input) ->
    Result  = re:replace(Input, "\\+", " ", [global, {return, list}]),
    Result2 = re:replace(Result, "\\%40", "@", [global, {return, list}]),
    re:replace(Result2, "\\%0D\\%0A", "<br>", [global, {return, list}]).
%%%%%%%%%%%%%%%%%%%%%%%%% post content parsers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pairs(List) -> pairs(List, []).
% zamienamy tekst typu "a=b" na krotkę: {"a", "b"}
pairs([], Acc) -> Acc;
pairs([Head|Tail], Acc) ->
    [Key, Value] = string:tokens(Head, "="),
    pairs(Tail, Acc ++ [{Key, Value}]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
