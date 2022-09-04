import numpy as np
import Tarefa1

### Mastigado do enunciado:
# Implemente o algoritmo de mínimos quadrados alternados para obtenção de fatorações não negativas.

#Normaliza (tranforma em módulo 1) cada coluna de W
def normaliza(W): #Funciona
    W = W.transpose()
    for i in range(W.shape[0]):
        divisor = np.sum(np.square(W[i]))**(1/2)
        if divisor != 0:
            W[i] = W[i]/divisor
    return W.transpose()

#Calcula a norma quadrática do Erro entre os termos da Matriz original com os das matrizes fatoradas
def normaErro(A, W, H):
    E = A - np.dot(W,H)
    E = np.sum(np.square(E))
    return E

#Main foi feita seguindo o enunciado
def main(A, p):
    E_0 = 1
    n = A.shape[0] #Número de linhas de A
    m = A.shape[1] #Número de colunas de A

    #Inicialize um W(nxp) randômico com valores positivos
    W = np.random.rand(n,p)

    copia = np.copy(A) #Cópia de A

    #Enquanto diferença da norma dos erros consecutivos > 10^-5 ou itmax = 100
    itmax = 100
    for i in range(0, itmax):
        W = normaliza(W) #Normalize W
        
        A = np.copy(copia)
        H = Tarefa1.Sol_linSis_simult(W,A,p) #Resolva MMQ WH = A, determinando H

        #Redefina H
        H[H<0] = 0

        A = np.copy(copia)
        #Resolva MMQ H_t W_t = A_t, determinando W_t
        W = Tarefa1.Sol_linSis_simult(H.transpose(),A.transpose(),p)

        W = W.transpose()
        W[W<0] = 0 #Redefina W

        #Calcular erro
        E_1 = normaErro(A, W, H)
        if ((abs(E_1 - E_0) < (10 ** -5)) & (i != 0)):
            break
        else:
            E_0 = E_1
    return W, H

#-------------------------------- TESTES --------------------------------#
#Teste 1 - Exemplo do enunciado. Resultado: Perfeito
# A_teste = np.array([[3/10,3/5,0],[1/2,0,1],[4/10,4/5,0]])
# p_teste = 2

#Teste 2 - Exemplo da internet. Resultado: A bateu
#A_teste = np.array([[4.,6,0],[6,4,0],[0,0,0]])
# p_teste = 2

#Teste 3 - Exemplo da internet. Resultado: A bateu.
# A_teste = np.array([[1,2,3,5],[2,4,8,12],[3,6,7,13]])
# p_teste = 3

#Teste 4 - Inventei. Resultado: Deu bom
# A_teste = np.array([[25,13,9,13,46],[23,13,7,10,41],[26,14,10,16,50],[28,15,12,19,55],[25,13,9,16,49]])
# p_teste = 2

#Teste 5 - Inventei. Resultado: Deu bom
# A_teste = np.array([[4,6,8,5,7],[2,3,4,5,1],[4,6,8,5,7],[2,3,4,5,1],[4,6,8,5,7]])
# p_teste = 2

#Teste 6 - Inventei. Resultado: A deu ruim!
# A_teste = np.array([[4,6,8,5],[0,13,14,15],[24,26,28,0],[32,33,0,35],[22,13,10,45]])
# p_teste = 3

#Teste 7 - Inventei. Resultado: Deu ruim
# A_teste = np.array([[4,0,8,5,4,6,7,8,0,8,1,4,6,7,8],
#                     [8,5,4,6,0,5,4,6,0,8,1,4,6,7,8],
#                     [4,6,8,0,4,6,3,4,0,8,1,4,6,7,8],
#                     [8,0,4,6,8,5,4,0,0,8,1,4,5,7,8],
#                     [4,0,8,5,4,6,8,4,0,8,1,4,5,7,8],
#                     [0,6,8,5,4,6,0,1,0,8,1,4,5,7,8],
#                     [5,4,0,8,5,4,6,0,1,8,1,4,5,7,8],
#                     [0,6,8,0,4,6,8,5,1,8,5,4,5,4,8],
#                     [0,4,6,8,5,4,6,8,1,7,5,4,6,4,8],
#                     [0,0,8,5,4,0,8,6,1,7,5,4,6,4,8],
#                     [4,0,8,5,4,6,7,8,0,7,5,4,6,4,3],
#                     [4,0,8,5,2,6,7,8,0,8,5,4,6,4,3],
#                     [4,2,8,5,2,6,7,8,0,8,3,4,6,4,3],
#                     [4,2,8,5,2,6,7,9,1,8,3,4,6,4,3],
#                     [4,2,8,5,2,1,7,9,0,8,3,4,6,7,3],
#                     [4,2,8,5,2,6,7,9,0,8,3,4,6,7,8],
#                     [4,2,8,5,2,6,7,9,0,8,3,4,6,7,8],
#                     [4,0,8,5,4,6,3,8,0,8,3,4,6,7,8],
#                     [4,0,8,5,4,6,3,8,0,8,3,4,6,7,8],
#                     [4,0,8,5,4,6,3,8,0,8,3,4,6,7,8],
#                     [4,0,8,5,4,6,3,8,0,8,3,4,6,7,8],
#                     [4,0,8,5,4,2,3,8,0,8,3,4,6,7,8],
#                     [4,0,8,5,4,2,3,8,1,8,3,4,6,7,8],
#                     [4,0,8,5,4,2,3,8,1,8,5,4,6,7,8],
#                     [4,0,8,5,4,2,3,8,1,8,5,4,6,7,8],
#                     [5,4,0,8,5,4,6,0,1,8,1,4,5,7,8],
#                     [5,4,0,8,5,4,6,0,1,8,1,4,5,7,8],
#                     [5,4,0,8,5,4,6,0,1,8,1,4,5,7,8],
#                     [5,2,0,8,5,4,6,0,1,8,1,4,5,7,8],
#                     [5,2,0,8,5,4,6,0,1,8,1,4,5,7,8],
#                     [5,2,0,8,5,4,6,0,1,8,1,4,5,7,9],
#                     [5,2,0,8,5,4,6,0,1,8,1,4,5,7,9],
#                     [5,2,0,8,5,4,6,0,1,3,1,4,5,7,9],
#                     [5,2,0,8,5,4,6,0,1,3,1,4,5,7,9],
#                     [5,4,0,8,5,4,6,0,1,3,1,4,5,7,9],
#                     [5,4,0,8,5,4,6,0,1,3,1,4,5,7,9],
#                     [5,4,0,8,5,4,6,0,1,8,1,4,5,7,9],
#                     [4,0,8,5,4,6,3,8,0,8,5,4,6,7,9]])
# p_teste = 8

#Teste 8 - Inventei.
# A_teste = np.array([[1,1,4],[3,2,3],[1,3,1],[1,4,3],[5,2,2]])
# p_teste = 2

#Teste 9 - Bem simples. Deu bom
# A_teste = np.array([[1,1],[3,8]])
# p_teste = 2
#-------------------------------- TESTES --------------------------------#

# Código:

# W, H = main(A_teste, p_teste)

# print('W')
# print(W)
# print('H')
# print(H)
# print('O resultado da fatoração WH é:')
# print(np.dot(W, H))

# E_sem = np.sqrt(np.sum(np.square(np.dot(W,H) - A_teste)))
# n, m = A_teste.shape[0], A_teste.shape[1]
# print('Erro médio por entrada')
# print(E_sem/(n * m))