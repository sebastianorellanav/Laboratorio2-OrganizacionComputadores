#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 2: SUBRUTINAS PARA MULTIPLICACIÓN Y DIVISIÓN DE NUMEROS
############### A) Calcular la multiplicación de dos enteros mediante la implemenatcion de subrutinas

#Segmento de datos
.data	################   ENTEROS QUE SE VAN A MULTIPLICAR   ##############################
	entero1: .word 3	#Entero 1
	entero2: .word -5	#Entero 2
	mensaje: .asciiz "El resultado es: "
	
#Segmento de Texto
.text
	#Main Process
	main:	
		#Cargar numeros que se desean multiplicar
		lw $a0, entero1	#cargar el entero en $a0 para pasarlo como argumento a las sub-rutinas
		lw $a1, entero2	#cargar el entero en $a1 para pasarlo como argumento a las sub-rutinas
		
		# $a2 = contador = 0
		li $a2, 0
		
		#si $t0 > 0
		bgtz $a0, multiplicacion1	#ir a la sub-rutina multiplicacion1
		b else				#ir a la sub-rutina else
		
	else:	#si $a1 > 0
		bgtz $a1, multiplicacion2	#ir a la subrutina multiplicacion2
		#sino 
		jal convertirAPositivo	#convertir los numeros a positivos
		move $a3, $v1			#guardar el numero convertido en $a3
		move $a0, $a1			#preparar el registro $a0 para convertir el otro numero
		li $v1, 0			#restaurar el valor del registro $v1
		jal convertirAPositivo	#convertir el otro numero
		move $a0, $v1			#guardar el segundo numero convertido
		move $a1, $a3			#rescuperar el numero anteriormente convertido
		li $a3, 0			#restaurar el valor del registro $a3
		li $v1, 0			#restaurar el valor del registro $v1
		b multiplicacion1		#multiplicar los numeros convertidos
	
	#se utiliza la siguiente multiplicacion cuando ambos numeros son positivos o cuando
	#el primer numero ingresado es positivo y el otro negativo
	# Argumentos: $a0 = numero1
	#		$a1 = numero2
	#		$a2 = contador = 0
	# Resultado:  $v1 
	multiplicacion1:	
			  add $v1, $v1, $a1			#sumar el numero2 al registro donde se va guardando el resultado
		      	  addi $a2, $a2, 1			#Sumar 1 al contador 
			  bne $a2, $a0, multiplicacion1	# mientras contador < numero1 volver a la etiqueta multiplicacion
			  li $a2, 0				#restaurar valor de $a2
		  	  b exit				#ir a la etiqueta exit
	
	#se utiliza la siguiente multiplicacion cuando el primer numero ingresado es 
	#negativo y el otro es positivo
	# Argumentos: $a0 = numero1
	#		$a1 = numero2
	#		$a2 = contador = 0
	# Resultado:  $v1 	
	multiplicacion2:
			  add $v1, $v1, $a0			#sumar el numero1 al registro donde se va guardando el resultado
		      	  addi $a2, $a2, 1			#Sumar 1 al contador 
			  bne $a2, $a1, multiplicacion2	# mientras contador < numero1 volver a la etiqueta multiplicacion
			  li $a2, 0				#restaurar valor de $a2
		  	  b exit				#ir a la etiqueta exit 
	
	#se utiliza la siguiente sub-rutina para convertir un numero negativo en positivo sin multiplicar 
	#por menos 1, sino utilizando solo sumas
	convertirAPositivo:	
			  sub $v1, $zero, $a0		#se convierte el registro $a0 a positivo
			  jr $ra  		  		#volver a la multiplicacion
			  
	#rutina para imprimir resultado y terminar el programa
	exit:	
		#Mostrar mensaje al usuario
		li $v0, 4	     #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje    #cargar la dirección de memoria del mensaje 
		syscall     	     #llamada al sistema: mostrar el mensaje por pantalla
		
		#imprimir por pantalla el resultado de la subrutina (guardado en $v1)	    
		li $v0, 1	    #indicarle al sistema que se quiere mostrar un entero
		move $a0, $v1       #mover el entero de $v1 a $a0
		syscall             #llamada al sistema: mostrar el entero por pantalla
		
		#Terminar el programa
		li $t0, 0	    #restaurar el valor del registro $t0
		li $t1, 0	    #restaurar el valor del registro $t1
		li $v0, 10	    #indicarle al sistema que se quiere finalizar el programa	    
		syscall		    #llamada al sistema: finalizar el programa
	
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
