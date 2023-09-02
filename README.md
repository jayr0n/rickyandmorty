# api_milenio

[![Amber Framework](https://img.shields.io/badge/using-amber_framework-orange.svg)](https://amberframework.org)

This is a project written using [Amber](https://amberframework.org). Enjoy!

## Getting Started

These instructions will get a copy of this project running on your machine for development and testing purposes.

Please see [deployment](https://docs.amberframework.org/amber/deployment) for notes on deploying the project in production.

## Prerequisites

This project requires [Crystal](https://crystal-lang.org/) ([installation guide](https://crystal-lang.org/docs/installation/)).

## Development

To start your Amber server:

1. Install dependencies with `shards install`
2. Build executables with `shards build`
3. Create and migrate your database with `bin/amber db create migrate`. Also see [creating the database](https://docs.amberframework.org/amber/guides/create-new-app#creating-the-database).
4. Start Amber server with `bin/amber watch`

Now you can visit http://localhost:3000/ from your browser.

Getting an error message you need help decoding? Check the [Amber troubleshooting guide](https://docs.amberframework.org/amber/troubleshooting), post a [tagged message on Stack Overflow](https://stackoverflow.com/questions/tagged/amber-framework), or visit [Amber on Gitter](https://gitter.im/amberframework/amber).

Using Docker? Please check [Amber Docker guides](https://docs.amberframework.org/amber/guides/docker).

## Tests

To run the test suite:

```
crystal spec src/testes_unitarios/testes_unitarios.cr
```

## Introduction

API que visa criar ou buscar pontos de viagens no universo de Rikcy and Morty

## Overview

A api apresenta apenas um recurso (/travel_plans) e é através dele que você faz todo tipo de chamada.

## Endpoints da API

### 1. Criação de um novo plano de viagem

- **Endpoint:** POST /travel_plans

- **Exemplo de uso:** POST /travel_plans
  - **Corpo da requisição (Content-Type: application/json):**
    ```json
    {
      "travel_stops": [1, 2]
    }
    ```
  - **Resposta de sucesso (Status: 201, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [1, 2]
    }
    ```

### 2. Obtenção de todos os planos de viagem

- **Endpoint:** GET /travel_plans
- **Query Parameters (opcionais):**

  - optimize (boolean - falso por padrão): Quando verdadeiro, o array de travel_stops é ordenado de maneira a otimizar a viagem.
  - expand (boolean - falso por padrão): Quando verdadeiro, o campo de travel_stops é um array de entidades com informações detalhadas sobre cada parada.

- **Exemplo de uso:** GET /travel_plans
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    [
      {
        "id": 1,
        "travel_stops": [1, 2]
      },
      {
        "id": 2,
        "travel_stops": [3, 7]
      }
    ]
    ```

- **Exemplo de uso:** GET /travel_plans?optimize=false&expand=true
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    [
      {
        "id": 1,
        "travel_stops": [
          {
            "id": 1,
            "name": "Earth (C-137)",
            "type": "Planet",
            "dimension": "Dimension C-137"
          },
          {
            "id": 2,
            "name": "Abadango",
            "type": "Cluster",
            "dimension": "unknown"
          }
        ]
      },
      {
        "id": 2,
        "travel_stops": [
          {
            "id": 3,
            "name": "Citadel of Ricks",
            "type": "Space station",
            "dimension": "unknown"
          },
          {
            "id": 7,
            "name": "Immortality Field Resort",
            "type": "Resort",
            "dimension": "unknown"
          }
        ]
      }
    ]
    ```

### 3. Obtenção de um plano de viagem específico

- **Endpoint:** GET /travel_plans/{id}
- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Query Parameters (opcionais):**

  - optimize (boolean - falso por padrão): Quando verdadeiro, o array de travel_stops é ordenado de maneira a otimizar a viagem.
  - expand (boolean - falso por padrão): Quando verdadeiro, o campo de travel_stops é um array de entidades com informações detalhadas sobre cada parada.

- **Exemplo de uso:** GET /travel_plans/1
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [1, 2, 3]
    }
    ```

- **Exemplo de uso:** GET /travel_plans/1?optimize=false&expand=true
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [
        {
          "id": 1,
          "name": "Earth (C-137)",
          "type": "Planet",
          "dimension": "Dimension C-137"
        },
        {
          "id": 2,
          "name": "Abadango",
          "type": "Cluster",
          "dimension": "unknown"
        }
      ]
    }
    ```

### 4. Atualização de um plano de viagem existente

- **Endpoint:** PUT /travel_plans/{id}

- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Exemplo de uso:** PUT /travel_plans/1

  - **Corpo da requisição (Content-Type: application/json):**

    ```json
    {
      "travel_stops": [4, 5, 6]
    }
    ```

  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [4, 5, 6]
    }
    ```

### 5. Exclusão de um plano de viagem existente

- **Endpoint:** DELETE /travel_plans/{id}

- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Exemplo de uso:** DELETE /travel_plans/1
  - **Resposta de sucesso (Status: 204): Resposta sem corpo**

### 6. Append(Adiciona) um novo travel_stop no fim do travel_stops

- **Endpoint:** PUT /travel_plans/{id}/append

- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Exemplo de uso:** PUT /travel_plans/1/append

  - **Corpo da requisição (Content-Type: application/json):**

    ```json
    {
      "travel_stops": 4
    }
    ```

  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [1, 5, 6, 4]
    }
    ```

## Parâmetros Modificadores

Os parâmetros `expand` e `optimize` podem ser utilizados para modificar as respostas da API. Ambos podem ser utilizados separadamente ou em conjunto, apenas para métodos GET. 

### expand

Ao receber esse parâmetro, a API deve expandir as paradas de cada viagem de modo que o campo `travel_stops` deixe de ser um array de inteiros representando os IDs de cada localização e passe a ser um array de objetos da forma

```json
{
  "id": 1,
  "name": "Earth (C-137)",
  "type": "Planet",
  "dimension": "Dimension C-137"
}
```

populado com os dados da respectiva localização registrada na Rick and Morty API sob o dado ID.

### optimize

Ao receber esse parâmetro, a API deve retornar o array de `travel_stops` reordenado com o objetivo de minimizar o número de saltos interdimensionais e organizar as paradas de viagem passando das localizações menos populares para as mais populares. 
  
## Contributors

- [jayron88](https://github.com/jayron88) jayron88 - creator, maintainer
