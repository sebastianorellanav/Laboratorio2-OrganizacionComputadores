#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 2: SUBRUTINAS PARA MULTIPLICACIÓN Y DIVISIÓN DE NUMEROS
############### B) escriba un programa que calcule la factorial de un número entero (utilizando parte A)

#Segemnto de Datos
.data
	mensaje1: .asciiz "Ingrese un numero para calcular su factorial: "
	mensaje2: .asciiz "El resultado es: "
	mensaje3: .asciiz "No existe factorial para el numero ingresado"

#Segemento de Texto
.text
#Rutina Principal
main:
	#Mostrar mensaje 1 al usuario
	li $v0, 4	     #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje1    #cargar la dirección de memoria del mensaje 1
	syscall     	     #llamada al sistema: mostrar el mensaje por pantalla
	
	#Pedir Entero al usuario
	jal pedirEntero	#ir al procedimiento pedirEntero
	
	#Guardar el dato ingresado en el registro $a1
	move $a0, $v0 	    #mover el valor de $v0 a $a1
			    	    # $a1 = argumento de la subrutina Factorial
	
	#Ir a la subrutina calcularFactorial
	jal calcularFactorial
	
calcularFactorial:
			addi $sp, $sp, -4
			sw $t0, ($sp)
			sw $t1, ($sp)
			sw $t2, ($sp)
	
			move $t0, $a0	  # $t0 = numero ingresado
			li $t1, 1	  # $t1 = donde se ira guardando el resultado
			
			#si el dato ingresado es 0
			beqz $t0, esCero
	
			#si el dato ingresado es menor a 0
			bltz $t0, esMenorACero
	
			#else
			b factorial

		#
		factorial: 
				jal multiplicacion
				move $a1, $v1
				addi $a0, $a0, -1
				bgtz $a0, factorial
				move $v1, $a1
				b exit
		

multiplicacion:	
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		# $a2 = contador = 0
		li $a2, 0
		# $v1 = resultado
		li $v1, 0
		
		#si $a0 > 0
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
	#		$a2 = contador 
	# Resultado:  $v1 
	multiplicacion1:	
			  add $v1, $v1, $a1			#sumar el numero2 al registro donde se va guardando el resultado
		      	  addi $a2, $a2, 1			#Sumar 1 al contador 
			  bne $a2, $a0, multiplicacion1	# mientras contador < numero1 volver a la etiqueta multiplicacion
			  li $a2, 0				#restaurar valor de $a2
		  	  lw $ra, 0($sp)			#REcuperar la direccion de memeria de la etiqueta factorial que estaba guardada en el stack
			  addi $sp, $sp, 4			#restaurar el stack pointer
			  jr $ra		  	  	#volver a la etiqueta factorial

	
	#se utiliza la siguiente multiplicacion cuando el primer numero ingresado es 
	#negativo y el otro es positivo
	# Argumentos: $a0 = numero1
	#		$a1 = numero2
	#		$a2 = contador 
	# Resultado:  $v1 	
	multiplicacion2:
			  add $v1, $v1, $a0			#sumar el numero1 al registro donde se va guardando el resultado
		      	  addi $a2, $a2, 1			#Sumar 1 al contador 
			  bne $a2, $a1, multiplicacion2	# mientras contador < numero1 volver a la etiqueta multiplicacion
			  li $a2, 0				#restaurar valor de $a2
		  	  lw $ra, 0($sp)			#REcuperar la direccion de memeria de la etiqueta factorial que estaba guardada en el stack
			  addi $sp, $sp, 4			#restaurar el stack pointer
			  jr $ra		  	  	#volver a la etiqueta factorial
	
	#se utiliza la siguiente sub-rutina para convertir un numero negativo en positivo sin multiplicar 
	#por menos 1, sino utilizando solo sumas
	convertirAPositivo:	
			  sub $v1, $zero, $a0		#se convierte el registro $a0 a positivo
			  jr $ra  		  		#volver a la multiplicacion
	
	#rutina utilizada en caso de que el usuario ingrese un 0
	esCero:
		   li $v1, 1
		   b exit
	
	#rutina utilizada en caso de que el usuario ingrese un numero menor a 0
	esMenorACero: 
			  #Mostrar mensaje 2 al usuario
			  li $v0, 4	     #indicar al sistema que se quiere mostrar un string por pantalla
			  la $a0, mensaje3    #cargar la dirección de memoria del mensaje 2
			  syscall     	     #llamada al sistema: mostrar el mensaje por pantalla
			  
			  #Terminar el programa
			  li $t0, 0	    #restaurar el valor del registro $t0
			  li $t1, 0	    #restaurar el valor del registro $t1
			  li $v0, 10	    #indicarle al sistema que se quiere finalizar el programa	    
			  syscall		    #llamada al sistema: finalizar el programa
	
	#rutina para imprimir resultado y terminar el programa
	exit:	
		#Mostrar mensaje 2 al usuario
		li $v0, 4	     #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje2    #cargar la dirección de memoria del mensaje 2
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

#Pedir un entero al usuario
pedirEntero:
		li $v0, 5            #indicar al sistema que se quiere hacer un input de un entero
		syscall	       #llamada al sistema: pedir dato al usuario
		jr $ra		       #vovler hasta donde se llamo al procedimiento

	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################