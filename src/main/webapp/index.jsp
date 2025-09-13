<%
    // pagina inicial que so redireciona para a lista de livros
    // quando alguem acessa a raiz do site (ex: localhost:8080/catalogo/), vem aqui
    // e automaticamente eh redirecionado para /livros
    response.sendRedirect("livros");
%>
<!--
    arquivo index.jsp - pagina inicial do sistema

    esta pagina nao mostra nada pro usuario, so faz um redirect automatico
    eh como ter uma placa dizendo "va para a lista de livros"

    util porque:
    - define uma pagina padrao quando acessam o site
    - evita ter que lembrar da URL completa
    - centraliza a navegacao inicial
-->