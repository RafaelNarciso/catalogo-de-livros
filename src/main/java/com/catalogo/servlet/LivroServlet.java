package com.catalogo.servlet;

import com.catalogo.dao.LivroDAO;
import com.catalogo.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 🌐 LIVROSERVLET - O "Controlador de Tráfego" do Sistema
 *
 * Esta classe é como um atendente de biblioteca que entende o que o usuário quer
 * e direciona para a ação correta. Quando alguém acessa o site, esta classe decide:
 * - Mostrar a lista de livros?
 * - Abrir o formulário para cadastrar?
 * - Exibir detalhes de um livro específico?
 *
 * É a ponte entre o que o usuário vê (páginas web) e os dados (banco de dados).
 */
@WebServlet(name = "LivroServlet", urlPatterns = {"/livros", "/livros/*"})
public class LivroServlet extends HttpServlet {

    // Nosso "bibliotecário" que cuida do banco de dados
    private LivroDAO livroDAO;

    /**
     * Inicialização - Preparando o "bibliotecário"
     * Como contratar um funcionário quando a biblioteca abre
     */
    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
    }

    /**
     * 📖 MÉTODO GET - Quando alguém quer "VER" algo
     *
     * Como quando uma pessoa entra na biblioteca e diz:
     * - "Quero ver todos os livros"
     * - "Quero ver detalhes deste livro"
     * - "Quero o formulário para cadastrar um livro novo"
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica qual página específica foi pedida
        String pathInfo = request.getPathInfo();
        // Verifica se tem alguma ação especial pedida
        String action = request.getParameter("action");

        try {
            // Se não especificou nenhuma página em particular...
            if (pathInfo == null || pathInfo.equals("/")) {

                // Verifica o que a pessoa quer fazer
                if ("novo".equals(action)) {
                    mostrarFormularioNovo(request, response);      // Quer cadastrar livro novo
                } else if ("editar".equals(action)) {
                    mostrarFormularioEditar(request, response);    // Quer editar um livro
                } else if ("buscar".equals(action)) {
                    realizarBusca(request, response);              // Quer fazer uma busca
                } else {
                    listarLivros(request, response);               // Só quer ver todos os livros
                }
            } else {
                // Se especificou uma página (ex: /livros/123), quer ver detalhes
                mostrarDetalhes(request, response, pathInfo);
            }
        } catch (Exception e) {
            // Se algo deu errado, mostra uma página de erro amigável
            e.printStackTrace();
            request.setAttribute("erro", "Ops! Algo deu errado: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/erro.jsp").forward(request, response);
        }
    }

    /**
     * ✏️ MÉTODO POST - Quando alguém quer "MODIFICAR" algo
     *
     * Como quando uma pessoa preenche um formulário e clica "Salvar":
     * - Cadastrar um livro novo
     * - Atualizar informações de um livro
     * - Excluir um livro
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Garante que acentos e caracteres especiais funcionem
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // Verifica qual ação foi solicitada no formulário
            if ("criar".equals(action)) {
                criarLivro(request, response);                     // Salvar livro novo
            } else if ("atualizar".equals(action)) {
                atualizarLivro(request, response);                 // Atualizar livro existente
            } else if ("excluir".equals(action)) {
                excluirLivro(request, response);                   // Remover livro
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Não entendi o que você quer fazer");
            }
        } catch (Exception e) {
            // Se algo deu errado, mostra erro
            e.printStackTrace();
            request.setAttribute("erro", "Ops! Algo deu errado: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/erro.jsp").forward(request, response);
        }
    }

    /**
     * 📚 Mostrar lista de todos os livros
     * Como exibir o catálogo completo da biblioteca
     */
    private void listarLivros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Busca todos os livros no banco de dados
        List<Livro> livros = livroDAO.listarTodos();

        // Prepara as informações para a página
        request.setAttribute("livros", livros);
        request.setAttribute("titulo", "Catálogo de Livros");

        // Mostra a página com a lista
        request.getRequestDispatcher("/WEB-INF/listar.jsp").forward(request, response);
    }

    /**
     * 🔍 Mostrar detalhes de um livro específico
     * Como quando alguém pede: "Me mostre tudo sobre este livro"
     */
    private void mostrarDetalhes(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            // Extrai o ID do livro da URL (ex: /livros/123 → ID = 123)
            String idStr = pathInfo.substring(1);
            Long id = Long.parseLong(idStr);

            // Busca o livro no banco
            Livro livro = livroDAO.buscarPorId(id);

            if (livro != null) {
                // Encontrou o livro - mostra os detalhes
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/WEB-INF/detalhes.jsp").forward(request, response);
            } else {
                // Não encontrou - mostra erro 404
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Este livro não existe no nosso catálogo");
            }
        } catch (NumberFormatException e) {
            // Se o ID não for um número válido
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Número do livro inválido");
        }
    }

    /**
     * 📝 Mostrar formulário para cadastrar livro novo
     * Como entregar uma ficha em branco para preencher
     */
    private void mostrarFormularioNovo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("titulo", "Cadastrar Novo Livro");
        request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
    }

    /**
     * ✏️ Mostrar formulário para editar um livro existente
     * Como entregar uma ficha já preenchida para fazer correções
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Pega o ID do livro que quer editar
            Long id = Long.parseLong(request.getParameter("id"));
            Livro livro = livroDAO.buscarPorId(id);

            if (livro != null) {
                // Encontrou o livro - mostra o formulário preenchido
                request.setAttribute("livro", livro);
                request.setAttribute("titulo", "Editar Livro");
                request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    /**
     * 🔎 Realizar busca de livros
     * Como quando alguém pergunta: "Vocês têm livros sobre Harry Potter?"
     */
    private void realizarBusca(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String termo = request.getParameter("termo");

        if (termo != null && !termo.trim().isEmpty()) {
            // Tem termo de busca - procura livros relacionados
            List<Livro> livros = livroDAO.buscar(termo.trim());
            request.setAttribute("livros", livros);
            request.setAttribute("termoBusca", termo);
            request.setAttribute("titulo", "Resultados da busca: " + termo);
        } else {
            // Busca vazia - mostra todos os livros
            List<Livro> livros = livroDAO.listarTodos();
            request.setAttribute("livros", livros);
            request.setAttribute("titulo", "Catálogo de Livros");
        }
        request.getRequestDispatcher("/WEB-INF/listar.jsp").forward(request, response);
    }

    /**
     * ➕ Criar um livro novo
     * Como processar uma ficha preenchida e adicionar o livro ao catálogo
     */
    private void criarLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pega os dados do formulário e cria um objeto Livro
        Livro livro = criarLivroDoRequest(request);

        // Verifica se os dados estão corretos
        if (validarLivro(livro, request)) {
            // Dados OK - tenta salvar no banco
            if (livroDAO.inserir(livro)) {
                // Sucesso! Volta para a lista com mensagem de sucesso
                response.sendRedirect(request.getContextPath() + "/livros?sucesso=Livro cadastrado com sucesso");
            } else {
                // Erro ao salvar - volta pro formulário com erro
                request.setAttribute("erro", "Não conseguimos salvar o livro. Tente novamente.");
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
            }
        } else {
            // Dados inválidos - volta pro formulário com os erros
            request.setAttribute("livro", livro);
            request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
        }
    }

    /**
     * 🔄 Atualizar um livro existente
     * Como processar uma ficha corrigida e atualizar no catálogo
     */
    private void atualizarLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Pega o ID do livro que está sendo editado
            Long id = Long.parseLong(request.getParameter("id"));
            Livro livro = criarLivroDoRequest(request);
            livro.setId(id);

            // Valida os dados
            if (validarLivro(livro, request)) {
                // Dados OK - tenta atualizar
                if (livroDAO.atualizar(livro)) {
                    response.sendRedirect(request.getContextPath() + "/livros?sucesso=Livro atualizado com sucesso");
                } else {
                    request.setAttribute("erro", "Não conseguimos atualizar o livro. Tente novamente.");
                    request.setAttribute("livro", livro);
                    request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
                }
            } else {
                // Dados inválidos
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    /**
     * 🗑️ Excluir um livro
     * Como remover um livro do catálogo permanentemente
     */
    private void excluirLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));

            if (livroDAO.excluir(id)) {
                // Sucesso na exclusão
                response.sendRedirect(request.getContextPath() + "/livros?sucesso=Livro removido com sucesso");
            } else {
                // Erro na exclusão
                response.sendRedirect(request.getContextPath() + "/livros?erro=Não conseguimos remover o livro");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    /**
     * 🏗️ Criar objeto Livro a partir dos dados do formulário
     * Como pegar as informações escritas na ficha e criar um livro digital
     */
    private Livro criarLivroDoRequest(HttpServletRequest request) {
        Livro livro = new Livro();

        // Pega cada campo do formulário e coloca no livro
        livro.setTitulo(request.getParameter("titulo"));
        livro.setAutor(request.getParameter("autor"));
        livro.setGenero(request.getParameter("genero"));
        livro.setSinopse(request.getParameter("sinopse"));

        // Ano de publicação precisa ser convertido de texto para número
        String anoStr = request.getParameter("anoPublicacao");
        if (anoStr != null && !anoStr.trim().isEmpty()) {
            try {
                livro.setAnoPublicacao(Integer.parseInt(anoStr));
            } catch (NumberFormatException e) {
                // Se o ano não for um número válido, deixa vazio
                // O erro será detectado na validação
            }
        }

        return livro;
    }

    /**
     * Validar se os dados do livro estão corretos
     * Como um revisor que confere se a ficha foi preenchida direito
     */
    private boolean validarLivro(Livro livro, HttpServletRequest request) {
        boolean valido = true;

        // Título é obrigatório
        if (livro.getTitulo() == null || livro.getTitulo().trim().isEmpty()) {
            request.setAttribute("erroTitulo", "Por favor, informe o título do livro");
            valido = false;
        }

        // Autor é obrigatório
        if (livro.getAutor() == null || livro.getAutor().trim().isEmpty()) {
            request.setAttribute("erroAutor", "Por favor, informe o autor do livro");
            valido = false;
        }

        // Se informou o ano, precisa ser um ano razoável
        if (livro.getAnoPublicacao() != null) {
            int ano = livro.getAnoPublicacao();
            if (ano < 1000 || ano > 2030) {
                request.setAttribute("erroAno", "O ano deve estar entre 1000 e 2030");
                valido = false;
            }
        }

        return valido;
    }
}