# Sistema de Catálogo de Livros
## Relatório Técnico e Manual do Usuário

**Desenvolvido por:** Rafael narciso da silva 
**Instituição:** Unicid Universidade Cidade de São Paulo
**Data:** Dezembro 2025  
**Versão:** 1.0

---

## Sumário

1. [Introdução](#1-introdução)
2. [Metodologia](#2-metodologia)
3. [Modelagem do Sistema](#3-modelagem-do-sistema)
4. [Desenvolvimento e Implementação](#4-desenvolvimento-e-implementação)
5. [Resultados](#5-resultados)
6. [Considerações sobre Segurança](#6-considerações-sobre-segurança)
7. [Conclusões](#7-conclusões)
8. [Referências](#8-referências)
9. [Manual do Usuário](#9-manual-do-usuário)
10. [Documentação do Código](#10-documentação-do-código)

---

## 1. Introdução

### 1.1 Apresentação do Projeto

O Sistema de Catálogo de Livros é uma aplicação web desenvolvida para gerenciar uma biblioteca digital simples. O sistema permite aos usuários cadastrar, visualizar, editar, excluir e buscar livros de forma intuitiva e eficiente.

### 1.2 Objetivos

**Objetivo Geral:**
Criar um sistema completo de gerenciamento de catálogo de livros utilizando tecnologias web Java.

**Objetivos Específicos:**
- Implementar operações CRUD (Create, Read, Update, Delete) para livros
- Desenvolver interface web responsiva e moderna
- Aplicar padrões de arquitetura MVC
- Garantir validação de dados tanto no frontend quanto backend
- Implementar sistema de busca por título e autor

### 1.3 Justificativa

O projeto serve como exemplo prático de desenvolvimento web em Java, demonstrando boas práticas de arquitetura, separação de responsabilidades e implementação de funcionalidades essenciais para sistemas de informação.

---

## 2.  Metodologia

### 2.1 Abordagem de Desenvolvimento

Foi adotada uma abordagem **iterativa e incremental**, onde o sistema foi desenvolvido em ciclos:

1. **Iteração 1:** Modelagem e estrutura básica (Model, DAO)
2. **Iteração 2:** Controladores e lógica de negócio (Servlet)
3. **Iteração 3:** Interface de usuário (JSP)
4. **Iteração 4:** Validações e tratamento de erros
5. **Iteração 5:** Melhorias visuais e responsividade

### 2.2 Tecnologias Utilizadas

| Tecnologia | Versão | Função |
|------------|--------|--------|
| Java | 8+ | Linguagem de programação principal |
| Servlets | 3.1 | Controladores da aplicação |
| JSP | 2.3 | Interface de usuário e apresentação |
| JSTL | 1.2 | Biblioteca de tags para JSP |
| JDBC | - | Conectividade com banco de dados |
| PostgreSQL | 12+ | Sistema de gerenciamento de banco de dados |
| HTML5/CSS3 | - | Estrutura e estilização das páginas |
| JavaScript | ES6 | Validações frontend e interatividade |

---

## 3. Modelagem do Sistema

### 3.1 Diagrama de Casos de Uso

```
┌─────────────────────────────────────────┐
│            Sistema de Catálogo          │
│                                         │
│  ┌─────────────┐    ┌─────────────────┐ │
│  │             │    │ Cadastrar Livro │ │
│  │             │◄──►│                 │ │
│  │             │    └─────────────────┘ │
│  │             │    ┌─────────────────┐ │
│  │  Usuário    │◄──►│ Listar Livros   │ │
│  │             │    └─────────────────┘ │
│  │             │    ┌─────────────────┐ │
│  │             │◄──►│ Buscar Livros   │ │
│  │             │    └─────────────────┘ │
│  │             │    ┌─────────────────┐ │
│  │             │◄──►│ Editar Livro    │ │
│  │             │    └─────────────────┘ │
│  │             │    ┌─────────────────┐ │
│  │             │◄──►│ Excluir Livro   │ │
│  └─────────────┘    └─────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### 3.2 Diagrama de Classes Principal

```
┌──────────────────────────────────┐
│            Livro                 │
├──────────────────────────────────┤
│ - id: Long                       │
│ - titulo: String                 │
│ - autor: String                  │
│ - anoPublicacao: Integer         │
│ - genero: String                 │
│ - sinopse: String                │
├──────────────────────────────────┤
│ + getId(): Long                  │
│ + setId(Long): void              │
│ + getTitulo(): String            │
│ + setTitulo(String): void        │
│ + getAutor(): String             │
│ + setAutor(String): void         │
│ + getAnoPublicacao(): Integer    │
│ + setAnoPublicacao(Integer): void│
│ + getGenero(): String            │
│ + setGenero(String): void        │
│ + getSinopse(): String           │
│ + setSinopse(String): void       │
│ + toString(): String             │
└──────────────────────────────────┘
                │
                │ 1..*
                ▼
┌─────────────────────────────────┐
│           LivroDAO              │
├─────────────────────────────────┤
│ + inserir(Livro): boolean       │
│ + listarTodos(): List<Livro>    │
│ + buscarPorId(Long): Livro      │
│ + buscar(String): List<Livro>   │
│ + atualizar(Livro): boolean     │
│ + excluir(Long): boolean        │
└─────────────────────────────────┘
                │
                │ uses
                ▼
┌──────────────────────────────────┐
│          ConexaoBD               │
├──────────────────────────────────┤
│ + getConexao(): Connection       │
│ + fecharConexao(Connection): void│
│ + testarConexao(): boolean       │
│ + exibirConfiguracoes(): void    │
└──────────────────────────────────┘
                │
                │ controls
                ▼
┌────────────────────────────────────┐
│         LivroServlet               │
├────────────────────────────────────┤
│ - livroDAO: LivroDAO               │
├────────────────────────────────────┤
│ + doGet(HttpServletRequest,        │
│         HttpServletResponse): void │
│ + doPost(HttpServletRequest,       │
│          HttpServletResponse): void│
│ - listarLivros(): void             │
│ - mostrarDetalhes(): void          │
│ - criarLivro(): void               │
│ - atualizarLivro(): void           │
│ - excluirLivro(): void             │
│ - validarLivro(): boolean          │
└────────────────────────────────────┘
```

### 3.3 Esquema do Banco de Dados

#### 3.3.1 Diagrama Entidade-Relacionamento (DER)

```
┌───────────────────────────────────┐
│              LIVRO                │
├───────────────────────────────────┤
│ PK  id (BIGSERIAL)                │
│     titulo (VARCHAR(255)) NOT NULL│
│     autor (VARCHAR(255)) NOT NULL │
│     ano_publicacao (INTEGER)      │
│     genero (VARCHAR(100))         │
│     sinopse (TEXT)                │
└───────────────────────────────────┘
```

#### 3.3.2 Script SQL de Criação

```sql
-- Criação do banco de dados
CREATE DATABASE catalogolivros;

-- Criação da tabela livro
CREATE TABLE livro (
    id BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    ano_publicacao INTEGER,
    genero VARCHAR(100),
    sinopse TEXT,
    
    -- Constraints
    CONSTRAINT ck_livro_titulo_nao_vazio CHECK (titulo <> ''),
    CONSTRAINT ck_livro_autor_nao_vazio CHECK (autor <> ''),
    CONSTRAINT ck_livro_ano_valido CHECK (ano_publicacao >= 1000 AND ano_publicacao <= 2030)
);

-- Índices para otimizar buscas
CREATE INDEX idx_livro_titulo ON livro(titulo);
CREATE INDEX idx_livro_autor ON livro(autor);
CREATE INDEX idx_livro_genero ON livro(genero);

-- Inserção de dados de exemplo
INSERT INTO livro (titulo, autor, ano_publicacao, genero, sinopse) VALUES
('Dom Casmurro', 'Machado de Assis', 1899, 'Romance', 'A história de Bentinho e Capitu, um dos maiores clássicos da literatura brasileira.'),
('O Cortiço', 'Aluísio Azevedo', 1890, 'Realismo', 'Romance naturalista que retrata a vida em um cortiço no Rio de Janeiro do século XIX.'),
('1984', 'George Orwell', 1949, 'Ficção Científica', 'Distopia sobre um regime totalitário que controla todos os aspectos da vida.');
```

---

## 4. Desenvolvimento e Implementação

### 4.1 Arquitetura Geral da Aplicação

A aplicação segue o padrão **MVC (Model-View-Controller)** com a seguinte estrutura:

```
src/
├── com/catalogo/
│   ├── model/         # Entidades (Model)
│   │   └── Livro.java
│   ├── dao/           # Acesso a dados
│   │   └── LivroDAO.java
│   ├── servlet/       # Controladores (Controller)
│   │   └── LivroServlet.java
│   └── util/          # Utilitários
│       └── ConexaoBD.java
└── webapp/
    ├── WEB-INF/       # Visões (View)
    │   ├── listar.jsp
    │   ├── detalhes.jsp
    │   ├── formulario.jsp
    │   └── erro.jsp
    └── index.jsp
```

### 4.2 Implementação de Funcionalidades-Chave

#### 4.2.1 Funcionalidade de Cadastro

**Servlet (Controlador):**
```java
private void criarLivro(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // Cria objeto Livro a partir do formulário
    Livro livro = criarLivroDoRequest(request);
    
    // Valida os dados
    if (validarLivro(livro, request)) {
        // Dados válidos - tenta salvar no banco
        if (livroDAO.inserir(livro)) {
            // Sucesso - redireciona com mensagem
            response.sendRedirect(request.getContextPath() + 
                "/livros?sucesso=Livro cadastrado com sucesso");
        } else {
            // Erro ao salvar
            request.setAttribute("erro", "Erro ao salvar livro");
            request.getRequestDispatcher("/WEB-INF/formulario.jsp")
                .forward(request, response);
        }
    } else {
        // Dados inválidos - volta para o formulário
        request.setAttribute("livro", livro);
        request.getRequestDispatcher("/WEB-INF/formulario.jsp")
            .forward(request, response);
    }
}
```

**DAO (Acesso a Dados):**
```java
public boolean inserir(Livro livro) {
    String sql = "INSERT INTO livro (titulo, autor, ano_publicacao, genero, sinopse) VALUES (?, ?, ?, ?, ?)";
    
    try (Connection conn = ConexaoBD.getConexao(); 
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        stmt.setString(1, livro.getTitulo());
        stmt.setString(2, livro.getAutor());
        stmt.setObject(3, livro.getAnoPublicacao());
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
```

#### 4.2.2 Funcionalidade de Busca

**Servlet (Controlador):**
```java
private void realizarBusca(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String termo = request.getParameter("termo");
    
    if (termo != null && !termo.trim().isEmpty()) {
        // Realiza busca por termo
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
```

---

## 5. Resultados

O sistema foi desenvolvido com sucesso e apresenta as seguintes funcionalidades implementadas:

### 5.1 Tela Principal - Listagem de Livros
- Exibe todos os livros cadastrados em formato de tabela
- Sistema de busca por título ou autor
- Botões de ação para cada livro (Ver, Editar, Excluir)
- Contador de resultados
- Design responsivo com tema de biblioteca

### 5.2 Tela de Detalhes do Livro
- Visualização completa de todas as informações do livro
- Layout organizado com cards informativos
- Botões para editar ou excluir o livro
- Navegação intuitiva de volta à lista

### 5.3 Tela de Formulário (Cadastro/Edição)
- Formulário adaptável para cadastro e edição
- Validação em tempo real
- Campos obrigatórios claramente identificados
- Lista pré-definida de gêneros
- Mensagens de erro específicas por campo

### 5.4 Características Visuais
- Design moderno com efeito glass morphism
- Imagem de fundo temática (biblioteca)
- Interface responsiva para dispositivos móveis
- Animações e transições suaves
- Paleta de cores consistente

---

## 6. Considerações sobre Segurança

### 6.1 Medidas Implementadas

**Prevenção de SQL Injection:**
- Uso exclusivo de PreparedStatement para todas as consultas SQL
- Parametrização de todas as queries com placeholders (?)

**Prevenção de XSS (Cross-Site Scripting):**
- Uso da tag `<c:out>` do JSTL para sanitização de dados
- Escape automático de caracteres especiais em todos os outputs

**Validação de Dados:**
- Validação dupla: frontend (JavaScript) e backend (Java)
- Verificação de tipos e ranges para campos numéricos
- Limitação de tamanho para campos de texto

**Configuração Segura do Banco:**
- Uso de variáveis de ambiente para credenciais
- Conexões com timeout configurado
- Fechamento automático de recursos (try-with-resources)

### 6.2 Recomendações para Produção
- Implementar HTTPS
- Adicionar autenticação e autorização
- Rate limiting para prevenção de ataques DDoS
- Auditoria de logs de acesso
- Backup automatizado do banco de dados

---

## 7. Conclusões

### 7.1 Dificuldades Encontradas
- **Integração JDBC-PostgreSQL:** Configuração inicial de drivers e conexão
- **Responsividade CSS:** Ajustar layout para diferentes tamanhos de tela
- **Validação Dupla:** Sincronizar validações frontend e backend
- **Gerenciamento de Estado:** Manter consistência entre operações CRUD

### 7.2 Aprendizados
- Aplicação prática do padrão MVC em Java Web
- Importância da validação em múltiplas camadas
- Uso efetivo de JSTL para separação de lógica e apresentação
- Implementação de design responsivo e moderno
- Boas práticas de segurança em aplicações web

### 7.3 Possíveis Trabalhos Futuros
- **Sistema de Autenticação:** Login de usuários e perfis de acesso
- **Categorização Avançada:** Sistema de tags e filtros múltiplos
- **Empréstimos:** Controle de empréstimos de livros
- **Relatórios:** Dashboard com estatísticas e relatórios
- **API REST:** Exposição de serviços para integração mobile
- **Busca Avançada:** Filtros por múltiplos campos simultaneamente

---

## 8. Referências

1. **Oracle Corporation.** Java Servlet Specification 3.1. Oracle, 2013.
2. **Oracle Corporation.** JavaServer Pages Specification 2.3. Oracle, 2013.
3. **Gonçalves, E.** Desenvolvendo Aplicações Web com JSP, Servlets e JSTL. Ciência Moderna, 2007.
4. **PostgreSQL Global Development Group.** PostgreSQL Documentation. Disponível em: https://www.postgresql.org/docs/
5. **Apache Software Foundation.** Apache Tomcat Documentation. Disponível em: https://tomcat.apache.org/tomcat-9.0-doc/
6. **Oracle Corporation.** JDBC API Documentation. Disponível em: https://docs.oracle.com/javase/8/docs/technotes/guides/jdbc/
7. **Freeman, E., Freeman, E.** Head First Design Patterns. O'Reilly Media, 2004.
8. **Martin, R.** Clean Code: A Handbook of Agile Software Craftsmanship. Prentice Hall, 2008.

---

## 9. Manual do Usuário

### Bem-vindo ao seu Catálogo Digital!

Este manual vai te ensinar tudo que você precisa saber para usar o sistema de forma rápida e eficiente.

### 9.1 Primeiros Passos

#### Como Acessar o Sistema
1. Abra seu navegador (Chrome, Firefox, Safari, etc.)
2. Digite o endereço: `http://localhost:8080/catalogo`
3. Pronto! Você será direcionado automaticamente para a lista de livros

#### O Que Você Vai Ver
A tela principal mostra todos os seus livros organizados em uma tabela bonita, com fundo de biblioteca.

### 9.2 Funcionalidades Principais

#### 1. Ver Todos os Livros
- Ao entrar no sistema, você vê automaticamente todos os livros cadastrados
- Os livros aparecem organizados em ordem alfabética
- Cada linha mostra: título, autor, ano, gênero e botões de ação

#### 2. Buscar Livros
**Como buscar:**
1. Na caixa "Buscar por título ou autor...", digite o que procura
2. Clique em "Buscar"
3. O sistema mostra apenas os livros que combinam com sua busca

**Dicas de busca:**
- Você pode buscar por parte do título: "Dom" vai encontrar "Dom Casmurro"
- Funciona com nomes de autores também: "Machado" encontra livros do Machado de Assis
- Para ver todos os livros novamente, clique em "Limpar"

#### 3. Cadastrar Livro Novo
**Passo a passo:**
1. Clique no botão verde "Novo Livro"
2. Preencha as informações:
   - **Título*** (obrigatório)
   - **Autor*** (obrigatório)
   - **Ano de Publicação** (opcional, mas deve estar entre 1000 e 2030)
   - **Gênero** (escolha da lista ou deixe em branco)
   - **Sinopse** (resumo do livro, até 1000 caracteres)
3. Clique em "Cadastrar Livro"
4. Se deu certo, você volta para a lista com uma mensagem verde de sucesso!

> **Atenção:** Campos marcados com * são obrigatórios!

#### 4. Ver Detalhes do Livro
**Como ver:**
1. Na lista, clique no título do livro (ele fica azul)
2. OU clique no botão azul "Ver"

**O que você vê:**
- Todas as informações do livro organizadas
- Título e autor em destaque
- Ano e gênero em cards informativos
- Sinopse completa (se houver)

#### 5. Editar Livro
**Como editar:**
1. Na lista, clique no botão cinza "Editar"
2. OU na página de detalhes, clique em "Editar"
3. Modifique os campos que desejar
4. Clique em "Atualizar Livro"

> **Dica:** O formulário já vem preenchido com as informações atuais!

#### 6. Excluir Livro
**Como excluir:**
1. Na lista, clique no botão vermelho "Excluir"
2. OU na página de detalhes, clique em "Excluir"
3. Confirme na janela que aparece

> **Cuidado:** Não dá para desfazer esta ação!

### 9.3 Usando no Celular

O sistema funciona perfeitamente no celular! As tabelas se ajustam automaticamente e os botões ficam do tamanho certo para tocar com o dedo.

### 9.4 Entendendo as Cores

- **Verde:** Ações de criar/adicionar
- **Azul:** Ações de visualizar/detalhes
- **Cinza:** Ações de editar/modificar
- **Vermelho:** Ações de excluir/remover

### 9.5 Problemas Comuns e Soluções

| Problema | Solução |
|----------|---------|
| "Não consigo cadastrar um livro" | Verifique se preencheu título e autor (são obrigatórios) e se o ano está entre 1000 e 2030 |
| "A busca não encontra nada" | Verifique a grafia ou tente buscar apenas parte da palavra |
| "A página não carrega" | Verifique se o servidor está rodando e se o endereço está correto |
| "Excluí um livro por engano" | Infelizmente não dá para recuperar. Cadastre novamente se necessário |

### 9.6 Instalação (Para Administradores)

#### Pré-requisitos
- Java 8 ou superior
- Apache Tomcat 9.0
- PostgreSQL 12 ou superior

#### Passos de Instalação
1. **Configure o Banco de Dados:**
   ```sql
   CREATE DATABASE catalogolivros;
   ```
   Execute o script SQL fornecido na documentação técnica

2. **Configure as Variáveis de Ambiente:**
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=catalogolivros
   DB_USER=seu_usuario
   DB_PASSWORD=sua_senha
   ```

3. **Deploy no Tomcat:**
   - Copie o arquivo `catalogo.war` para a pasta `webapps` do Tomcat
   - Reinicie o Tomcat
   - Acesse `http://localhost:8080/catalogo`

---

## 10. Documentação do Código

### 10.1 Padrão de Comentários

O código fonte foi documentado seguindo duas abordagens:

1. **Javadoc** para métodos públicos das classes principais
2. **Comentários explicativos** em linguagem simples para facilitar compreensão

### 10.2 Exemplo de Documentação Javadoc

```java
/**
 * Insere um novo livro no banco de dados.
 * 
 * O método utiliza PreparedStatement para prevenir SQL injection e
 * recupera automaticamente o ID gerado pelo banco de dados.
 * 
 * @param livro O objeto Livro a ser inserido. Não pode ser null.
 * @return true se o livro foi inserido com sucesso, false caso contrário
 * @throws IllegalArgumentException se o livro for null
 * 
 * @example
 * <pre>
 * Livro novoLivro = new Livro("1984", "George Orwell", 1949, "Ficção", "Distopia...");
 * LivroDAO dao = new LivroDAO();
 * boolean sucesso = dao.inserir(novoLivro);
 * </pre>
 */
public boolean inserir(Livro livro) {
    // implementação...
}
```

### 10.3 Características dos Comentários

- **Linguagem simples e direta:** Evita jargões técnicos desnecessários
- **Explicações práticas:** Foca no que o código faz na prática
- **Analogias:** Usa comparações com situações do mundo real
- **Exemplos:** Inclui exemplos de uso quando apropriado

### 10.4 Estrutura de Comentários por Arquivo

#### Model (Livro.java)
- Comentários sobre cada atributo e sua função
- Documentação dos métodos getters e setters
- Explicação do método toString()

#### DAO (LivroDAO.java)
- Javadoc completo para todos os métodos públicos
- Comentários sobre tratamento de exceções
- Explicações sobre otimizações de consulta

#### Servlet (LivroServlet.java)
- Documentação do fluxo de controle
- Comentários sobre validações
- Explicações sobre redirecionamentos e forwards

#### JSP (Páginas de Interface)
- Comentários sobre estrutura HTML/CSS
- Explicações sobre uso de JSTL
- Documentação de JavaScript para validações

---

**Fim da Documentação**

*Sistema de Catálogo de Livros - Versão 1.0*