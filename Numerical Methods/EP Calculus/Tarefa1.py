import numpy as np

### Mastigado do enunciado:
# Dados [W](nxm) e [b](1xn)
# Usando múltiplas rotações de Givens (W -> R) e (b -> b_1)
# Depois resolver Rx = ~b
# Sugestão: dados w(i,k) e w(j,k) -> calcule sen(theta) e cos(theta)

# Recebe os itens w_ik e w_jk de [W] e retorna o sen(theta) e cos(theta) da Rotação de Givens.
def getSenCos(a,b):

    #Método numericamente mais estável para obtenção de sin e cos
    tau, c, s = 0, 0, 0
    if (abs(a) > abs(b)):
        tau = -(b/a)
        c = 1/(np.sqrt(1 + tau**2))
        s = c*tau
    else:
        tau = -(a/b)
        s = 1/(np.sqrt(1 + tau**2))
        c = s*tau

    #Método númericamente mais instável
    # r = (a**2 + b**2)**(1/2)
    # c = a/r
    # s = -b/r

    return s, c

#realoza a rotação de givens numa W qualquer
def Rot_givens(W,i,j,s,c):
    #O try-except aqui foi utilizado para verificar se W é um vetor ou uma matriz
    #Dessa forma funciona tanto na resolver sistemas quanto na resolver sist. simultâneos.
    try:
        #Sendo uma matriz
        m = W.shape[1]
        W[i,:], W[j,:] = c*W[i,:] - s*W[j,:], s*W[i,:] + c*W[j,:]
    except:
        #Sendo um vetor
        aux = c*W[i] - s*W[j]
        W[j] = s*W[i] + c*W[j]
        W[i] = aux

    return W

#Realiza a rotação de givens
def getQRfactors(W,b):
    #b pode ser tanto um vetor quanto uma matriz
    b = b.transpose()
    for k in range(0,W.shape[1]):
        for j in range(W.shape[0]-1,k,-1):
            i = j-1
            if W[j][k] != 0:
                s, c = getSenCos(W[i][k],W[j][k])
                W = Rot_givens(W,i,j,s,c)
                b = Rot_givens(b,i,j,s,c)

    return W,b

#Recebendo as matrizes A (triangular superior) e b (vetor), resolve o sistema linear
def Sol_linSis(W,b):
    n = W.shape[0] #Número de linhas de A
    m = W.shape[1] #Número de colunas de A

    R, b = getQRfactors(W,b)
    #Q, R = np.linalg.qr(W)
    X = np.zeros(m)
    #b = np.dot(Q.transpose(),b)

    for k in range(m-1,-1,-1):
        somatorio = 0
        for j in range(k+1,m):
            #print(R[k])
            somatorio += R[k][j]*X[j]
        if R[k][k] != 0:
            X[k] = (b[k] - somatorio)/R[k][k]
    return X

#Resolve sistemas simultâneos
def Sol_linSis_simult(W,A,p):
    m = A.shape[1]
    R, A = getQRfactors(W.copy(),A.transpose())
    X = np.zeros((p,m))
    for k in range(p-1,-1,-1):
        for j in range(m):
            somatorio = 0
            for t in range(k+1,p):
                somatorio += R[k][t]*X[t][j]
            if R[k][k] != 0:
                X[k][j] = (A[k][j] - somatorio)/R[k][k]
    return X

#Testes do enunciado do EP
#Teste a)
# W = np.eye(64)
# W = W*2
# for i in range(64):
#     for j in range(64):
#         if abs(i-j) == 1:
#             W[i][j] = 1
#         elif abs(i-j)>1:
#             W[i][j] = 0
#         else:
#             pass
# b = np.ones(64)
# print(Sol_linSis(W.copy(),b.copy()))
# print(np.dot(W.copy(),Sol_linSis(W.copy(),b.copy())))

# Teste b)
# n = 20 #número de linhas
# m = 17 #número de colunas
# W = np.zeros((n,m))
# for i in range(n):
#     for j in range(m):
#         if abs(i-j)>4:
#             W[i][j] = 0
#         else:
#             W[i][j] = 1/(i+j-1+2) #+2 faz a correção pois i e j começam do zero.
# b = np.ones(n)


# print(Sol_linSis(W.copy(),b.copy()))
# print(np.dot(W.copy(),Sol_linSis(W.copy(),b.copy())))


#teste c)
# W = np.eye(64)
# W = W*2
# for i in range(64):
#     for j in range(64):
#         if abs(i-j) == 1:
#             W[i][j] = 1
#         elif abs(i-j)>1:
#             W[i][j] = 0
#         else:
#             pass

# b = np.ones((3,64))
# for i in range(64):
#     b[1][i] = i+1
#     b[2][i] = 2*(i+1) - 1
# b = b.transpose()

# print(Sol_linSis_simult(W.copy(),b.copy(),64))
# print(np.dot(W.copy(),Sol_linSis_simult(W.copy(),b.copy(),64)))

# Teste d)
# n = 20 #número de linhas
# m = 17 #número de colunas
# W = np.zeros((n,m))
# for i in range(n):
#     for j in range(m):
#         if abs(i-j)>4:
#             W[i][j] = 0
#         else:
#             W[i][j] = 1/(i+j-1+2) #+2 faz a correção pois i e j começam do zero.

# b = np.ones((3,n))
# for i in range(n):
#     b[1][i] = i+1
#     b[2][i] = 2*(i+1) - 1
# b = b.transpose()


# print(Sol_linSis_simult(W.copy(),b.copy(),m))
# print(np.dot(W.copy(),Sol_linSis_simult(W.copy(),b.copy(),m)))