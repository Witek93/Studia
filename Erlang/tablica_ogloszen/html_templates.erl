-module(html_templates).
-author(witek).

-include("records.hrl").

-export([page/1, site/1, site/2, navigationAdsLinks/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% szablony stron, które bedziemy wyświetlać %%%%%%%%%%%%%%%%%%%
site(Name) ->
    Directory = "priv/www",
    FilePath = Directory ++ "/" ++ atom_to_list(Name) ++ ".html",
    case true of %TODO: change to "database:hasChanged()"
        true  ->
            Page = lists:flatten(page(Name)),
            file:make_dir(Directory),
            file:write_file(FilePath, Page);
        false ->
            {ok, Page} = file:read_file(FilePath)
    end,
    Page.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
site(maybeAd, UniqueId) ->
    lists:flatten(page(UniqueId)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
page(form) ->
    buildSite(buildBasicHead("Formularz"), buildBody(formArticle()));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
page(wrong) ->
    Wrong = html_builder:build(p, "Taka strona nie istnieje"),
    buildSite(buildBasicHead("Taka strona nie istnieje"), buildBody(Wrong));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
page(UniqueId) ->
    case database:isAd(UniqueId) of
        false -> page(wrong);
        true ->
            Ad = buildAd(UniqueId),
            buildSite(buildBasicHead(UniqueId), buildBody(Ad))
    end.
%%%%%%%%%%%%%%%%%% szablony stron, które bedziemy wyświetlać %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% trzon nowej strony html %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buildSite(Head, Body) ->
    Doctype = "<!DOCTYPE html>\r\n",
    HTML = html_builder:parseMany([Head, Body]),
    html_builder:parseMany([Doctype, html_builder:buildHtml("pl", HTML)]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buildBasicHead(Title) -> html_builder:buildHead("utf-8", "style.css", Title).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buildBody(Content) ->
    BodyContent = [buildNavigation(),
                   Content],
    Body = html_builder:buildDiv("top", html_builder:parseMany(BodyContent)),
    html_builder:build(body, Body).
%%%%%%%%%%%%%%%%%%%%%%%%% trzon nowej strony html %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% budowanie nawigacji dla naszej strony %%%%%%%%%%%%%%%%%%%%%%%
buildNavigation() ->
    Nav = [html_builder:build([header, h1], "Menu strony"),
           html_builder:build(ul, navigationBasicLinks()),
           html_builder:build([header, h1], "Ogloszenia"),
           html_builder:build(ul, navigationAdsLinks())
          ],
    html_builder:build(nav, "menu", html_builder:parseMany(Nav)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
navigationBasicLinks() ->
    Link = html_builder:build(link, "/create", "Nowe ogloszenie"),
    html_builder:build(li, Link).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
navigationAdsLinks() ->
    Ads = database:getAll(), %getFromMnesia(), %TODO make it real
    Links = lists:map(fun makeAdLink/1, Ads),
    html_builder:parseMany(Links).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeAdLink(Ad) ->
    Title = Ad#ogloszenia.title,
    Path = Ad#ogloszenia.uniqueId,
    Link = html_builder:build(link, integer_to_list(Path), Title),
    html_builder:build(li, Link).
%%%%%%%%%%%%%%%%%% budowanie nawigacji dla naszej strony %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% budowanie formularza %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
formArticle() ->
    Form = [html_builder:build(legend, "Dodanie ogloszenia"),
            html_builder:build(p, "Imie: " ++
                html_builder:build(input, "text", "firstName", required)),
            html_builder:build(p, "Nazwisko: " ++
                html_builder:build(input, "text", "lastName", required)),
            html_builder:build(p, "Telefon: " ++
                html_builder:build(input, tel, "phoneNumber",
                 "^([0-9]{3} [0-9]{3} [0-9]{3})|([0-9]{9})$")),
            html_builder:build(p, "Email: " ++
                html_builder:build(input, "email", "email", required)),
            html_builder:build(p, "Tytul ogloszenia: " ++
                html_builder:build(input, "text", "title", required)),
            html_builder:build(p, "Tekst ogloszenia:<br> " ++
                     html_builder:build(textarea, "advertisement", required)),
            html_builder:build(p,
                html_builder:build(button, "submit", "Dodaj") ++
                html_builder:build(button, "reset", "Resetuj"))],

    Article = [html_builder:build([header, h1], "Tablica ogloszen\r\n"),
               html_builder:build(fieldset, html_builder:parseMany(Form))],

    PostForm = html_builder:build(article, "tresc", html_builder:parseMany(Article)),

    html_builder:buildForm("post", PostForm).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% budowanie formularza %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% budowanie ogłoszenia %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buildAd(Id) ->
    [Ad] = database:getByIdStr(Id),
    Ogloszenie = [html_builder:build(p, "title", Ad#ogloszenia.title),
        html_builder:build(p, "firstName", Ad#ogloszenia.firstName),
        html_builder:build(p, "lastName", Ad#ogloszenia.lastName),
        html_builder:build(p, "email", Ad#ogloszenia.email),
        html_builder:build(p, "phoneNumber", Ad#ogloszenia.phoneNumber),
        html_builder:build(p, "advertisement", Ad#ogloszenia.advertisement)
        ],
    AdDiv = html_builder:buildDiv("ogloszenie", html_builder:parseMany(Ogloszenie)),
    html_builder:build(article, "tresc", AdDiv).
%%%%%%%%%%%%%%%%%%%%%%%%% budowanie ogłoszenia %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
