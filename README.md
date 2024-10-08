# Sistema de Gestão de Despesas Mensais

<img src="marcelle.jpg" width="80" he
ight="80">

[Marcelle Neves Sandy](<https://github.com/MarcelleNevesSandy>)

## Descrição Detalhada do Projeto 
Este projeto visa desenvolver um sistema completo para o controle financeiro pessoal ou familiar. O sistema permite a gestão detalhada de receitas e despesas, incluindo a modelagem de dados, criação e manipulação de um banco de dados, e geração de relatórios financeiros avançados. O objetivo é fornecer uma ferramenta eficaz para o monitoramento e planejamento financeiro, com recursos como categorização de despesas, definição de metas financeiras e análises consolidadas. A implementação inclui documentação detalhada, um modelo ER e scripts SQL para todas as operações necessárias.

## Tabelas 

O Sistema de Gestão de Despesas Mensais é estruturado com quatro tabelas principais: Usuarios, Categoria, Movimentacoes, Metas e contas. A tabela Usuarios gerencia as informações dos usuários, enquanto Categoria organiza as receitas e despesas em diferentes categorias. Movimentacoes registra todas as transações financeiras, e Metas permite a definição e acompanhamento de objetivos financeiros específicos.

## Detalhes das Tabelas 

**Na tabela Usuarios, estão presentes as seguintes colunas:**

IdUsuario INT AUTO_INCREMENT PRIMARY KEY NOT NULL<br>
Nome VARCHAR(255) NOT NULL<br>
Email VARCHAR(100) NOT NULL<br>
Senha VARCHAR(8) NOT NULL<br>

**Na tabela Categoria, estão presentes as seguintes colunas:**

IdCategoria INT AUTO_INCREMENT PRIMARY KEY NOT NULL<br>
NomeCategoria VARCHAR(100) NOT NULL<br>
DescricaoCategoria VARCHAR(100) DEFAULT NULL<br>
Tipo VARCHAR(45) NOT NULL<br>

**Na tabela ContasBancarias, estão presentes as seguintes colunas:**

IdContasBancarias INT AUTO_INCREMENT PRIMARY KEY NOT NULL<br>
NomeBanco VARCHAR(45) NOT NULL<br>
AgenciaConta VARCHAR(20) NOT NULL UNIQUE<br>
NumeroConta VARCHAR(20) NOT NULL UNIQUE<br>

**Na tabela <strong>Metas</strong>, estão presentes as seguintes colunas:**

IdMetas INT AUTO_INCREMENT PRIMARY KEY NOT NULL<br>
DescricaoMeta VARCHAR(100) DEFAULT NULL<br>
Tipo VARCHAR(45) NOT NULL<br>
ValorAtual DECIMAL(10,2) NOT NULL<br>
ValorMeta DECIMAL(10,2) NOT NULL<br>
Status VARCHAR(45) NOT NULL<br>
DataFinal DATE NOT NULL<br>

**Na tabela <strong>Movimentacoes</strong>, estão presentes as seguintes colunas:**

IdMovimentacoes INT AUTO_INCREMENT PRIMARY KEY NOT NULL<br>
DescricaoMovimentacoes VARCHAR(100) DEFAULT NULL<br>
Tipo VARCHAR(45) NOT NULL<br>
Valor DECIMAL(10,2) NOT NULL<br>
DataMovimentacao DATE NOT NULL<br>

## Modelo ER
![Modelo ER](image.png)

## Relacionamentos
No banco de dados, as tabelas estão inter-relacionadas para garantir a integridade dos dados. A tabela ContasBancarias referencia Usuarios através da coluna Usuarios_IdUsuario, associando cada conta a um usuário específico. A tabela Metas está vinculada à Categoria por meio da coluna Categoria_IdCategoria, ligando cada meta a uma categoria. As movimentações financeiras na tabela Movimentacoes referenciam tanto ContasBancarias quanto Categoria por suas respectivas chaves estrangeiras (ContasBancarias_IdContasBancarias e Categoria_IdCategoria), assegurando que cada movimentação esteja associada a uma conta e a uma categoria específicas. As regras ON DELETE CASCADE garantem que a exclusão de um usuário, categoria ou conta bancária remova automaticamente as entradas associadas nas tabelas relacionadas.

