# Desafio Técnico

## Descrição

Este projeto foi desenvolvido para atender às necessidades de organização de pedidos de uma pequena lanchonete em crescimento. Atualmente, os pedidos são registrados manualmente em um caderno, o que dificulta o controle do negócio.

## Objetivo

Criar uma estrutura de banco de dados em PostgreSQL capaz de armazenar e organizar informações sobre:

- clientes
- produtos
- categorias
- pedidos
- itens dos pedidos
- pagamentos

## Análise do problema

Com o aumento da demanda, tornou-se necessário centralizar os dados para melhorar:

- o controle dos pedidos
- a identificação dos clientes
- o acompanhamento do status dos pedidos
- o controle dos pagamentos
- a consulta de produtos mais vendidos

## Estrutura proposta

A solução foi modelada com 6 tabelas principais:

- clientes
- categorias
- produtos
- pedidos
- itens_pedido
- pagamentos

## Tecnologias utilizadas

- PostgreSQL
- dbdiagram.io (ou outra ferramenta de modelagem)

## Como executar

1. Criar um banco de dados PostgreSQL.
2. Executar o arquivo `desafio.sql`.
3. Testar os inserts e consultas disponíveis no arquivo.

## Consultas disponíveis

O script contém exemplos de consultas para:

- listar pedidos
- visualizar itens do pedido
- acompanhar pagamentos
- identificar produtos mais vendidos
- calcular faturamento

## Link da modelagem visual

[Diagram](https://dbdiagram.io/d/69c46d0dfb2db18e3b074bb4)
