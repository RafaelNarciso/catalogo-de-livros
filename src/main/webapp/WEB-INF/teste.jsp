<%@ page contentType="text/html;charset=UTF-8" %>
<html><body>
<h2>Teste de Classes</h2>
<%
    // pagina de debug para verificar se as classes estao sendo carregadas corretamente
    // util para debugar problemas de classpath ou compilacao
    try {
        // tenta carregar cada classe do projeto
        // se der erro, significa que a classe nao foi compilada ou nao ta no classpath

        Class.forName("com.catalogo.servlet.LivroServlet");
        out.println("<p>✓ LivroServlet encontrado</p>");

        Class.forName("com.catalogo.model.Livro");
        out.println("<p>✓ Livro encontrado</p>");

        Class.forName("com.catalogo.dao.LivroDAO");
        out.println("<p>✓ LivroDAO encontrado</p>");

        Class.forName("com.catalogo.util.ConexaoBD");
        out.println("<p>✓ ConexaoBD encontrado</p>");

    } catch (ClassNotFoundException e) {
        // se alguma classe nao for encontrada, mostra o erro
        out.println("<p>✗ Erro: " + e.getMessage() + "</p>");
    }
%>
</body></html>