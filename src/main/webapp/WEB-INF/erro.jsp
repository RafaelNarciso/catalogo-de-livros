<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalhes - <c:out value="${livro.titulo}"/></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }
        .titulo {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .autor {
            font-size: 18px;
            color: #666;
            font-style: italic;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-item {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #007bff;
        }
        .info-label {
            font-weight: bold;
            color: #333;
            font-size: 14px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .info-value {
            color: #666;
            font-size: 16px;
        }
        .sinopse-section {
            margin-bottom: 30px;
        }
        .sinopse-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .sinopse-content {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 6px;
            line-height: 1.6;
            color: #555;
            white-space: pre-line;
        }
        .actions {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .btn {
            display: inline-block;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            margin: 0 5px;
            transition: opacity 0.2s;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .sem-sinopse {
            color: #999;
            font-style: italic;
        }
        .badge {
            display: inline-block;
            padding: 4px 12px;
            background-color: #007bff;
            color: white;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Cabeçalho com título e autor -->
        <div class="header">
            <h1 class="titulo"><c:out value="${livro.titulo}"/></h1>
            <p class="autor">por <c:out value="${livro.autor}"/></p>
        </div>

        <!-- Grid de informações -->
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Ano de Publicação</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${livro.anoPublicacao != null}">
                            ${livro.anoPublicacao}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Não informado</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-item">
                <div class="info-label">Gênero</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${livro.genero != null && !livro.genero.trim().isEmpty()}">
                            <span class="badge"><c:out value="${livro.genero}"/></span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">Não informado</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Seção da sinopse -->
        <div class="sinopse-section">
            <h2 class="sinopse-title">Sinopse</h2>
            <div class="sinopse-content">
                <c:choose>
                    <c:when test="${livro.sinopse != null && !livro.sinopse.trim().isEmpty()}">
                        <c:out value="${livro.sinopse}"/>
                    </c:when>
                    <c:otherwise>
                        <span class="sem-sinopse">Sinopse não disponível.</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Ações -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/livros"
                class="btn btn-secondary">
                ← Voltar à lista
            </a>

            <a href="${pageContext.request.contextPath}/livros?action=editar&id=${livro.id}"
                class="btn btn-primary">
                ✏️ Editar
            </a>

            <button type="button"
                    class="btn btn-danger"
                    onclick="confirmarExclusao()">
                🗑️ Excluir
            </button>
        </div>
    </div>

    <!-- Formulário oculto para exclusão -->
    <form id="formExcluir"
            method="post"
            action="${pageContext.request.contextPath}/livros"
            style="display: none;">
        <input type="hidden" name="action" value="excluir">
        <input type="hidden" name="id" value="${livro.id}">
    </form>

    <script>
        function confirmarExclusao() {
            const titulo = '<c:out value="${livro.titulo}" escapeXml="true"/>';

            if (confirm('Tem certeza que deseja excluir o livro "' + titulo + '"?\n\nEsta ação não pode ser desfeita.')) {
                document.getElementById('formExcluir').submit();
            }
        }
    </script>
</body>
</html>