package com.catalogo.model;

/**
 * CLASSE LIVRO - A "Ficha do Livro"
 *
 * Pense nesta classe como uma ficha de livro que você preencheria numa biblioteca.
 * Ela guarda todas as informações importantes de um livro: título, autor, etc.
 *
 * É como um formulário digital que representa um livro real.
 */
public class Livro {

    // Cada atributo é como um campo numa ficha de livro
    private Long id;              // Número único do livro (como um código de barras)
    private String titulo;        // Nome do livro (ex: "O Senhor dos Anéis")
    private String autor;         // Quem escreveu (ex: "J.R.R. Tolkien")
    private Integer anoPublicacao; // Quando foi publicado (ex: 1954) - pode ficar em branco
    private String genero;        // Tipo do livro (ex: "Fantasia", "Romance")
    private String sinopse;       // Resumo da história

    /**
     * Construtor vazio - Cria uma ficha em branco
     * Como pegar uma ficha nova e vazia para preencher depois
     */
    public Livro() {
    }

    /**
     * Construtor completo - Cria uma ficha já preenchida
     * Como preencher todos os campos da ficha de uma vez
     */
    public Livro(String titulo, String autor, Integer anoPublicacao, String genero, String sinopse) {
        this.titulo = titulo;
        this.autor = autor;
        this.anoPublicacao = anoPublicacao;
        this.genero = genero;
        this.sinopse = sinopse;
    }

    // GETTERS E SETTERS - Os "Leitores e Escritores" da ficha
    // Getters = "ler" o que está escrito no campo
    // Setters = "escrever" algo no campo

    /**
     * Pega o número único do livro
     * Como olhar o código de barras
     */
    public Long getId() {
        return id;
    }

    /**
     * Define o número único do livro
     * Normalmente o sistema faz isso automaticamente
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Pega o título do livro
     * Como ler o nome na capa
     */
    public String getTitulo() {
        return titulo;
    }

    /**
     * Define o título do livro
     * Como escrever o nome na ficha
     */
    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    /**
     * Pega quem escreveu o livro
     */
    public String getAutor() {
        return autor;
    }

    /**
     * Define quem escreveu o livro
     */
    public void setAutor(String autor) {
        this.autor = autor;
    }

    /**
     * Pega o ano que o livro foi publicado
     * Pode retornar null se não soubermos o ano
     */
    public Integer getAnoPublicacao() {
        return anoPublicacao;
    }

    /**
     * Define o ano de publicação
     * Pode deixar vazio (null) se não soubermos
     */
    public void setAnoPublicacao(Integer anoPublicacao) {
        this.anoPublicacao = anoPublicacao;
    }

    /**
     * Pega o gênero do livro
     * Ex: "Ficção", "Romance", "Terror"
     */
    public String getGenero() {
        return genero;
    }

    /**
     * Define o gênero do livro
     */
    public void setGenero(String genero) {
        this.genero = genero;
    }

    /**
     * Pega o resumo da história
     */
    public String getSinopse() {
        return sinopse;
    }

    /**
     * Define o resumo da história
     */
    public void setSinopse(String sinopse) {
        this.sinopse = sinopse;
    }

    /**
     * Método toString - "Como mostrar o livro na tela"
     *
     * Quando precisamos exibir as informações do livro de forma bonita,
     * este método formata tudo de maneira organizada.
     *
     * É como criar um cartão de apresentação do livro.
     */
    @Override
    public String toString() {
        return "📚 Livro {" +
                "\n  🆔 id=" + id +
                ",\n  📖 titulo='" + titulo + '\'' +
                ",\n  ✍️ autor='" + autor + '\'' +
                ",\n  📅 anoPublicacao=" + anoPublicacao +
                ",\n  🎭 genero='" + genero + '\'' +
                "\n}";
    }
}