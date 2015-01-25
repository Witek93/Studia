-module(request_handler).
-author(witek).

-export([handle/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% obsługa zapytania %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle(Sock) ->
    try
        {ok, {Req, Method, Path, _}} = gen_tcp:recv(Sock, 0),
        case (Req) of
            http_request ->
                case (Method) of
                    'POST' ->
                        handle_post(Sock);
                    'GET'  ->
                        handle_get(Sock, Path);
                    _ ->
                        send_unsupported_error(Sock)
                end;
            _ ->
                send_unsupported_error(Sock)
        end
    catch
        Type:What ->
            log(Type, What),
            send_unsupported_error(Sock)
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% obsługa zapytania %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% obsługa zapytania GET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_get(Sock, {abs_path, FullPath}) ->
    try
        Path = path_parser:getPath(FullPath),
        Content = path_parser:getContent(FullPath),
        case Path of
            "create" ->
                Response = parseResponse(html_templates:site(form));
            "style.css" ->
                {ok, Response} = file:read_file("priv/www/style.css");
            "" ->
                Response = parseResponse(html_templates:site(form));
            _ ->
                io:format("~p~n", [Path]),
                Response = parseResponse(html_templates:site(maybeAd, Path))
            end,
            gen_tcp:send(Sock, Response),
            gen_tcp:close(Sock)
    catch
        Type:What ->
            log(Type, What),
            send_baduri_error(Sock)
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%% obsługa zapytania GET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% obsługa zapytania POST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_post(Sock) ->
    Length = get_content_length(Sock),
    PostBody = get_body(Sock, Length),
    path_parser:parsePost(PostBody),
    io:format("POST: ~p~n", [PostBody]),
    Response = parseResponse(html_templates:site(form)),
    gen_tcp:send(Sock, Response),
    gen_tcp:close(Sock).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_content_length(Sock) ->
    case gen_tcp:recv(Sock, 0, 3000) of
        {ok, {http_header, _, 'Content-Length', _, Length}} ->
            list_to_integer(Length);
        {ok, {http_header, _, _, _, _}}  ->
            get_content_length(Sock)
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_body(Sock, Length) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, http_eoh} ->
            inet:setopts(Sock, [{packet, raw}]),
            {ok,Body} = gen_tcp:recv(Sock, Length),
            Body;
        _ -> get_body(Sock, Length)
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%% obsługa zapytania POST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% parsowanie odpowiedzi dla HTTP %%%%%%%%%%%%%%%%%%%%%%%%%
parseResponse(Str) ->
    Bin = iolist_to_binary(Str),
    iolist_to_binary(io_lib:fwrite(
        "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",
        [size(Bin), Bin])).
%%%%%%%%%%%%%%%%%%%%%%% parsowanie odpowiedzi dla HTTP %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% obsługa błędów TCP - odpowiedzi oraz logi %%%%%%%%%%%%%%%%%%%
send_unsupported_error(Sock) ->
    gen_tcp:send(Sock,
        "HTTP/1.1 405 Method Not Allowed\r\nConnection: close\r\n" ++
        "Allow: POST\r\nContent-Type: text/html; charset=UTF-8\r\n" ++
        "Cache-Control: no-cache\r\n\r\n unsupported error occured"),
    gen_tcp:close(Sock).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
send_baduri_error(Sock) ->
    gen_tcp:send(Sock,
        "HTTP/1.1 405 Method Not Allowed\r\nConnection: close\r\n" ++
        "Allow: POST\r\nContent-Type: text/html; charset=UTF-8\r\n" ++
        "Cache-Control: no-cache\r\n\r\n bad URI error occured"),
    gen_tcp:close(Sock).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log(Type, What) ->
    Report = ["web request failed", {type, Type}, {what, What},
        {trace, erlang:get_stacktrace()}],
    error_logger:error_report(Report).
%%%%%%%%%%%%%%%%%% obsługa błędów TCP - odpowiedzi oraz logi %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
