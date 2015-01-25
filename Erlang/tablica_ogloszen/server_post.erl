-module(server_post).
-export([start/1, stop/0]).

-author(witek).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% obsługa serwera tcp/ip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(Port)->
    % chcemy otrzymać informację, gdy uśmiercamy proces funkcją exit/2 w funkcji
    % stop/0 unikamy w ten sposób zablokowania procesu w powłoce 'erl'
    process_flag(trap_exit, true),

    % tworzymy serwerowe gniazdo nasłuchujące protokół HTTP
    Pid = spawn(fun () ->
        {ok, ListenSock} = gen_tcp:listen(Port, [list, {active, false}, {packet, http}]),
        loop(ListenSock) end),

    % rejestrujemy globalną nazwę serwera
    register(?MODULE, Pid).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stop() ->
    % szukamy id procesu po zarejestrowanej w start/1 nazwie
    case Pid = whereis(?MODULE) of
        undefined -> ok;
        % wykorzystujemy zarejestrowaną nazwę serwera, aby zakończyć proces
        _ -> exit(Pid, kill)
    end.
%%%%%%%%%%%%%%%%%%%%%%%% obsługa serwera tcp/ip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loop(ListenSock) ->
    % akceptujemy zapytanie do gniazda nasłuchującego
    {ok, ClientSocket} = gen_tcp:accept(ListenSock),

    % tworzymy proces, który obsłuży powyższe zapytanie klienta
    spawn(fun() -> request_handler:handle(ClientSocket) end),

    % rekurencyjnie powracamy do nasluchiwania
    loop(ListenSock).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
