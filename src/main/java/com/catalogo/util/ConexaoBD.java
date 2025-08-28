package com.catalogo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe responsável por gerenciar a conexão com o banco de dados PostgreSQL
 * Utiliza variáveis de ambiente para maior segurança
 */
public class ConexaoBD {

    // Configurações do banco via variáveis de ambiente
    private static final String HOST = System.getenv().getOrDefault("DB_HOST", "localhost");
    private static final String PORT = System.getenv().getOrDefault("DB_PORT", "5432");
    private static final String DATABASE = System.getenv().getOrDefault("DB_NAMEEE", "catalogolivros");
    private static final String USUARIO = System.getenv().getOrDefault("DB_USER", "postgres");
    private static final String SENHA = System.getenv().getOrDefault("DB_PASSWORD", "postgres");

    // URL de conexão
    private static final String URL = String.format(
            "jdbc:postgresql://%s:%s/%s?useSSL=false&serverTimezone=UTC",
            HOST, PORT, DATABASE
    );

    // Carrega o driver PostgreSQL
    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver PostgreSQL não encontrado", e);
        }
    }

    /**
     * Obtém uma conexão com o banco de dados
     * @return Connection - conexão ativa com o banco
     * @throws SQLException se houver erro na conexão
     */
    public static Connection getConexao() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }

    /**
     * Fecha a conexão com o banco de dados
     * @param conexao - conexão a ser fechada
     */
    public static void fecharConexao(Connection conexao) {
        if (conexao != null) {
            try {
                conexao.close();
            } catch (SQLException e) {
                System.err.println("Erro ao fechar conexão: " + e.getMessage());
            }
        }
    }

    /**
     * Testa a conexão com o banco de dados
     * @return true se a conexão foi bem-sucedida, false caso contrário
     */
    public static boolean testarConexao() {
        try (Connection conn = getConexao()) {
            System.out.println("Tentando conectar em: " + URL);
            System.out.println("Usuário: " + USUARIO);
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Erro ao conectar com o banco: " + e.getMessage());
            return false;
        }
    }

    /**
     * Método para debug - exibe as configurações (sem mostrar a senha)
     */
    public static void exibirConfiguracoes() {
        System.out.println("=== Configurações do Banco ===");
        System.out.println("Host: " + HOST);
        System.out.println("Port: " + PORT);
        System.out.println("Database: " + DATABASE);
        System.out.println("User: " + USUARIO);
        System.out.println("URL: " + URL);
        System.out.println("==============================");
    }
}