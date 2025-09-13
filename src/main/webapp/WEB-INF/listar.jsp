<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titulo}</title>
    <style>
        /* estilos basicos da pagina com background */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            /* imagem de fundo de biblioteca - pode trocar por qualquer URL */
            background-image: url('https://s.libertaddigital.com/2018/12/05/biblioteca-oodi-helsinki-finlandia-3.jpg');
            background-size: cover; /* cobre toda a tela */
            background-position: center; /* centraliza a imagem */
            background-attachment: fixed; /* imagem fica fixa quando scrolla */
            background-repeat: no-repeat;
            /* overlay escuro por cima da imagem pra melhorar legibilidade */
            background-color: rgba(0,0,0,0.4);
            background-blend-mode: overlay;
            min-height: 100vh; /* altura minima da tela toda */
        }

        /* container principal - quase transparente pra mostrar o fundo */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: rgba(255, 255, 255, 0.15); /* bem mais transparente */
            padding: 30px;
            border-radius: 12px; /* bordas mais arredondadas */
            box-shadow: 0 8px 32px rgba(0,0,0,0.2); /* sombra mais suave */
            backdrop-filter: blur(8px); /* efeito de vidro fosco */
            border: 1px solid rgba(255,255,255,0.3); /* borda um pouco mais visivel */
        }

        /* titulo principal com efeito */
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1); /* sombra no texto */
            font-size: 2.5rem;
        }

        /* area de busca com fundo semi-transparente */
        .busca-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            gap: 15px;
            background-color: rgba(248, 249, 250, 0.8);
            padding: 20px;
            border-radius: 8px;
            backdrop-filter: blur(5px);
        }

        /* formulario de busca */
        .busca-form {
            display: flex;
            gap: 10px;
            flex: 1;
        }

        /* campo de busca com efeito glass */
        .busca-form input[type="text"] {
            flex: 1;
            padding: 12px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 6px;
            font-size: 16px;
            background-color: rgba(255,255,255,0.9);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        /* efeito quando clica no campo */
        .busca-form input[type="text"]:focus {
            outline: none;
            border-color: #007bff;
            background-color: rgba(255,255,255,1);
            box-shadow: 0 0 0 3px rgba(0,123,255,0.25);
        }

        /* estilos dos botoes com efeitos */
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 500;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* cores dos botoes com gradientes sutis */
        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #545b62);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
        }
        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #bd2130);
            color: white;
        }

        /* efeito hover mais suave */
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* alertas com fundo semi-transparente */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }

        .alert-success {
            background-color: rgba(212, 237, 218, 0.9);
            border: 1px solid rgba(195, 230, 203, 0.9);
            color: #155724;
        }

        .alert-error {
            background-color: rgba(248, 215, 218, 0.9);
            border: 1px solid rgba(245, 198, 203, 0.9);
            color: #721c24;
        }

        /* tabela com fundo semi-transparente */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: rgba(255,255,255,0.8);
            backdrop-filter: blur(10px);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        /* celulas da tabela */
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid rgba(222,222,222,0.5);
        }

        /* cabecalho da tabela */
        th {
            background-color: rgba(52, 58, 64, 0.9);
            color: white;
            font-weight: bold;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }

        /* efeito hover nas linhas */
        tr:hover {
            background-color: rgba(0,123,255,0.1);
            transition: background-color 0.3s ease;
        }

        /* coluna de acoes */
        .acoes {
            display: flex;
            gap: 8px;
        }

        /* mensagem quando nao tem dados */
        .sem-dados {
            text-align: center;
            padding: 60px;
            color: #495057;
            font-style: italic;
            background-color: rgba(248,249,250,0.8);
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }

        /* info sobre resultados */
        .info-resultados {
            color: #495057;
            font-size: 14px;
            margin-bottom: 10px;
            background-color: rgba(248,249,250,0.6);
            padding: 10px;
            border-radius: 6px;
            backdrop-filter: blur(5px);
        }

        /* links na tabela */
        a[style*="color: #007bff"] {
            color: #0056b3 !important;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        a[style*="color: #007bff"]:hover {
            color: #004085 !important;
            text-decoration: underline;
        }

        /* botoes pequenos da tabela */
        .btn[style*="font-size: 12px"] {
            padding: 6px 12px;
            font-size: 11px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- titulo da pagina -->
        <h1>${titulo}</h1>

        <!-- mensagens que vem da URL -->
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

        <!-- barra superior com busca e botao novo livro -->
        <div class="busca-container">
            <!-- formulario de busca -->
            <form class="busca-form" action="${pageContext.request.contextPath}/livros" method="get">
                <input type="hidden" name="action" value="buscar">
                <input type="text" name="termo" placeholder="Buscar por título ou autor..."
                        value="${termoBusca}">
                <button type="submit" class="btn btn-secondary">Buscar</button>
                <!-- se tem busca ativa, mostra botao limpar -->
                <c:if test="${termoBusca != null}">
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">Limpar</a>
                </c:if>
            </form>

            <!-- botao para cadastrar livro novo -->
            <a href="${pageContext.request.contextPath}/livros?action=novo"
                class="btn btn-success">Novo Livro</a>
        </div>

        <!-- informacoes sobre os resultados -->
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

        <!-- tabela de livros ou mensagem de vazio -->
        <c:choose>
            <c:when test="${livros != null && livros.size() > 0}">
                <!-- tem livros - mostra a tabela -->
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
                        <!-- loop pelos livros -->
                        <c:forEach var="livro" items="${livros}">
                            <tr>
                                <!-- titulo como link para detalhes -->
                                <td>
                                    <a href="${pageContext.request.contextPath}/livros/${livro.id}"
                                        style="text-decoration: none; color: #007bff;">
                                        <c:out value="${livro.titulo}"/>
                                    </a>
                                </td>

                                <!-- autor -->
                                <td><c:out value="${livro.autor}"/></td>

                                <!-- ano - se nao tem, mostra traço -->
                                <td>
                                    <c:choose>
                                        <c:when test="${livro.anoPublicacao != null}">
                                            ${livro.anoPublicacao}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- genero - se nao tem, mostra traço -->
                                <td>
                                    <c:choose>
                                        <c:when test="${livro.genero != null}">
                                            <c:out value="${livro.genero}"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- botoes de acao -->
                                <td class="acoes">
                                    <!-- botao ver detalhes -->
                                    <a href="${pageContext.request.contextPath}/livros/${livro.id}"
                                        class="btn btn-primary" style="font-size: 12px;">Ver</a>

                                    <!-- botao editar -->
                                    <a href="${pageContext.request.contextPath}/livros?action=editar&id=${livro.id}"
                                        class="btn btn-secondary" style="font-size: 12px;">Editar</a>

                                    <!-- botao excluir - form inline com confirmacao -->
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
                <!-- nao tem livros - mostra mensagem -->
                <div class="sem-dados">
                    <c:choose>
                        <c:when test="${termoBusca != null}">
                            <!-- se foi uma busca que nao achou nada -->
                            Nenhum livro encontrado para "<c:out value="${termoBusca}"/>".
                            <br><br>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">
                                Ver todos os livros
                            </a>
                        </c:when>
                        <c:otherwise>
                            <!-- se nao tem livro nenhum cadastrado -->
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