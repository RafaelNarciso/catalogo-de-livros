<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- titulo dinamico - vem do servlet -->
    <title>${titulo}</title>
    <style>
        /* estilos basicos da pagina com background */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            /* imagem de fundo de biblioteca - mesma das outras paginas */
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
            margin: 0 auto; /* centraliza na tela */
            background-color: rgba(255, 255, 255, 0.15); /* bem mais transparente */
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2); /* sombra mais suave */
            backdrop-filter: blur(8px); /* efeito de vidro fosco */
            border: 1px solid rgba(255,255,255,0.3); /* borda um pouco mais visivel */
        }

        /* titulo principal da pagina com sombra */
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            font-size: 2.2rem;
        }

        /* cada grupo de campo do formulario */
        .form-group {
            margin-bottom: 20px;
        }

        /* labels dos campos com sombra */
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #2c3e50;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* estilos dos campos de entrada com transparencia */
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 6px;
            font-size: 16px;
            box-sizing: border-box; /* inclui padding no tamanho total */
            background-color: rgba(255,255,255,0.9);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        /* efeito quando foca nos campos */
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            background-color: rgba(255,255,255,1);
            box-shadow: 0 0 0 3px rgba(0,123,255,0.25);
        }

        /* campo de texto longo (sinopse) */
        textarea {
            height: 100px;
            resize: vertical; /* permite redimensionar so na vertical */
        }

        /* estilo base dos botoes com efeitos */
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            margin-right: 10px;
            transition: all 0.3s ease;
            font-weight: 500;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* cores dos botoes com gradientes */
        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #545b62);
            color: white;
        }

        /* efeito hover nos botoes */
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* caixa de alerta para erros com transparencia */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }

        /* alerta de erro (vermelho) */
        .alert-error {
            background-color: rgba(248, 215, 218, 0.9);
            border: 1px solid rgba(245, 198, 203, 0.9);
            color: #721c24;
        }

        /* campo com erro - fica com borda vermelha */
        .error-field {
            border-color: #dc3545 !important;
            background-color: rgba(255, 245, 245, 0.9) !important;
        }

        /* mensagem de erro abaixo do campo */
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            font-weight: 500;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* area dos botoes de acao */
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(238,238,238,0.5); /* linha separadora mais suave */
        }

        /* asterisco vermelho para campos obrigatorios */
        .required {
            color: #dc3545;
        }

        /* texto pequeno (maximo caracteres) */
        small {
            color: #6c757d !important;
            font-weight: 500;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        /* responsivo */
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 20px;
            }

            h1 {
                font-size: 1.8rem;
            }

            .btn {
                margin-bottom: 10px;
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- titulo da pagina (cadastrar ou editar) -->
        <h1>${titulo}</h1>

        <!-- mostra mensagem de erro geral se tiver -->
        <c:if test="${erro != null}">
            <div class="alert alert-error">
                <c:out value="${erro}"/>
            </div>
        </c:if>

        <!-- formulario principal -->
        <form method="post" action="${pageContext.request.contextPath}/livros">
            <!-- campos ocultos para controlar a acao -->
            <c:choose>
                <c:when test="${livro.id != null}">
                    <!-- se tem ID, eh edicao -->
                    <input type="hidden" name="action" value="atualizar">
                    <input type="hidden" name="id" value="${livro.id}">
                </c:when>
                <c:otherwise>
                    <!-- se nao tem ID, eh cadastro novo -->
                    <input type="hidden" name="action" value="criar">
                </c:otherwise>
            </c:choose>

            <!-- campo titulo - obrigatorio -->
            <div class="form-group">
                <label for="titulo">Título <span class="required">*</span></label>
                <input type="text"
                       id="titulo"
                       name="titulo"
                       value="<c:out value='${livro.titulo}'/>"
                       class="${erroTitulo != null ? 'error-field' : ''}"
                       required
                       maxlength="255">
                <!-- mostra erro especifico do titulo se tiver -->
                <c:if test="${erroTitulo != null}">
                    <div class="error-message"><c:out value="${erroTitulo}"/></div>
                </c:if>
            </div>

            <!-- campo autor - obrigatorio -->
            <div class="form-group">
                <label for="autor">Autor <span class="required">*</span></label>
                <input type="text"
                       id="autor"
                       name="autor"
                       value="<c:out value='${livro.autor}'/>"
                       class="${erroAutor != null ? 'error-field' : ''}"
                       required
                       maxlength="255">
                <!-- mostra erro especifico do autor se tiver -->
                <c:if test="${erroAutor != null}">
                    <div class="error-message"><c:out value="${erroAutor}"/></div>
                </c:if>
            </div>

            <!-- campo ano - opcional -->
            <div class="form-group">
                <label for="anoPublicacao">Ano de Publicação</label>
                <input type="number"
                       id="anoPublicacao"
                       name="anoPublicacao"
                       value="${livro.anoPublicacao}"
                       class="${erroAno != null ? 'error-field' : ''}"
                       min="1000"
                       max="2030"
                       placeholder="Ex: 2023">
                <!-- mostra erro especifico do ano se tiver -->
                <c:if test="${erroAno != null}">
                    <div class="error-message"><c:out value="${erroAno}"/></div>
                </c:if>
            </div>

            <!-- campo genero - dropdown com opcoes predefinidas -->
            <div class="form-group">
                <label for="genero">Gênero</label>
                <select id="genero" name="genero">
                    <option value="">Selecione um gênero</option>
                    <!-- cada opcao verifica se eh o genero atual do livro -->
                    <option value="Romance" ${livro.genero == 'Romance' ? 'selected' : ''}>Romance</option>
                    <option value="Drama" ${livro.genero == 'Drama' ? 'selected' : ''}>Drama</option>
                    <option value="Ficção" ${livro.genero == 'Ficção' ? 'selected' : ''}>Ficção</option>
                    <option value="Não-ficção" ${livro.genero == 'Não-ficção' ? 'selected' : ''}>Não-ficção</option>
                    <option value="Mistério" ${livro.genero == 'Mistério' ? 'selected' : ''}>Mistério</option>
                    <option value="Thriller" ${livro.genero == 'Thriller' ? 'selected' : ''}>Thriller</option>
                    <option value="Fantasia" ${livro.genero == 'Fantasia' ? 'selected' : ''}>Fantasia</option>
                    <option value="Ficção Científica" ${livro.genero == 'Ficção Científica' ? 'selected' : ''}>Ficção Científica</option>
                    <option value="Biografia" ${livro.genero == 'Biografia' ? 'selected' : ''}>Biografia</option>
                    <option value="História" ${livro.genero == 'História' ? 'selected' : ''}>História</option>
                    <option value="Poesia" ${livro.genero == 'Poesia' ? 'selected' : ''}>Poesia</option>
                    <option value="Autoajuda" ${livro.genero == 'Autoajuda' ? 'selected' : ''}>Autoajuda</option>
                    <option value="Técnico" ${livro.genero == 'Técnico' ? 'selected' : ''}>Técnico</option>
                    <option value="Infantil" ${livro.genero == 'Infantil' ? 'selected' : ''}>Infantil</option>
                    <option value="Juvenil" ${livro.genero == 'Juvenil' ? 'selected' : ''}>Juvenil</option>
                    <option value="Clássico" ${livro.genero == 'Clássico' ? 'selected' : ''}>Clássico</option>
                    <option value="Outro" ${livro.genero == 'Outro' ? 'selected' : ''}>Outro</option>
                </select>
            </div>

            <!-- campo sinopse - texto longo opcional -->
            <div class="form-group">
                <label for="sinopse">Sinopse</label>
                <textarea id="sinopse"
                          name="sinopse"
                          placeholder="Digite uma breve descrição do livro..."
                          maxlength="1000"><c:out value="${livro.sinopse}"/></textarea>
                <small style="color: #6c757d;">Máximo 1000 caracteres</small>
            </div>

            <!-- botoes de acao -->
            <div class="actions">
                <!-- botao principal - texto muda dependendo se eh edicao ou cadastro -->
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${livro.id != null}">
                            Atualizar Livro
                        </c:when>
                        <c:otherwise>
                            Cadastrar Livro
                        </c:otherwise>
                    </c:choose>
                </button>

                <!-- botao cancelar - volta pra lista -->
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">
                    Cancelar
                </a>
            </div>
        </form>
    </div>

    <script>
        // validacao simples no frontend antes de enviar
        document.querySelector('form').addEventListener('submit', function(e) {
            // pega os valores dos campos obrigatorios
            const titulo = document.getElementById('titulo').value.trim();
            const autor = document.getElementById('autor').value.trim();

            // verifica se titulo foi preenchido
            if (!titulo) {
                alert('Título é obrigatório');
                document.getElementById('titulo').focus(); // foca no campo
                e.preventDefault(); // impede o envio
                return false;
            }

            // verifica se autor foi preenchido
            if (!autor) {
                alert('Autor é obrigatório');
                document.getElementById('autor').focus();
                e.preventDefault();
                return false;
            }

            // verifica se o ano esta no range valido (se foi informado)
            const ano = document.getElementById('anoPublicacao').value;
            if (ano && (ano < 1000 || ano > 2030)) {
                alert('Ano deve estar entre 1000 e 2030');
                document.getElementById('anoPublicacao').focus();
                e.preventDefault();
                return false;
            }

            // se chegou ate aqui, pode enviar o formulario
        });
    </script>
</body>
</html>