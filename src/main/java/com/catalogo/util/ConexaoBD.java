package com.catalogo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe para conectar com o banco de dados PostgreSQL
 * Esta classe cuida de toda a conexao com o banco
 * usa variaveis de ambiente pra nao deixar senha hardcoded
 */
public class ConexaoBD {

    // pegando configurações do sistema ou usando valores padrão se nao tiver
    private static final String HOST = System.getenv().getOrDefault("DB_HOST", "localhost");
    private static final String PORT = System.getenv().getOrDefault("DB_PORT", "5432");
    private static final String DATABASE = System.getenv().getOrDefault("DB_NAMEEE", "catalogolivros");
    private static final String USUARIO = System.getenv().getOrDefault("DB_USER", "postgres");
    private static final String SENHA = System.getenv().getOrDefault("DB_PASSWORD", "postgres");

    // monta a URL de conexao com o postgres
    // formato: jdbc:postgresql://host:porta/banco?parametros
    private static final String URL = String.format(
            "jdbc:postgresql://%s:%s/%s?useSSL=false&serverTimezone=UTC",
            HOST, PORT, DATABASE
    );

    // bloco estatico - roda quando a classe é carregada pela primeira vez
    // carrega o driver do postgres na memoria
    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("nao achou o driver do PostgreSQL", e);
        }
    }

    /**
     * metodo principal - retorna uma conexao com o banco
     * toda vez que precisar acessar o banco, chama este metodo
     *
     * @return Connection - objeto de conexao ativo
     * @throws SQLException se der problema na conexao
     */
    public static Connection getConexao() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }

    /**
     * fecha a conexao com o banco
     * importante sempre fechar depois de usar para nao vazar memoria
     *
     * @param conexao - a conexao que vai ser fechada
     */
    public static void fecharConexao(Connection conexao) {
        if (conexao != null) {
            try {
                conexao.close();
            } catch (SQLException e) {
                System.err.println("deu erro ao fechar conexao: " + e.getMessage());
            }
        }
    }

    /**
     * metodo para testar se consegue conectar no banco
     * util para debug ou para verificar se ta tudo funcionando
     *
     * @return true se conectou, false se deu ruim
     */
    public static boolean testarConexao() {
        try (Connection conn = getConexao()) {
            System.out.println("tentando conectar em: " + URL);
            System.out.println("usuario: " + USUARIO);
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("erro ao conectar no banco: " + e.getMessage());
            return false;
        }
    }

    /**
     * metodo para mostrar as configuracoes que tao sendo usadas
     * util pra debug - mas nao mostra a senha por seguranca
     */
    public static void exibirConfiguracoes() {
        System.out.println("=== configuracoes do banco ===");
        System.out.println("host: " + HOST);
        System.out.println("porta: " + PORT);
        System.out.println("banco: " + DATABASE);
        System.out.println("usuario: " + USUARIO);
        System.out.println("url completa: " + URL);
        System.out.println("===============================");
    }
}