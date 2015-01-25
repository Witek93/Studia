-module(html_builder).
-author(witek).

-export([build/2, build/3, build/4, buildHtml/2, parseMany/1, buildDiv/2,
         buildForm/2, buildHead/3]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy znacznik HTML okreslonego języka
buildHtml(Lang, Content) ->
    "<html lang=\"" ++ Lang ++ "\">\r\n" ++ Content ++ "</html>\r\n".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parsuje wiele elementów do pojedynczej listy
parseMany(ListOfContents) -> lists:flatten(ListOfContents).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
build([], Content) -> Content;
build([HtmlTag|Tags], Content) ->
    Tag = atom_to_list(HtmlTag),
    "<" ++ Tag ++ ">\r\n" ++ build(Tags, Content) ++ "</" ++ Tag ++ ">\r\n";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy nowy znacznik HTML
build(HtmlTag, Content) ->
    Tag = atom_to_list(HtmlTag),
    "<" ++ Tag ++ ">\r\n" ++ Content ++ "</" ++ Tag ++ ">\r\n".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy pole tekstowe formularza
build(textarea, Name, required) ->
    "<textarea name=\"" ++ Name ++ "\" required></textarea>\r\n";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy przyciski formularza
build(button, Type, Content) ->
    "<button type=\"" ++ Type ++ "\">" ++ Content ++ "</button>\r\n";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy hiperłącze
build(link, Link, Content) ->
    "<a href=\"" ++ Link ++ "\">" ++ Content ++ "</a>\r\n";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy nowy znacznik HTML i nadaje mu konkretne Id
build(HtmlTag, Id, Content) ->
    Tag = atom_to_list(HtmlTag),
    "<" ++ Tag ++ " id=\"" ++ Id ++ "\">\r\n" ++ Content ++ "</" ++ Tag ++ ">\r\n".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy wymagany znacznik formularza o podanym typie i nazwie
build(input, Type, Name, required) ->
    "<input type=\"" ++ Type ++ "\"" ++ " name=\"" ++ Name ++
    "\" required/>\r\n";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy niewymagany znacznik formularza typu "tel" wraz z odpowiednim wzorcem
build(input, tel, Name, Pattern) ->
    "<input type=\"tel\"" ++ " name=\"" ++ Name ++
    "\" pattern=\"" ++ Pattern ++ "\" />\r\n".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzymy <div>
% istnienie tej funkcji jest spowodowane tym, że atom 'div' jest zarezerwowany
buildDiv(Id, Content) ->
    "<div id=\"" ++ Id ++ "\">\r\n" ++ Content ++ "</div>\r\n".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy formularz dowolnej metody z daną zawartością pól
buildForm(Method, Content) ->
    "<form action=\"\" method=\"" ++ Method ++ "\">\r\n" ++ Content ++ "</form>\r\n".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tworzy znacznik HEAD i pozwala na zmianę nazwy strony, nazwy pliku CSS oraz
% wykorzystania nowego zestawu znaków
buildHead(Charset, Stylesheet, Title) ->
    Head = ["<meta charset=\"" ++ Charset ++ "\">\r\n",
            "<link rel=\"stylesheet\" type=\"text/css\" href=\"" ++ Stylesheet ++ "\"/>\r\n",
            build(title, Title)],
    build(head, parseMany(Head)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
