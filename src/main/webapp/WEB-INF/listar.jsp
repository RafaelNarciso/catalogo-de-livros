<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titulo}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .busca-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            gap: 15px;
        }
        .busca-form {
            display: flex;
            gap: 10px;
            flex: 1;
        }
        .busca-form input[type="text"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            text-align: center;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .alert-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .acoes {
            display: flex;
            gap: 5px;
        }
        .sem-dados {
            text-align: center;
            padding: 50px;
            color: #6c757d;
            font-style: italic;
        }
        .info-resultados {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${titulo}</h1>

        <!-- Mensagens de sucesso/erro -->
        <c:if test="${param.sucesso != null}">
            <div class="alert alert-success">
                <c:out value="${param.sucesso}"/>
            </div>
        </c:if>

        <c:if test="${param.erro != null}">
            <div class="alert alert-error">
                <c:out value="${param.erro}"/>
            </div>
        </c:if>

        <!-- Barra de busca e ações -->
        <div class="busca-container">
            <form class="busca-form" action="${pageContext.request.contextPath}/livros" method="get">
                <input type="hidden" name="action" value="buscar">
                <input type="text" name="termo" placeholder="Buscar por título ou autor..."
                        value="${termoBusca}">
                <button type="submit" class="btn btn-secondary">Buscar</button>
                <c:if test="${termoBusca != null}">
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">Limpar</a>
                </c:if>
            </form>

            <a href="${pageContext.request.contextPath}/livros?action=novo"
                class="btn btn-success">Novo Livro</a>
        </div>

        <!-- Informações sobre resultados -->
        <c:if test="${livros != null}">
            <div class="info-resultados">
                <c:choose>
                    <c:when test="${termoBusca != null}">
                        Encontrados ${livros.size()} livro(s) para "<c:out value="${termoBusca}"/>"
                    </c:when>
                    <c:otherwise>
                        Total: ${livros.size()} livro(s) cadastrado(s)
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Tabela de livros -->
        <c:choose>
            <c:when test="${livros != null && livros.size() > 0}">
                <table>
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Autor</th>
                            <th>Ano</th>
                            <th>Gênero</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="livro" items="${livros}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/livros/${livro.id}"
                                        style="text-decoration: none; color: #007bff;">
                                        <c:out value="${livro.titulo}"/>
                                    </a>
                                </td>
                                <td><c:out value="${livro.autor}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${livro.anoPublicacao != null}">
                                            ${livro.anoPublicacao}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${livro.genero != null}">
                                            <c:out value="${livro.genero}"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="acoes">
                                    <a href="${pageContext.request.contextPath}/livros/${livro.id}"
                                        class="btn btn-primary" style="font-size: 12px;">Ver</a>
                                    <a href="${pageContext.request.contextPath}/livros?action=editar&id=${livro.id}"
                                        class="btn btn-secondary" style="font-size: 12px;">Editar</a>
                                    <form style="display: inline;" method="post"
                                        action="${pageContext.request.contextPath}/livros"
                                        onsubmit="return confirm('Tem certeza que deseja excluir este livro?');">
                                        <input type="hidden" name="action" value="excluir">
                                        <input type="hidden" name="id" value="${livro.id}">
                                        <button type="submit" class="btn btn-danger" style="font-size: 12px;">
                                            Excluir
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="sem-dados">
                    <c:choose>
                        <c:when test="${termoBusca != null}">
                            Nenhum livro encontrado para "<c:out value="${termoBusca}"/>".
                            <br><br>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">
                                Ver todos os livros
                            </a>
                        </c:when>
                        <c:otherwise>
                            Nenhum livro cadastrado ainda.
                            <br><br>
                            <a href="${pageContext.request.contextPath}/livros?action=novo"
                                class="btn btn-success">
                                Cadastrar primeiro livro
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>