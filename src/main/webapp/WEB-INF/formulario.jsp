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
            max-width: 800px;
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
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
        .alert-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .error-field {
            border-color: #dc3545;
            background-color: #fff5f5;
        }
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
        }
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${titulo}</h1>

        <!-- Mensagem de erro geral -->
        <c:if test="${erro != null}">
            <div class="alert alert-error">
                <c:out value="${erro}"/>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/livros">
            <!-- Campo oculto para ação -->
            <c:choose>
                <c:when test="${livro.id != null}">
                    <input type="hidden" name="action" value="atualizar">
                    <input type="hidden" name="id" value="${livro.id}">
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="action" value="criar">
                </c:otherwise>
            </c:choose>

            <!-- Título -->
            <div class="form-group">
                <label for="titulo">Título <span class="required">*</span></label>
                <input type="text"
                       id="titulo"
                       name="titulo"
                       value="<c:out value='${livro.titulo}'/>"
                       class="${erroTitulo != null ? 'error-field' : ''}"
                       required
                       maxlength="255">
                <c:if test="${erroTitulo != null}">
                    <div class="error-message"><c:out value="${erroTitulo}"/></div>
                </c:if>
            </div>

            <!-- Autor -->
            <div class="form-group">
                <label for="autor">Autor <span class="required">*</span></label>
                <input type="text"
                       id="autor"
                       name="autor"
                       value="<c:out value='${livro.autor}'/>"
                       class="${erroAutor != null ? 'error-field' : ''}"
                       required
                       maxlength="255">
                <c:if test="${erroAutor != null}">
                    <div class="error-message"><c:out value="${erroAutor}"/></div>
                </c:if>
            </div>

            <!-- Ano de Publicação -->
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
                <c:if test="${erroAno != null}">
                    <div class="error-message"><c:out value="${erroAno}"/></div>
                </c:if>
            </div>

            <!-- Gênero -->
            <div class="form-group">
                <label for="genero">Gênero</label>
                <select id="genero" name="genero">
                    <option value="">Selecione um gênero</option>
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

            <!-- Sinopse -->
            <div class="form-group">
                <label for="sinopse">Sinopse</label>
                <textarea id="sinopse"
                          name="sinopse"
                          placeholder="Digite uma breve descrição do livro..."
                          maxlength="1000"><c:out value="${livro.sinopse}"/></textarea>
                <small style="color: #6c757d;">Máximo 1000 caracteres</small>
            </div>

            <!-- Botões de ação -->
            <div class="actions">
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

                <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">
                    Cancelar
                </a>
            </div>
        </form>
    </div>

    <script>
        // Validação simples no frontend
        document.querySelector('form').addEventListener('submit', function(e) {
            const titulo = document.getElementById('titulo').value.trim();
            const autor = document.getElementById('autor').value.trim();

            if (!titulo) {
                alert('Título é obrigatório');
                document.getElementById('titulo').focus();
                e.preventDefault();
                return false;
            }

            if (!autor) {
                alert('Autor é obrigatório');
                document.getElementById('autor').focus();
                e.preventDefault();
                return false;
            }

            const ano = document.getElementById('anoPublicacao').value;
            if (ano && (ano < 1000 || ano > 2030)) {
                alert('Ano deve estar entre 1000 e 2030');
                document.getElementById('anoPublicacao').focus();
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>