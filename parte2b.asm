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
	
	#Mostrar mensaje 2 al usuario
	li $v0, 4	     #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje2    #cargar la dirección de memoria del mensaje 2
	syscall     	     #llamada al sistema: mostrar el mensaje por pantalla
		
	#imprimir por pantalla el resultado de la subrutina (guardado en $v1)	    
	li $v0, 1	    #indicarle al sistema que se quiere mostrar un entero
	move $a0, $v1       #mover el entero de $v1 a $a0
	syscall             #llamada al sistema: mostrar el entero por pantalla
	
	#terminar el programa
	j terminarPrograma

#Procedimiento que calcula el factorial de un numero
#Argumentos:  $a1 = numero 
#Resultado:   $v1	
calcularFactorial:
			beqz $a0, factorialDeCero		# si el dato ingresado es 0 ir a esCero
			bltz $a0, factorialInvalido  	# si el dato ingresado es menor a 0 ir a esMenorACero
			
			addi $sp, $sp, -8		# modificar stackPointer
			sw $t0, 4($sp)		# guardar valor del registro $t0
			sw $t1, 0($sp)		#guardar valor del registro $t1
	
			move $t0, $a0	  # $t0 = numero ingresado
			li $t1, 1	  # $t1 = donde se ira guardando el resultado
	
			#ir al ciclo para calcular el factorial
			b cicloFactorial

		#ciclo para calcular el factorial
		cicloFactorial: 
				move $a1, $t0			# preparar argumentos para multiplicar $a1 y $a2
				move $a2, $t1
				addi $sp, $sp, -4		# modificar stackPointer
				sw $ra, 0($sp)		# guardar el valor del registro $ra
				jal calcularMultiplicacion	# calcular Multiplicacion
				lw $ra, 0($sp)		# restaurar registro $ra
				addi $sp, $sp, 4		# restaurar stackPointer
				move $t1, $v1			# mover resultado de la multiplicacion a $t1
				addi $t0, $t0, -1		# restar 1 al registro $t0
				bgtz $t0, cicloFactorial	# si $t0 > 0 seguir en el ciclo
				move $v1, $t1			# sino mover $t1 a $v1 (resultado)
				
				#Restaurar Registros
				lw $t1, 0($sp)		# restaurar valor del registro $t0
				lw $t0, 4($sp)		# restaurar valor del registro $t1
				addi $sp, $sp, 8		# restaurar stackPointer
				jr $ra				# salir del procedimiento
														
		#rutina utilizada en caso de que el usuario ingrese un 0
		factorialDeCero:
		   	li $v1, 1	# resultado = 1
		   	jr $ra		# salir del procedimiento
	
		#rutina utilizada en caso de que el usuario ingrese un numero menor a 0
		factorialInvalido: 
			  #Mostrar mensaje 2 al usuario
			  li $v0, 4	        #indicar al sistema que se quiere mostrar un string por pantalla
			  la $a0, mensaje3    #cargar la dirección de memoria del mensaje 2
			  syscall     	 #llamada al sistema: mostrar el mensaje por pantalla
			  
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
					add $t5, $t5, $t1		# sumar el numero 1 al registro donde se va guardando el resultado
		      	  		addi $t0, $t0, -1		# restar 1 al numero 2
			  		bgtz $t0, multiplicar     	# mientras numero 2 > 0 volver a la etiqueta multiplicar
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
		  	 	li $v1, 0	# resultado = 0
		  	 	jr $ra		# salir del procedimiento

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