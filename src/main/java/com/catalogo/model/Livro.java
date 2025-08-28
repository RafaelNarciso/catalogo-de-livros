package com.catalogo.model;

public class Livro {
    private Long id;
    private String titulo;
    private String autor;
    private Integer anoPublicacao;
    private String genero;
    private String sinopse;

    // Construtor padrão
    public Livro() {
    }

    // Construtor completo
    public Livro(String titulo, String autor, Integer anoPublicacao, String genero, String sinopse) {
        this.titulo = titulo;
        this.autor = autor;
        this.anoPublicacao = anoPublicacao;
        this.genero = genero;
        this.sinopse = sinopse;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public Integer getAnoPublicacao() {return anoPublicacao;
    }

    public void setAnoPublicacao(Integer anoPublicacao) {
        this.anoPublicacao = anoPublicacao;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public String getSinopse() {
        return sinopse;
    }

    public void setSinopse(String sinopse) {
        this.sinopse = sinopse;
    }
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
