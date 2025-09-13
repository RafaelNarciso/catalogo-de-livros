<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- titulo da pagina aparece na aba do navegador -->
    <title>Detalhes - <c:out value="${livro.titulo}"/></title>
    <style>
        /* estilos basicos da pagina com background */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            /* imagem de fundo de biblioteca - mesma da listagem */
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
            max-width: 800px;
            margin: 0 auto; /* centraliza */
            background-color: rgba(255, 255, 255, 0.15); /* bem mais transparente */
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2); /* sombra mais suave */
            backdrop-filter: blur(8px); /* efeito de vidro fosco */
            border: 1px solid rgba(255,255,255,0.3); /* borda um pouco mais visivel */
        }

        /* cabecalho com titulo e autor */
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(238,238,238,0.5); /* linha separadora mais suave */
        }

        /* titulo do livro - bem destacado com sombra */
        .titulo {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2); /* sombra no texto */
        }

        /* nome do autor em italico com sombra */
        .autor {
            font-size: 18px;
            color: #495057;
            font-style: italic;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* grid para mostrar informacoes lado a lado */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr; /* duas colunas iguais */
            gap: 20px; /* espaco entre as colunas */
            margin-bottom: 30px;
        }

        /* cada item de informacao (ano, genero) com transparencia */
        .info-item {
            background-color: rgba(248, 249, 250, 0.8);
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #007bff; /* linha azul na esquerda */
            backdrop-filter: blur(5px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* label das informacoes (ex: "ANO DE PUBLICACAO") */
        .info-label {
            font-weight: bold;
            color: #2c3e50;
            font-size: 14px;
            text-transform: uppercase; /* deixa tudo maiusculo */
            margin-bottom: 5px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* valor da informacao (ex: "2023") */
        .info-value {
            color: #495057;
            font-size: 16px;
            font-weight: 500;
        }

        /* secao da sinopse */
        .sinopse-section {
            margin-bottom: 30px;
        }

        /* titulo da secao sinopse */
        .sinopse-title {
            font-size: 20px;
            color: #2c3e50;
            margin-bottom: 15px;
            font-weight: bold;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* caixa onde fica o texto da sinopse com transparencia */
        .sinopse-content {
            background-color: rgba(248, 249, 250, 0.8);
            padding: 20px;
            border-radius: 8px;
            line-height: 1.6; /* espaco entre linhas */
            color: #495057;
            white-space: pre-line; /* preserva quebras de linha */
            backdrop-filter: blur(5px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* area dos botoes de acao */
        .actions {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(238,238,238,0.5); /* linha separadora mais suave */
        }

        /* estilo base dos botoes com efeitos */
        .btn {
            display: inline-block;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            margin: 0 5px;
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

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #bd2130);
            color: white;
        }

        /* efeito hover mais suave */
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* texto quando nao tem sinopse */
        .sem-sinopse {
            color: #6c757d;
            font-style: italic;
        }

        /* badge para mostrar o genero com efeito */
        .badge {
            display: inline-block;
            padding: 6px 12px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* responsivo - em telas pequenas vira uma coluna so */
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr; /* uma coluna so */
            }

            .container {
                margin: 10px;
                padding: 20px;
            }

            .titulo {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- cabecalho com titulo e autor do livro -->
        <div class="header">
            <!-- c:out previne XSS - sempre usar para mostrar dados do usuario -->
            <h1 class="titulo"><c:out value="${livro.titulo}"/></h1>
            <p class="autor">por <c:out value="${livro.autor}"/></p>
        </div>

        <!-- grid com informacoes basicas -->
        <div class="info-grid">
            <!-- bloco do ano de publicacao -->
            <div class="info-item">
                <div class="info-label">Ano de Publicação</div>
                <div class="info-value">
                    <!-- verifica se tem ano informado -->
                    <c:choose>
                        <c:when test="${livro.anoPublicacao != null}">
                            ${livro.anoPublicacao}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #6c757d;">Não informado</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- bloco do genero -->
            <div class="info-item">
                <div class="info-label">Gênero</div>
                <div class="info-value">
                    <!-- verifica se tem genero informado e se nao ta vazio -->
                    <c:choose>
                        <c:when test="${livro.genero != null && !livro.genero.trim().isEmpty()}">
                            <span class="badge"><c:out value="${livro.genero}"/></span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #6c757d;">Não informado</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- secao da sinopse (resumo do livro) -->
        <div class="sinopse-section">
            <h2 class="sinopse-title">Sinopse</h2>
            <div class="sinopse-content">
                <!-- verifica se tem sinopse -->
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

        <!-- botoes de acao -->
        <div class="actions">
            <!-- botao voltar - vai pra lista de livros -->
            <a href="${pageContext.request.contextPath}/livros"
                class="btn btn-secondary">
                ← Voltar à lista
            </a>

            <!-- botao editar - vai pro formulario de edicao -->
            <a href="${pageContext.request.contextPath}/livros?action=editar&id=${livro.id}"
                class="btn btn-primary">
             ✏️ Editar
            </a>

            <!-- botao excluir - chama funcao javascript pra confirmar -->
            <button type="button"
                    class="btn btn-danger"
                    onclick="confirmarExclusao()">
              🗑️ Excluir
            </button>
        </div>
    </div>

    <!-- formulario escondido para excluir o livro -->
    <!-- fica escondido e so é enviado quando confirma a exclusao -->
    <form id="formExcluir"
            method="post"
            action="${pageContext.request.contextPath}/livros"
            style="display: none;">
        <input type="hidden" name="action" value="excluir">
        <input type="hidden" name="id" value="${livro.id}">
    </form>

    <script>
        // funcao para confirmar se quer mesmo excluir o livro
        function confirmarExclusao() {
            // pega o titulo do livro de forma segura
            const titulo = '<c:out value="${livro.titulo}" escapeXml="true"/>';

            // mostra popup de confirmacao
            if (confirm('Tem certeza que deseja excluir o livro "' + titulo + '"?\n\nEsta ação não pode ser desfeita.')) {
                // se confirmou, envia o formulario escondido
                document.getElementById('formExcluir').submit();
            }
            // se cancelou, nao faz nada
        }
    </script>
</body>
</html>