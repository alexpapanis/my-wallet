# my-wallet


## Instalação

Após fazer o clone do projeto, abrir o Terminal e executar:
```sh
pod install
```
Se não tiver Cocoapods instalado, [clique aqui](https://guides.cocoapods.org/using/getting-started.html).

## Descrição

Ao inicializar o aplicativo pela primeira vez, o usuário recebe um saldo de R$ 100.000,00 no qual ele pode escolher comprar uma das 2 moedas disponíveis: Brita e Bitcoin. 

Na tela inicial são exibidas as informações das moedas e de sua carteira. Na carteira, é possível visualizar a quantidade comprada de cada moeda e qual o valor total delas na cotação atual. Mais abaixo é possível ter um controle total da carteira, com o saldo disponível para investimento, o capital atual (saldo + valor total das moedas) e o lucro (diferença do capital atual com o aporte inicial de R$ 100.000,00).

Ao clicar em cima da cotação - de compra ou venda - da moeda é exibida uma janela onde ele escolhe a quantidade e efetiva a transação. Neste momento há diversas regras de validação, como: usuário não pode comprar valores superiores ao saldo disponível e usuário não pode vender mais moedas do que ele possui.

No botão azul, no canto inferior direito, é possível visualizar todas as transações de compra e venda. 
