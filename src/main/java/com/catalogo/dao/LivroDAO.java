package com.catalogo.dao;

import com.catalogo.model.Livro;
import com.catalogo.util.ConexaoBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CLASSE LIVRODAO - O "Biblioteca Digital"
 *
 * Uma biblioteca que sabe exatamente onde encontrar,
 * guardar, atualizar e remover livros do banco de dados.
 *
 * DAO = Data Access Object (Objeto de Acesso a Dados)
 * É como ter um funcionário especializado que só cuida dos livros no banco de dados.
 */
public class LivroDAO {

    /**
     * INSERIR - "Cadastrar um novo livro na biblioteca"
     *
     * Como funciona:
     * - Usuário preenche um formulário com dados do livro
     * - Este método pega esses dados e salva no banco
     * - É como adicionar uma nova ficha na biblioteca
     */
    public boolean inserir(Livro livro) {
        // SQL para inserir um livro novo
        // Os "?" são placeholders - espaços reservados para os dados reais
        String sql = "INSERT INTO livro (titulo, autor, ano_publicacao, genero, sinopse) VALUES (?, ?, ?, ?, ?)";

        // Try-with-resources: automaticamente fecha a conexão quando termina
        // É como emprestar um livro e devolver automaticamente
        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Aqui substituímos os "?" pelos dados reais do livro
            // É como preencher os campos de uma ficha de cadastro
            stmt.setString(1, livro.getTitulo());        // 1º ? = título
            stmt.setString(2, livro.getAutor());         // 2º ? = autor
            stmt.setObject(3, livro.getAnoPublicacao()); // 3º ? = ano (pode ser vazio)
            stmt.setString(4, livro.getGenero());        // 4º ? = gênero
            stmt.setString(5, livro.getSinopse());       // 5º ? = sinopse

            // Executa o comando no banco - é como entregar a ficha preenchida
            int linhasAfetadas = stmt.executeUpdate();

            // Se conseguiu inserir pelo menos 1 linha, deu certo!
            if (linhasAfetadas > 0) {
                // O banco gera um ID único automaticamente (como um número de protocolo)
                // Vamos buscar esse ID e guardar no nosso objeto livro
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        livro.setId(rs.getLong(1)); // Salva o ID gerado
                    }
                }
                return true; // Sucesso deu certo !
            }

        } catch (SQLException e) {
            // Se algo deu errado, mostra o erro no console
            // É como o sistema avisar: "Ops, não consegui salvar o livro"
            System.err.println("Erro ao inserir livro: " + e.getMessage());
        }
        return false; //Algo deu errado
    }

    /**
     * LISTAR TODOS - "Mostrar todos os livros da biblioteca"
     *
     * Consulta geral: "Quais livros temos disponíveis?"
     * Retorna uma lista com todos os livros, organizados por título
     */
    public List<Livro> listarTodos() {
        // Cria uma "caixa" vazia para colocar todos os livros encontrados
        List<Livro> livros = new ArrayList<>();

        // SQL para buscar todos os livros, ordenados por título (A-Z)
        String sql = "SELECT id, titulo, autor, ano_publicacao, genero, sinopse FROM livro ORDER BY titulo";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            // Para cada livro encontrado no banco, vamos criar um objeto Livro
            while (rs.next()) {
                // Cria um novo livro em branco
                Livro livro = new Livro();

                // Preenche o livro com os dados do banco
                // É como copiar as informações da ficha para um objeto digital
                livro.setId(rs.getLong("id"));
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setAnoPublicacao((Integer) rs.getObject("ano_publicacao")); // Pode ser null
                livro.setGenero(rs.getString("genero"));
                livro.setSinopse(rs.getString("sinopse"));

                // Adiciona este livro à nossa lista
                livros.add(livro);
            }

        } catch (SQLException e) {
            System.err.println("Erro ao listar livros: " + e.getMessage());
        }

        // Retorna a lista completa (pode estar vazia se não houver livros)
        return livros;
    }

    /**
     * BUSCAR POR ID - "Encontrar um livro específico pelo número"
     *
     *  Procurar um livro pelo código de barras
     * Exemplo: buscarPorId(123) → encontra o livro com ID 123
     */
    public Livro buscarPorId(Long id) {
        // SQL para encontrar UM livro específico
        String sql = "SELECT id, titulo, autor, ano_publicacao, genero, sinopse FROM livro WHERE id = ?";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Substitui o "?" pelo ID que estamos procurando
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                // Se encontrou o livro...
                if (rs.next()) {
                    // Cria um livro e preenche com os dados encontrados
                    Livro livro = new Livro();
                    livro.setId(rs.getLong("id"));
                    livro.setTitulo(rs.getString("titulo"));
                    livro.setAutor(rs.getString("autor"));
                    livro.setAnoPublicacao((Integer) rs.getObject("ano_publicacao"));
                    livro.setGenero(rs.getString("genero"));
                    livro.setSinopse(rs.getString("sinopse"));

                    return livro; //Encontrou e retorna o livro
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar livro por ID: " + e.getMessage());
        }

        // Se chegou aqui, não encontrou nada
        return null; //Livro não encontrado
    }

    /**
     * BUSCAR - "Pesquisar livros por título ou autor"
     *
     * Como a barra de pesquisa de uma livraria online
     * Exemplo: buscar("Harry Potter") → encontra livros com "Harry Potter" no título ou autor
     */
    public List<Livro> buscar(String termoBusca) {
        List<Livro> livros = new ArrayList<>();

        // SQL que busca no título OU no autor
        // LOWER() torna tudo minúsculo para a busca funcionar melhor
        // LIKE com % significa "contém este texto"
        String sql = "SELECT id, titulo, autor, ano_publicacao, genero, sinopse FROM livro " +
                "WHERE LOWER(titulo) LIKE LOWER(?) OR LOWER(autor) LIKE LOWER(?) ORDER BY titulo";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Adiciona % antes e depois para buscar "contém"
            // Ex: "Harry" vira "%Harry%" (encontra "Harry Potter", "O Harry", etc.)
            String busca = "%" + termoBusca + "%";
            stmt.setString(1, busca); // Busca no título
            stmt.setString(2, busca); // Busca no autor

            try (ResultSet rs = stmt.executeQuery()) {
                // Para cada livro encontrado, cria o objeto e adiciona na lista
                while (rs.next()) {
                    Livro livro = new Livro();
                    livro.setId(rs.getLong("id"));
                    livro.setTitulo(rs.getString("titulo"));
                    livro.setAutor(rs.getString("autor"));
                    livro.setAnoPublicacao((Integer) rs.getObject("ano_publicacao"));
                    livro.setGenero(rs.getString("genero"));
                    livro.setSinopse(rs.getString("sinopse"));

                    livros.add(livro);
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar livros: " + e.getMessage());
        }
        return livros; // Retorna todos os livros encontrados (ou lista vazia)
    }

    /**
     * ATUALIZAR - "Editar as informações de um livro"
     *
     * Como corrigir ou atualizar a ficha de um livro já cadastrado
     * Exemplo: mudar o gênero de "Ficção" para "Ficção Científica"
     */
    public boolean atualizar(Livro livro) {
        // SQL para atualizar um livro específico pelo ID
        String sql = "UPDATE livro SET titulo = ?, autor = ?, ano_publicacao = ?, genero = ?, sinopse = ? WHERE id = ?";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Preenche todos os campos com os novos dados
            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setObject(3, livro.getAnoPublicacao());
            stmt.setString(4, livro.getGenero());
            stmt.setString(5, livro.getSinopse());
            stmt.setLong(6, livro.getId()); // WHERE - qual livro atualizar

            // Se atualizou pelo menos 1 linha, deu certo
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar livro: " + e.getMessage());
        }
        return false; //  Não conseguiu atualizar
    }

    /**
     * EXCLUIR - "Remover um livro da biblioteca"
     *
     *Descartar ou remover definitivamente um livro
     * Esta ação não pode ser desfeita!
     */
    public boolean excluir(Long id) {
        // SQL para deletar um livro específico
        String sql = "DELETE FROM livro WHERE id = ?";

        try (Connection conn = ConexaoBD.getConexao();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id); // Qual livro excluir

            // Se excluiu pelo menos 1 linha, deu certo
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao excluir livro: " + e.getMessage());
        }
        return false; //Não conseguiu excluir
    }
}