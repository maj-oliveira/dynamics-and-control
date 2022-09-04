from matplotlib import pyplot as plt
import numpy as np
from Tarefa2 import main as fatorWH
import Tarefa1

#p: Número de colunas de W, cada coluna representa um componente de aprendizagem
#salvar: Deseja salvar o treinamento obtido?
#abrir: Deseja abrir um treinamento que já foi salvo?
#visualizar: Deseja visualizar as colunas p enquanto o treinamento ocorre?
#Arquivo: String contendo o nome do arquivo para abrir/salvar

def treinamento(p,salvar,abrir,visualizar,arquivo,qtd,ndig_treino):

	Wtemp = 0
	if abrir == True:
		W = np.zeros((qtd,784,p))
		for i in range(qtd):
			Wtemp = np.loadtxt(arquivo+str(i)+'.txt') #Abre o treinamento
			W[i] = Wtemp
	else:
		W = np.zeros((qtd,784,p))
		for d in range(qtd):
			A = np.loadtxt('dados_mnist/train_dig'+str(d)+'.txt')[:,:ndig_treino]
			Wtemp , H = fatorWH(A,p)
			W[d] = Wtemp
			print(str(d+1)+'/'+str(qtd)+' Treinos realizados')

		if salvar == True:
			print('Salvando treino realizado')
			for d in range(qtd):
				np.savetxt(arquivo+str(d)+'.txt',W[d])

	if visualizar == True: #Só pode ser usado com p = 10
		print('visualizando dados')
		#fig, axs = plt.subplots(2,5,figsize=(10,10))
		for d in range(qtd):
			k=0
			print('visualizando dígito '+str(d+1)+'/'+str(qtd))
			fig, axs = plt.subplots(2,5,figsize=(28,28))
			for i in range(2):
				for j in range(5):
					try:
						Aux = W[d].transpose()[k].reshape((28,28))*255
						axs[i,j].imshow(Aux, cmap = 'gray')
						axs[i,j].set_title("Componente "+str(k+1))
					except:
						print('Deu ruim')
						pass
					k+=1
			plt.show()

	return W

def classifDigitos(W,A,p):

	qtd = W.shape[0]
	#H = np.zeros((W[0].shape[1],A.shape[1],10))
	# print(A.shape)
	C = np.zeros((qtd,A.shape[0],A.shape[1]))
	for d in range(qtd):
		H = Tarefa1.Sol_linSis_simult(W[d].copy(),A.copy(),p)
		C[d] = A.copy() - np.dot(W[d].copy(),H)
		# print(C.shape)
	qtdanalisar = C.shape[2]

	dmpM = np.zeros(qtdanalisar) #matriz dígito mais provável
	menorErroM = np.zeros(qtdanalisar) #Matriz com o menor erro do correspondente dígito mais provável
	for i in range(qtdanalisar): #varre imagens, ou seja, varre colunas, 10000 colunas
		menorErro = np.inf #número infinito
		dmp = -1 # dígito mais provavél

		for d in range(qtd): # Varre os dígitos 0 à qtd
			C_temp = C[d].transpose() #Dessa forma consigo pegar uma coluna cj como se fosse uma linha
			
			cj = C_temp[i]
			norma = np.sum(np.square(cj))**(1/2) #Calcula norma quadrática

			if norma < menorErro:
				menorErro = norma
				dmp = d

		dmpM[i] = dmp #Salva dmp na matriz
		menorErroM[i] = menorErro #Salva menor erro na matriz

	return dmpM, menorErroM

def CalcularTaxas(dmpM,labels):
	cont = 0
	contd = np.zeros(10)
	for i in range(dmpM.shape[0]):
		if dmpM[i] == labels[i]:
			cont +=1
			d = int(dmpM[i])
			contd[d] +=1
	taxa = round(cont/labels.shape[0]*100,2)

	print('Percentual Acertos total: ' + str(taxa)+'%')
	print('Acertos absolutos: '+str(cont))

	for d in range(10):
		qtdNaLabels = list(labels.flatten()).count(d)
		taxa = round(contd[d]/qtdNaLabels*100,2)
		print('Percentual acertos dígito ' + str(d) + ': ' + str(taxa)+'% '+
			'('+str(int(contd[d]))+'/'+str(qtdNaLabels)+')')

	return

def main(p,ndig_treino):
	print('Ínicio do programa')
	print('Carregando matriz com imagens teste...')
	A = np.loadtxt('dados_mnist/test_images.txt')
	print('Realizando treinamento...')
	W = treinamento(p,True,False,True,'treinamento',10,ndig_treino) #Treina e Salva
	#W = treinamento(p,False,True,False,'treinamento',10,ndig_treino) #Abre
	print('Classificando digítos...')
	dmpM, menorErroM = classifDigitos(W,A,p)
	print('Calculando taxas...')
	print('Parâmetros')
	print('p = ' + str(p))
	print('ndig_treino = '+str(ndig_treino))
	labels = np.loadtxt('dados_mnist/test_index.txt')
	CalcularTaxas(dmpM,labels)

	print('Fim do programa')
	return

main(10,100)