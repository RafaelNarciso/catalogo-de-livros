<%@ page contentType="text/html;charset=UTF-8" %>
<html><body>
<h2>Teste de Classes</h2>
<%
    try {
        Class.forName("com.catalogo.servlet.LivroServlet");
        out.println("<p>✓ LivroServlet encontrado</p>");

        Class.forName("com.catalogo.model.Livro");
        out.println("<p>✓ Livro encontrado</p>");

        Class.forName("com.catalogo.dao.LivroDAO");
        out.println("<p>✓ LivroDAO encontrado</p>");

        Class.forName("com.catalogo.util.ConexaoBD");
        out.println("<p>✓ ConexaoBD encontrado</p>");

    } catch (ClassNotFoundException e) {
        out.println("<p>✗ Erro: " + e.getMessage() + "</p>");
    }
%>
</body></html>