#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 2: SUBRUTINAS PARA MULTIPLICACIÓN Y DIVISIÓN DE NUMEROS
############### C) escriba un programa que calcule la la division de dos enteros

#Segmento de Datos
.data 
	mensaje1: 	   .asciiz "Ingrese el dividendo: "
	mensaje2: 	   .asciiz "Ingrese el divisor: "
	mensaje3: 	   .asciiz "El resultado es: "
	mensaje4: 	   .asciiz "Bienvenid@, este programa divide dos numeros\n"
	mensaje5: 	   .asciiz "No se puede dividir por 0"
	parteEntera:	   .double 1.00
	parteDecimal:    .double 0.10
	parteCentecimal: .double 0.01
	ceroDouble:      .double 0.00

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
	li $v0, 3	       #indicarle al sistema que se quiere mostrar un entero
	mov.d $f12, $f4       #mover el entero de $f4 a $f12
	syscall              #llamada al sistema: mostrar el entero por pantalla
	
	#terminar Programa
	j terminarPrograma

#Procedimiento que calcula la division de dos numeros enteros
#Argmentos:   $a1 = numero 1
#		$a2 = numero 2
#Resultado:   $f4	
calcularDivision:	
	beqz $a1, divisionCero	#si el primer numero es 0 la division es 0
	beqz $a2, divisionInvalida	#si el segundo numero es 0 la division es invalida
	
	#GUARDAR EN EL STACK LOS REGISTROS QUE SE VAN A UTILIZAR	
	addi $sp, $sp, -44	# Modificar el stackPointer
	sw $ra, 40($sp)	# guardar el valor de los registros que van a ser utilizados
	sw $t0, 36($sp)	
	sw $t1, 32($sp)
	sw $t2, 28($sp)
	sw $t3, 24($sp)
	sw $t4, 20($sp)
	sw $t5, 16($sp)
	sdc1 $f2, 8($sp)
	sdc1 $f6, 0($sp)
	
	# preparar los registros que se van a utilizar
	move $t0, $a1	  # $t0 = numero 1
	move $t1, $a2	  # $t1 = numero 2
	li $t2, 0	  # $t2 = signo numero 1
	li $t3, 0	  # $t3 = signo numero 2
	li $t4, 0	  # $t4 = signo resultado
	li $t5, 0	  # $t5 = auxiliar
	
	#verificar signos de los nuemros
	bltz $t0, N1negativoDiv		# if numero 1 < 0 ir a N1Negativo
	bltz $t1, resultadoNegativo1Div		# elseif numero 2 < 0 ir a resultNegativ
	b dividirParteEntera			# ir a dividirEnteros
		
	N1negativoDiv: 	
		li $t2, 1			# cambiar signo 1
		move $a0, $t0			# mover numero 1 al registro $a0
		jal cambiarSigno		# ir a cambiarSigno
		move $t0, $v0			# mover $v0 a $t0   
		bltz $t1, resultadoPositivoDiv	# if numero 2 < 0 ir a resultPositiv
		b resultadoNegativo2Div		# else ir a 
			
		resultadoPositivoDiv:			
				li $t3, 1			# cambiar signo 2
				move $a0, $t1			# mover numero 2 al registro $a0
				jal cambiarSigno		# ir a cambiarSigno
				move $t1, $v0			# mover $v0 a $t1
				b dividirParteEntera		# ir a dividirEnteros
			
		resultadoNegativo1Div:
				li $t3, 1			# cambiar signo 2
				move $a0, $t1			# mover numero 2 al registro $a0
				jal cambiarSigno		# ir a cambiarSigno
				move $t1, $v0			# mover $v0 a $t1
				li $t4, 1			# cambiar signo del resultado
				b dividirParteEntera		# ir a dividirEnteros
			
		resultadoNegativo2Div:
				li $t4, 1			# cambiar signo del resultado
				b dividirParteEntera		# ir a dividirEnteros
		
	dividirParteEntera:
		# $f4 = resultado
		l.d $f4, ceroDouble			# cargar en $f4 un 0.0
		l.d $f6, ceroDouble
		blt $t0, $t1, dividirParteDecimal	# si no hay parte entera para dividir, dividir parteDecimal
		l.d $f2, parteEntera			# cargar en $f2 un 1.0
				
		# Ir al ciclo para dividir
		jal cicloDividir		# dividir parte decimal
		
		add.d $f4, $f4, $f6
						
		# si dividendo = 0 ir a terminar
		beqz $t0, terminarDivision
		
	dividirParteDecimal:
		#Multiplicar dividendo x 10
		jal multX10
		l.d $f6, ceroDouble		
		blt $t0, $t1, dividirParteCentecimal	#si no se puede ir a dividir la parteCentecimal				
		l.d $f2, parteDecimal			#cargar en $f2 un 0.1
				
		# Ir al ciclo para dividir
		jal cicloDividir		# dividir parte decimal	
		
		add.d $f4, $f4, $f6
						
		# si dividendo = 0 ir a terminar
		beqz $t0, terminarDivision
		
	dividirParteCentecimal:
		#Multiplicar x 10
		li $t5, 0
		jal multX10
		l.d $f6, ceroDouble		
		blt $t0, $t1, terminarDivision	#si no se puede dividir, terminar el procedimiento
		l.d $f2, parteCentecimal	#cargar en $f2 un 0.01
				
		# Ir al ciclo para dividir
		jal cicloDividir		# dividir parte decimal
		
		add.d $f4, $f4, $f6
						
		b terminarDivision		
				
	
	#Ciclo para dividir
	cicloDividir:
		sub $t0, $t0, $t1			# Dividendo = Dividendo - Divisor
		add.d $f6, $f6, $f2			# sumar 1 al resultado
		bge $t0, $t1, cicloDividir	# mientras dividendo >= divisor seguir dividiendo
		jr $ra
	
	#Terminar el procedimiento	  	  		
	terminarDivision:
		jal verificarSignoResultado	 # verificar el signo del resultado
		  	 
		#Restaurar los registros utilizados
		ldc1 $f6 0($sp)
		ldc1 $f2 8($sp)
		lw $t5, 16($sp)
		lw $t4, 20($sp)
		lw $t3, 24($sp)
		lw $t2, 28($sp)
		lw $t1, 32($sp)
		lw $t0, 36($sp)
		lw $ra, 40($sp)
		addi $sp, $sp, 44	# restaurar stackPointer
		  	 			
		jr $ra			# Salir del procedimiento
		
	#si dividendo = 0	  	 
	divisionCero:
		l.d $f4, ceroDouble
		jr $ra
		  			
	#si el divisor es 0 (division por cero)
	divisionInvalida:
		#Mostrar mensaje 2 al usuario
		li $v0, 4	        #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje5    #cargar la dirección de memoria del mensaje 2
		syscall     	 #llamada al sistema: mostrar el mensaje por pantalla
			  
		j terminarPrograma
			 
	multX10:
		addi $t5, $t5, 10	#sumar 10 al registro donde se va guardando el resultado
		addi $t0, $t0, -1	#Sumar 1 al contador 
		bgtz $t0, multX10	# mientras $t0 > 0 volver a multX10
		move $t0, $t5		#mover $t5 a $t0
		jr $ra
			 
	#Procedimiento para cambiar de signo a un double
	verificarSignoResultado:
		beq $t4, 1, cambiar			# si $t4 == 1 (resultado debe ser negativo) cambiar signo
		jr $ra					# sino salir del procedimiento
		cambiar:				# cambair signo
			l.d $f2, ceroDouble
			sub.d $f4, $f2, $f4	# $f2 = 0 - $f2
		jr $ra					# salir del procedimiento
	
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
		
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $f4 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $f4 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $f4 ####################
	###### EL RESULTADO DE LA MULTIPLICACION ESTA EN EL REGISTRO $f4 ####################	
	
