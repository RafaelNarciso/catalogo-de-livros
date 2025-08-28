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

@WebServlet(name = "LivroServlet", urlPatterns = {"/livros", "/livros/*"})
public class LivroServlet extends HttpServlet {

    private LivroDAO livroDAO;

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                if ("novo".equals(action)) {
                    mostrarFormularioNovo(request, response);
                } else if ("editar".equals(action)) {
                    mostrarFormularioEditar(request, response);
                } else if ("buscar".equals(action)) {
                    realizarBusca(request, response);
                } else {
                    listarLivros(request, response);
                }
            } else {
                mostrarDetalhes(request, response, pathInfo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro interno do servidor: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/erro.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("criar".equals(action)) {
                criarLivro(request, response);
            } else if ("atualizar".equals(action)) {
                atualizarLivro(request, response);
            } else if ("excluir".equals(action)) {
                excluirLivro(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro interno do servidor: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/erro.jsp").forward(request, response);
        }
    }

    private void listarLivros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Livro> livros = livroDAO.listarTodos();
        request.setAttribute("livros", livros);
        request.setAttribute("titulo", "Catálogo de Livros");
        request.getRequestDispatcher("/WEB-INF/listar.jsp").forward(request, response);
    }

    private void mostrarDetalhes(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String idStr = pathInfo.substring(1);
            Long id = Long.parseLong(idStr);

            Livro livro = livroDAO.buscarPorId(id);
            if (livro != null) {
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/WEB-INF/detalhes.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    private void mostrarFormularioNovo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("titulo", "Novo Livro");
        request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Livro livro = livroDAO.buscarPorId(id);

            if (livro != null) {
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

    private void realizarBusca(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String termo = request.getParameter("termo");
        if (termo != null && !termo.trim().isEmpty()) {
            List<Livro> livros = livroDAO.buscar(termo.trim());
            request.setAttribute("livros", livros);
            request.setAttribute("termoBusca", termo);
            request.setAttribute("titulo", "Resultados da busca: " + termo);
        } else {
            List<Livro> livros = livroDAO.listarTodos();
            request.setAttribute("livros", livros);
            request.setAttribute("titulo", "Catálogo de Livros");
        }
        request.getRequestDispatcher("/WEB-INF/listar.jsp").forward(request, response);
    }

    private void criarLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Livro livro = criarLivroDoRequest(request);

        if (validarLivro(livro, request)) {
            if (livroDAO.inserir(livro)) {
                response.sendRedirect(request.getContextPath() + "/livros?sucesso=Livro cadastrado com sucesso");
            } else {
                request.setAttribute("erro", "Erro ao salvar livro no banco de dados");
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("livro", livro);
            request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
        }
    }

    private void atualizarLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Livro livro = criarLivroDoRequest(request);
            livro.setId(id);

            if (validarLivro(livro, request)) {
                if (livroDAO.atualizar(livro)) {
                    response.sendRedirect(request.getContextPath() + "/livros?sucesso=Livro atualizado com sucesso");
                } else {
                    request.setAttribute("erro", "Erro ao atualizar livro");
                    request.setAttribute("livro", livro);
                    request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/WEB-INF/formulario.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    private void excluirLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));

            if (livroDAO.excluir(id)) {
                response.sendRedirect(request.getContextPath() + "/livros?sucesso=Livro excluído com sucesso");
            } else {
                response.sendRedirect(request.getContextPath() + "/livros?erro=Erro ao excluir livro");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }

    private Livro criarLivroDoRequest(HttpServletRequest request) {
        Livro livro = new Livro();

        livro.setTitulo(request.getParameter("titulo"));
        livro.setAutor(request.getParameter("autor"));
        livro.setGenero(request.getParameter("genero"));
        livro.setSinopse(request.getParameter("sinopse"));

        String anoStr = request.getParameter("anoPublicacao");
        if (anoStr != null && !anoStr.trim().isEmpty()) {
            try {
                livro.setAnoPublicacao(Integer.parseInt(anoStr));
            } catch (NumberFormatException e) {
                // Ano inválido será tratado na validação
            }
        }

        return livro;
    }

    private boolean validarLivro(Livro livro, HttpServletRequest request) {
        boolean valido = true;

        if (livro.getTitulo() == null || livro.getTitulo().trim().isEmpty()) {
            request.setAttribute("erroTitulo", "Título é obrigatório");
            valido = false;
        }

        if (livro.getAutor() == null || livro.getAutor().trim().isEmpty()) {
            request.setAttribute("erroAutor", "Autor é obrigatório");
            valido = false;
        }

        if (livro.getAnoPublicacao() != null) {
            int ano = livro.getAnoPublicacao();
            if (ano < 1000 || ano > 2030) {
                request.setAttribute("erroAno", "Ano deve estar entre 1000 e 2030");
                valido = false;
            }
        }

        return valido;
    }
}
