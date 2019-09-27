#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 2: SUBRUTINAS PARA MULTIPLICACIÓN Y DIVISIÓN DE NUMEROS
############### A) Calcular la multiplicación de dos enteros mediante la implemenatcion de subrutinas

#Segmento de datos
.data	
	mensaje1: .asciiz "Por favor ingrese el primer entero: "
	mensaje2: .asciiz "Por favor ingrese el segundo entero: "
	mensaje: .asciiz "El resultado es: "
	
#Segmento de Texto
.text
#Main Process
main:	
	#Mostrar mensaje 1 al usuario: "Por favor ingrese el primer entero: "
	li $v0, 4	    	#indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje1     #cargar la dirección de memoria del mensaje 1
	syscall		#llamada al sistema: mostrar el mensaje por pantalla
	
	#Pedir Entero al usuario
	jal pedirEntero	#ir al procedimiento pedirEntero
	
	#Guardar el dato ingresado en el registro $a1
	move $a1, $v0 	    #mover el valor de $v0 a $a1
			    	    # $a1 = argumento 1 de la subrutina encontrarMenor
	
	#Mostrar mensaje 2 al usuario: "Por favor ingrese el segundo entero: "
	li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje2    #cargar la dirección de memoria del mensaje 2
	syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
	#Pedir Entero al usuario
	jal pedirEntero	#ir al procedimiento pedirEnter
	
	#Guardar el dato ingresado en el registro $a2
	move $a2, $v0 	    #mover el valor de $v0 a $a2
			    	    # $a2 = argumento 2 de la subrutina encontrarMenor
	
	#ir a calcularMultiplicacion
	jal calcularMultiplicacion
	
	#Mostrar mensaje 2 al usuario: "El resultado es: "
	li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje    #cargar la dirección de memoria del mensaje 2
	syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
	#imprimir por pantalla el resultado de la subrutina (guardado en $v1)	    
	move $a0, $v1		# preprar numero para imprimir
	li $v0, 1	       #indicarle al sistema que se quiere mostrar un entero
	syscall              #llamada al sistema: mostrar el entero por pantalla
	
	#terminar Programa
	j terminarPrograma

#Procedimiento que calcula la multiplicacion de dos numeros
#Argumentos:  $a1 = numero 1
#		$a2 = numero 2
#Resultado:   $v1
calcularMultiplicacion:
		beqz $a1, esCero	#si uno de los numeros ingresados es 0
		beqz $a2, esCero
		
		addi $sp, $sp, -28	# Modificar el stackPointer
		sw $ra, 24($sp)	# guardar el valor de los registros que van a ser utilizados
		sw $t0, 20($sp)	
		sw $t1, 16($sp)
		sw $t2, 12($sp)
		sw $t3, 8($sp)
		sw $t4, 4($sp)
		sw $t5, 0($sp)
		
		# preparar los registros que se van a utilizar
		move $t0, $a1	  # $t0 = numero 1
		move $t1, $a2	  # $t1 = numero 2
		li $t2, 0	  # $t2 = signo numero 1
		li $t3, 0	  # $t3 = signo numero 2
		li $t4, 0	  # $t4 = signo resultado
		li $t5, 0	  # $t4 = resultado
		
		#verificar signos de los nuemros
		bltz $t0, N1negativo		# if numero 1 < 0 ir a N1Negativo
		bltz $t1, resultNegativ1	# elseif numero 2 < 0 ir a resultNegativ
		b multiplicar			# else ir a multiplicar
		
		N1negativo: 	
			   	li $t2, 1			# cambiar signo 1
				move $a0, $t0			# mover numero 1 al registro $a0
			  	jal cambiarSigno		# ir a cambiarSigno
				move $t0, $v0			# mover $v0 a $t0
				   
				bltz $t1, resultPositiv	# if numero 2 < 0 ir a resultPositiv
				b resultNegativ2		# else ir a 
			
		resultPositiv:			
				li $t3, 1			# cambiar signo 2
				move $a0, $t1			# mover numero 2 al registro $a0
				jal cambiarSigno		# ir a cambiarSigno
				move $t1, $v0			# mover $v0 a $t1
				b multiplicar			# ir a multiplicar
			
		resultNegativ1:
				li $t3, 1			# cambiar signo 2
				move $a0, $t1			# mover numero 2 al registro $a0
				jal cambiarSigno		# ir a cambiarSigno
				move $t1, $v0			# mover $v0 a $t1
				li $t4, 1			# cambiar signo del resultado
				b multiplicar			# ir a multiplicar
			
		resultNegativ2:
				li $t4, 1			# cambiar signo del resultado
				b multiplicar			# ir a multiplicar
			
			#Ciclo para multiplicar
			multiplicar:
					add $t5, $t5, $t0		# sumar el numero 1 al registro donde se va guardando el resultado
		      	  		addi $t1, $t1, -1		# restar 1 al numero 2
			  		bgtz $t1, multiplicar     	# mientras numero 2 > 0 volver a la etiqueta multiplicar
		  	  		move $v1, $t5			# mover $t5 a $v1 (resultado)
		  	  		
		  	  		beq $t4, 1, verificarSigno	# si $t4 == 1 (es negativo) entonces se debe cambiar el signo
		  	  		b restaurarRegistros		#ir a restaurarRegistros
		  	 
		  	 verificarSigno:
		  	 		   move $a0, $t5		# mover $t5 a $a0 (argumento)
		  	 		   jal cambiarSigno		# ir a cambiarSigno
		  	 		   move $v1, $v0		# mover $v0 a $v1 (resultado)
		  	 		   b restaurarRegistros	# ir a restaurarRegistros
		  	 
		  	 restaurarRegistros: 
						lw $t5, 0($sp)	#Restaurar registros utilizados
						lw $t4, 4($sp)
						lw $t3, 8($sp)
						lw $t2, 12($sp)
						lw $t1, 16($sp)
						lw $t0, 20($sp)
						lw $ra, 24($sp)
		  	 			addi $sp, $sp, 28	#restaurar stackPointer
		  	 			
		  	 			jr $ra			# Salir del procedimiento
		  	 
		  	 #Si uno de los numeros ingresados es 0
		  	 esCero: 
		  	 	li $v1, 0
		  	 	jr $ra
		  	 	
#Procedimiento para cambiar de signo
#Argumentos:  $a0 = numero
#Resultado:   $v0
cambiarSigno:
		sub $v0, $zero, $a0
		jr $ra

#Pedir un entero al usuario
pedirEntero:
		li $v0, 5            #indicar al sistema que se quiere hacer un input de un entero
		syscall	       #llamada al sistema: pedir dato al usuario
		jr $ra		       #vovler hasta donde se llamo al procedimiento

#Terminar el programa
terminarPrograma:
		li $v0, 10	    	    #indicarle al sistema que se quiere finalizar el programa	    
		syscall		    #llamada al sistema: finalizar el programa
		
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $v1 ####################
