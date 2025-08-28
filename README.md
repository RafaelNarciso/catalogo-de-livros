# Catálogo de Livros

Sistema web para catalogar e gerenciar livros utilizando Java, JSP, Servlets e PostgreSQL.

## 📋 Requisitos do Sistema

### Funcionais
- Cadastro de novos livros
- Listagem de todos os livros catalogados
- Visualização detalhada de cada livro
- Edição de informações dos livros
- Exclusão de livros do catálogo
- Busca simples por título ou autor
- Interface web responsiva

### Não Funcionais
- Persistência de dados em PostgreSQL
- Interface simples e intuitiva
- Validação de dados de entrada
- Tratamento de erros
- Codificação UTF-8

## 🛠️ Tecnologias Utilizadas

- **Java 11+** - Linguagem de programação principal
- **JSP** - JavaServer Pages para interface web
- **Servlets** - Controladores HTTP
- **JDBC** - Conectividade com banco de dados
- **PostgreSQL** - Sistema de gerenciamento de banco
- **Apache Tomcat** - Servidor de aplicação
- **Maven** - Gerenciamento de dependências
- **HTML/CSS** - Interface do usuário

## 🚀 Como Executar

### Pré-requisitos
1. **Java JDK 11+**
2. **Apache Tomcat 9+**
3. **PostgreSQL 12+**
4. **Maven 3.6+**

### Configuração do Banco de Dados

1. **Instale o PostgreSQL**
2. **Crie o banco de dados:**
```sql
CREATE DATABASE catalogolivros;
```

3. **Execute o script de criação:**
```sql
\c catalogolivros;

CREATE TABLE livro (
    id BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    ano_publicacao INTEGER,
    genero VARCHAR(100),
    sinopse TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dados de exemplo
INSERT INTO livro (titulo, autor, ano_publicacao, genero, sinopse) VALUES
('Dom Casmurro', 'Machado de Assis', 1899, 'Romance', 'Romance que narra a história de Bentinho e Capitu.'),
('1984', 'George Orwell', 1949, 'Distopia', 'Retrata uma sociedade totalitária onde o governo controla todos os aspectos da vida.');
```

### Configuração das Variáveis de Ambiente

Configure as seguintes variáveis de ambiente:

**Windows:**
```cmd
set DB_NAMEEE=catalogolivros
set DB_USER=postgres
set DB_PASSWORD=sua_senha
set DB_HOST=localhost
set DB_PORT=5432
```

**Linux/Mac:**
```bash
export DB_NAMEEE=catalogolivros
export DB_USER=postgres
export DB_PASSWORD=sua_senha
export DB_HOST=localhost
export DB_PORT=5432
```

### Compilação e Deploy

1. **Clone o repositório**
2. **Compile o projeto:**
```bash
mvn clean compile install
```

3. **Configure o Tomcat no IDE:**
   - Adicione as variáveis de ambiente
   - Configure o deployment artifact
   - Application context: `/catalogo-livros`

4. **Inicie o servidor Tomcat**

5. **Acesse a aplicação:**
```
http://localhost:8080/catalogo-livros/livros
```

## 📁 Estrutura do Projeto

```
catalogo-livros/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── catalogo/
│       │           ├── dao/
│       │           │   └── LivroDAO.java
│       │           ├── model/
│       │           │   └── Livro.java
│       │           ├── servlet/
│       │           │   └── LivroServlet.java
│       │           └── util/
│       │               └── ConexaoBD.java
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── jsp/
│           │   │   ├── listar.jsp
│           │   │   ├── detalhes.jsp
│           │   │   ├── formulario.jsp
│           │   │   └── erro.jsp
│           │   └── web.xml
│           └── index.jsp
└── pom.xml
```

## 🔧 Funcionalidades

### Operações CRUD
- **CREATE** - Cadastrar novos livros
- **READ** - Listar e visualizar livros
- **UPDATE** - Editar informações
- **DELETE** - Remover livros

### Recursos Adicionais
- Busca por título ou autor
- Validação de formulários
- Tratamento de erros
- Interface responsiva
- Mensagens de feedback

## 🔒 Segurança

- Uso de `PreparedStatement` para prevenir SQL Injection
- Sanitização de dados de entrada
- Validação server-side
- Uso de `<c:out>` nas JSPs para prevenir XSS
- Configuração de variáveis de ambiente para credenciais

## 📊 Modelo de Dados

### Entidade Livro
```java
public class Livro {
    private Long id;
    private String titulo;        // Obrigatório
    private String autor;         // Obrigatório
    private Integer anoPublicacao;
    private String genero;
    private String sinopse;
}
```

## 🐛 Resolução de Problemas

### Erro 404 ao acessar /livros
1. Verificar se as classes foram compiladas
2. Confirmar package declarations
3. Verificar deployment no Tomcat

### Erro de Conexão com Banco
1. Verificar se PostgreSQL está rodando
2. Confirmar variáveis de ambiente
3. Testar credenciais de acesso

### Erro de Compilação
1. Verificar JDK instalado
2. Executar `mvn clean compile install`
3. Verificar dependências no pom.xml

## 📚 URLs da Aplicação

- **Lista de livros:** `/livros`
- **Novo livro:** `/livros?action=novo`
- **Editar livro:** `/livros?action=editar&id={id}`
- **Buscar:** `/livros?action=buscar&termo={termo}`
- **Detalhes:** `/livros/{id}`

## 👥 Desenvolvimento

Este projeto foi desenvolvido como parte do Projeto Integrador Transdisciplinar, aplicando conceitos de:

- Programação Orientada a Objetos
- Padrão MVC (Model-View-Controller)
- Padrão DAO (Data Access Object)
- Desenvolvimento Web com Java
- Integração com banco de dados relacional

## 📄 Licença

Projeto acadêmico desenvolvido para fins educacionais.
