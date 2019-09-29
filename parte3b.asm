######################################################################################################################################
#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 3: CALCULAR APROXIMACION DE FUNCIONES
############### A) Calcular la aproximacion del COSENO

#Segmento de Datos
.data
	mensaje1:	   .asciiz "Ingrese x para calcular el cos(x): "
	mensaje2: 	   .asciiz "cos(x) = "
	mensaje3: 	   .asciiz "No existe factorial para el numero ingresado"
	mensaje4:        .asciiz "Ingrese el orden de la serie de taylor: "
	mensaje5: 	   .asciiz "No se puede dividir por 0"
	parteEntera:	   .double 1.00
	parteDecimal:    .double 0.10
	parteCentecimal: .double 0.01
	ceroDouble:      .double 0.00
	saltoLinea:      .asciiz "\n"

#Segmento de Texto
.text
#Procedimiento Principal
main: 
	#Mostrar mensaje 1 al usuario
	li $v0, 4	     #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje1    #cargar la dirección de memoria del mensaje 1
	syscall     	     #llamada al sistema: mostrar el mensaje por pantalla
	
	#Pedir Entero al usuario
	jal pedirEntero	#ir al procedimiento pedirEntero
	
	#Preparar arguemento para el procedimiento CalcularCoseno
	move $a1, $v0
	
	#Orden de la serie de taylor
	li $a2, 4
	
	#Culacular el seno
	jal calcularCoseno
	
	#Mostrar mensaje 2 al usuario: "El resultado es: "
	li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
	la $a0, mensaje2    #cargar la dirección de memoria del mensaje 2
	syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
	#imprimir por pantalla el resultado de la division	    
	li $v0, 3	       #indicarle al sistema que se quiere mostrar un entero
	mov.d $f12, $f4       #mover el entero de $f4 a $f12
	syscall              #llamada al sistema: mostrar el entero por pantalla
	
	#terminar Programa
	j terminarPrograma


#Procedimiento para calcular en Sen($a1)
#Argumentos:  $a1 = numero
#Argumentos:  $a2 = orden
#Resultado:   
calcularCoseno:
	addi $sp, $sp, -36	
	sw $ra, 32($sp)
	sw $t0, 28($sp)
	sw $t1, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	s.d $f0, 0($sp)
	
	move $t0, $a1		#guardar numero
	move $t1, $a2		#guardar orden 
	l.d $f0, ceroDouble
	cicloCoseno:
		#calcular (-1)^n
		li $a1, -1
		move $a2, $t1
		jal calcularPotencia
		move $s0, $v1
		
		#calcular 2n
		li $a1, 2
		move $a2, $t1
		jal calcularMultiplicacion
		move $s1, $v1
		
		#calcular x^(2n)
		move $a1, $t0
		move $a2, $s1
		jal calcularPotencia
		move $s2, $v1
		
		#if (-1)^n = -1
		move $a0, $s2
		beq $s0, -1, multXMenos1
		b continuar
		multXMenos1:
			jal cambiarSigno
			move $s2, $v0
		continuar:
		#calcular (2n)!
		move $a0, $s1
		jal calcularFactorial
		move $s3, $v1
		
		#calcular (-1)*x^(2n-1)/(2n-1)!
		move $a1, $s2
		move $a2, $s3
		jal calcularDivision
		add.d $f0, $f0, $f4
		
		#restar 2 a n
		subi $t1, $t1, 1
		
		#mientras n >= 1 volver a repetir
		bgez $t1, cicloCoseno
		mov.d $f4, $f0
	#Resturar Registros
	l.d $f0, 0($sp)
	lw $s3, 8($sp)
	lw $s2, 12($sp)
	lw $s1, 16($sp)
	lw $s0, 20($sp)
	lw $t1, 24($sp)
	lw $t0, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	
	jr $ra
			
#Procedimiento que calcula la potencia n de un numero
#Argumentos:  $a1 = numero
#		$a2 = exponente
#Resultado:   $v1
calcularPotencia:
	beqz $a2, exponenteCero	#si el expoonente es 0
	beq $a1, 1, potenciaDeUno   #si el numero es 1
	beq $a2, 1, exponenteUno	#si el exponente es 1
			
	addi $sp, $sp, -8	#modificar el sttackPointer
	sw $ra, 4($sp)	#guardar valores de los registros que se van a utilizar
	sw $t0, 0($sp)
	
	subi $a2, $a2, 1
	move $t0, $a2		#mover el exponente a $t1
	move $a2, $a1		#mover $a1 a $a2
	
	cicloPotencia:			#ciclo para calcular la potencia
		jal calcularMultiplicacion	#calcular multiplicacion
		move $a1, $v1			#mover resultado al argumento
		subi $t0, $t0, 1		#restar 1 al exponente
		bgtz $t0, cicloPotencia	#si el exponente > 0 volver al ciclo
	
	lw $t0, 0($sp)	#restaurar registros utilizados
	lw $ra, 4($sp)
	addi $sp, $sp, 8	#restaurar StackPointer
	
	jr $ra		#Salir del procedimiento
	
	exponenteCero:
		li $v1, 1
		jr $ra
	
	potenciaDeUno:
		li $v1, 1
		jr $ra
	
	exponenteUno:
		move $v1,$a1
		jr $ra

#Procedimiento que calcula el factorial de un numero
#Argumentos:  $a0 = numero 
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
				bgt $t0, 1, cicloFactorial	# si $t0 > 0 seguir en el ciclo
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

#Procedimiento que calcula la division de dos numeros enteros
#Argmentos:   $a1 = numero 1
#		$a2 = numero 2
#Resultado:   $f4	
calcularDivision:	
	beqz $a1, divisionCero	#si el primer numero es 0 la division es 0
	beqz $a2, divisionInvalida	#si el segundo numero es 0 la division es invalida
	
	#GUARDAR EN EL STACK LOS REGISTROS QUE SE VAN A UTILIZAR	
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
		lw $t5, 0($sp)
		lw $t4, 4($sp)
		lw $t3, 8($sp)
		lw $t2, 12($sp)
		lw $t1, 16($sp)
		lw $t0, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28	# restaurar stackPointer
		  	 			
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
