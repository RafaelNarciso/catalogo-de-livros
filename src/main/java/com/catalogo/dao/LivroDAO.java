package com.catalogo.dao;

import com.catalogo.model.Livro;
import com.catalogo.util.ConexaoBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe DAO para operações CRUD da entidade Livro
 * Implementa o padrão Data Access Object
 */
public class LivroDAO {

    /**
     * Insere um novo livro no banco de dados
     */
    public boolean inserir(Livro livro) {
        String sql = "INSERT INTO livro (titulo, autor, ano_publicacao, genero, sinopse) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setObject(3, livro.getAnoPublicacao()); // Permite NULL
            stmt.setString(4, livro.getGenero());
            stmt.setString(5, livro.getSinopse());

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas > 0) {
                // Recupera o ID gerado automaticamente
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        livro.setId(rs.getLong(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Erro ao inserir livro: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lista todos os livros do banco de dados
     */
    public List<Livro> listarTodos() {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT id, titulo, autor, ano_publicacao, genero, sinopse FROM livro ORDER BY titulo";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Livro livro = new Livro();
                livro.setId(rs.getLong("id"));
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setAnoPublicacao((Integer) rs.getObject("ano_publicacao")); // Trata NULL
                livro.setGenero(rs.getString("genero"));
                livro.setSinopse(rs.getString("sinopse"));

                livros.add(livro);
            }

        } catch (SQLException e) {
            System.err.println("Erro ao listar livros: " + e.getMessage());
        }
        return livros;
    }

    /**
     * Busca um livro específico pelo ID
     */
    public Livro buscarPorId(Long id) {
        String sql = "SELECT id, titulo, autor, ano_publicacao, genero, sinopse FROM livro WHERE id = ?";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Livro livro = new Livro();
                    livro.setId(rs.getLong("id"));
                    livro.setTitulo(rs.getString("titulo"));
                    livro.setAutor(rs.getString("autor"));
                    livro.setAnoPublicacao((Integer) rs.getObject("ano_publicacao"));
                    livro.setGenero(rs.getString("genero"));
                    livro.setSinopse(rs.getString("sinopse"));

                    return livro;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar livro por ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Busca livros por título ou autor (busca simples)
     */
    public List<Livro> buscar(String termoBusca) {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT id, titulo, autor, ano_publicacao, genero, sinopse FROM livro " +
                "WHERE LOWER(titulo) LIKE LOWER(?) OR LOWER(autor) LIKE LOWER(?) ORDER BY titulo";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String busca = "%" + termoBusca + "%";
            stmt.setString(1, busca);
            stmt.setString(2, busca);

            try (ResultSet rs = stmt.executeQuery()) {
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
        return livros;
    }

    /**
     * Atualiza um livro existente
     */
    public boolean atualizar(Livro livro) {
        String sql = "UPDATE livro SET titulo = ?, autor = ?, ano_publicacao = ?, genero = ?, sinopse = ? WHERE id = ?";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setObject(3, livro.getAnoPublicacao());
            stmt.setString(4, livro.getGenero());
            stmt.setString(5, livro.getSinopse());
            stmt.setLong(6, livro.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar livro: " + e.getMessage());
        }
        return false;
    }

    /**
     * Exclui um livro pelo ID
     */
    public boolean excluir(Long id) {
        String sql = "DELETE FROM livro WHERE id = ?";

        try (Connection conn = ConexaoBD.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao excluir livro: " + e.getMessage());
        }
        return false;
    }
}