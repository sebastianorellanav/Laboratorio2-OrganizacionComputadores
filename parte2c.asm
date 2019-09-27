#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 2: SUBRUTINAS PARA MULTIPLICACIÓN Y DIVISIÓN DE NUMEROS
############### C) escriba un programa que calcule la la division de dos enteros

#Segmento de Datos
.data 
	mensaje1: .asciiz "Ingrese el dividendo: "
	mensaje2: .asciiz "Ingrese el divisor: "
	mensaje3: .asciiz "El resultado es: "
	mensaje4: .asciiz "Bienvenid@, este programa divide dos numeros\n"
	mensaje5: .asciiz "No se puede dividir por 0"
	uno:      .float 1.0
	decimal:  .float 0.01
	cero:     .float 0.0

#Segmento de Texto
.text
#Main Process
main:	
	#Mostrar bienvenida al usuario
	li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje4    #cargar la dirección de memoria del mensaje 1
	syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
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
	jal calcularDivision
	
	#Mostrar mensaje 2 al usuario: "El resultado es: "
	li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje3    #cargar la dirección de memoria del mensaje 2
	syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
	#imprimir por pantalla el resultado de la division	    
	lwc1 $f1, 0($v1)
	li $v0, 2	       #indicarle al sistema que se quiere mostrar un entero
	mfc1 $a0, $f1        #mover el entero de $v1 a $a0
	syscall              #llamada al sistema: mostrar el entero por pantalla
	
	#terminar Programa
	j terminarPrograma
	
calcularDivision:	
		beqz $a1, divisionCero	#si el primer numero es 0 la division es 0
		beqz $a2, divisionInvalida	#si el segundo numero es 0 la division es invalida
		
		addi $sp, $sp, -32	# Modificar el stackPointer
		sw $ra, 28($sp)	# guardar el valor de los registros que van a ser utilizados
		sw $t0, 24($sp)	
		sw $t1, 20($sp)
		sw $t2, 16($sp)
		sw $t3, 12($sp)
		sw $t4, 8($sp)
		sw $t5, 4($sp)
		sw $t6, 0($sp)
		
		# preparar los registros que se van a utilizar
		move $t0, $a1	  # $t0 = numero 1
		move $t1, $a2	  # $t1 = numero 2
		li $t2, 0	  # $t2 = signo numero 1
		li $t3, 0	  # $t3 = signo numero 2
		li $t4, 0	  # $t4 = signo resultado
		li $t5, 0	  # $t5 = resultado Entero
		li $t6, 0	  # $t6 = resultado Decimal
		l.s $f0, uno	
		l.s $f1, decimal
		l.s $f2, cero
		
		#verificar signos de los nuemros
		bltz $t0, N1negativoDiv		# if numero 1 < 0 ir a N1Negativo
		bltz $t1, resultNegativ1Div		# elseif numero 2 < 0 ir a resultNegativ
		blt $t0, $t1, dividirDecimales
		b dividirEnteros			# else ir a dividirEnteros
		
		N1negativoDiv: 	
			   	li $t2, 1			# cambiar signo 1
				move $a0, $t0			# mover numero 1 al registro $a0
			  	jal cambiarSigno		# ir a cambiarSigno
				move $t0, $v0			# mover $v0 a $t0
				   
				bltz $t1, resultPositivDiv	# if numero 2 < 0 ir a resultPositiv
				b resultNegativ2Div		# else ir a 
			
		resultPositivDiv:			
				li $t3, 1			# cambiar signo 2
				move $a0, $t1			# mover numero 2 al registro $a0
				jal cambiarSigno		# ir a cambiarSigno
				move $t1, $v0			# mover $v0 a $t1
				blt $t0, $t1, dividirDecimales
				b dividirEnteros		# ir a dividirEnteros
			
		resultNegativ1Div:
				li $t3, 1			# cambiar signo 2
				move $a0, $t1			# mover numero 2 al registro $a0
				jal cambiarSigno		# ir a cambiarSigno
				move $t1, $v0			# mover $v0 a $t1
				li $t4, 1			# cambiar signo del resultado
				blt $t0, $t1, dividirDecimales
				b dividirEnteros		# ir a dividirEnteros
			
		resultNegativ2Div:
				li $t4, 1			# cambiar signo del resultado
				blt $t0, $t1, dividirDecimales
				b dividirEnteros		# ir a dividirEnteros
			
			#Ciclo para dividir
			dividirEnteros:
					sub $t0, $t0, $t1			# Dividendo = Dividendo - Divisor
		      	  		add.s $f2, $f2, $f0			# sumar 1 al resultado
			  		bge $t0, $t1, dividirEnteros	# mientras numero 2 > 0 seguir dividiendo
		  	  		
		  	  		addi $sp, $sp, -4		# modificar stackPointer
					sw $ra, 0($sp)		# guardar el valor del registro $ra
					jal dividirDecimales 	# dividir parte decimal
					lw $ra, 0($sp)		# restaurar registro $ra
					addi $sp, $sp, 4		# restaurar stackPointer
		  	  		
		  	  		beq $t4, 1, verificarSignoDiv	# si $t4 == 1 (es negativo) entonces se debe cambiar el signo
		  	  		b restaurarRegistrosDiv		# ir a restaurarRegistros
		  	 
		  	 verificarSignoDiv:
		  	 		   mfc1 $a0, $f2		# mover $t5 a $a0 (argumento)
		  	 		   addi $sp, $sp, -4		# modificar stackPointer
					   sw $ra, 0($sp)		# guardar $ra en el stack
		  	 		   jal cambiarSignoFloat	# ir a cambiarSigno
		  	 		   lw $ra, 0($sp)		# restaurar registro $ra
					   addi $sp, $sp, 4		# restaurar stackPointer
		  	 		   move $v1, $v0		# mover $v0 a $v1 (resultado)	 		   
		  	 		   b restaurarRegistrosDiv	# ir a restaurarRegistros
		  	 
		  	 restaurarRegistrosDiv: 
						lw $t6, 0($sp)	# Restaurar registros utilizados
						lw $t5, 4($sp)
						lw $t4, 8($sp)
						lw $t3, 12($sp)
						lw $t2, 16($sp)
						lw $t1, 20($sp)
						lw $t0, 24($sp)
						lw $ra, 28($sp)
		  	 			addi $sp, $sp, 32	# restaurar stackPointer
		  	 			
		  	 			jr $ra			# Salir del procedimiento
		  	 
		  	 dividirDecimales:
		  			bnez $t0, multX100
		  			jr $ra
		  			multX100:
			 			addi $t6, $t6, 100	#sumar 100 al registro donde se va guardando el resultado
		      	 			addi $t0, $t0, -1	#Sumar 1 al contador 
						bgtz $t0, multX100	# mientras $t0 > 0 volver a multX100
		  				move $t0, $t6
		  				li $t6, 0
					
					divDecimales:
							sub $t0, $t0, $t1		# Dividendo = Dividendo - Divisor
		      	  				add.s $f2, $f2, $f1		# sumar 1 al resultado (parte decimal)
			  				bge $t0, $t1, divDecimales	# mientras numero 1 > numero 2 seguir dividiendo
		  	  				mfc1 $v0, $f2 		# mover $t5 a $v1 (resultado)		  			
							jr $ra	
		  	   
		  	divisionCero:
		  			l.s $f0, cero
		  			mfc1 $v0, $f0
		  			jr $ra
		  			
		  	divisionInvalida:
					#Mostrar mensaje 2 al usuario
			  		li $v0, 4	        #indicar al sistema que se quiere mostrar un string por pantalla
			  		la $a0, mensaje5    #cargar la dirección de memoria del mensaje 2
			  		syscall     	 #llamada al sistema: mostrar el mensaje por pantalla
			  
			  		j terminarPrograma
	
#Procedimiento para cambiar de signo
#Argumentos:  $a0 = numero
#Resultado:   $v0
cambiarSigno:
		sub $v0, $zero, $a0
		jr $ra

#Procedimiento para cambiar de signo a uun numero flotante
#Argumentos:  $a0 = numero
#Resultado:   $v0
cambiarSignoFloat:
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
	
