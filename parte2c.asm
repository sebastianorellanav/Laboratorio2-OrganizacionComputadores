#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 2: SUBRUTINAS PARA MULTIPLICACIÓN Y DIVISIÓN DE NUMEROS
############### C) escriba un programa que calcule la la division de dos enteros

#Segmento de Datos
.data 
	mensaje1: .asciiz "Ingrese el dividendo: "
	mensaje2: .asciiz "Ingrese el divisor: "
	mensaje3: .asciiz "El resultado es: "
	mensaje4: .asciiz "Bienvenid@, este programa divide dos numeros\n"

#Segmento de Texto
.text
	main:
		#Mostrar bienvenida al usuario
		li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje4    #cargar la dirección de memoria del mensaje 1
		syscall		    #llamada al sistema: mostrar el mensaje por pantalla
		
		#Mostrar mensaje 1 al usuario
		li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje1    #cargar la dirección de memoria del mensaje 1
		syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
		#Pedir un numero al usuario
		li $v0, 5           #indicar al sistema que se quiere hacer un input de un entero
		syscall		    #llamada al sistema: pedir dato al usuario
	
		#Guardar el dato ingresado en el registro $a1
		move $a1, $v0 	    #mover el valor de $v0 a $a1
			    	    # $a1 = argumento 1 de la subrutina encontrarMenor
	
		#Mostrar mensaje 2 al usuario
		li $v0, 4	    #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje2    #cargar la dirección de memoria del mensaje 2
		syscall		    #llamada al sistema: mostrar el mensaje por pantalla
	
		#Pedir un numero al usuario
		li $v0, 5           #indicar al sistema que se quiere hacer un input de un entero
		syscall		    #llamada al sistema: pedir dato al usuario
		
		#Guardar el dato ingresado en el registro $a2
		move $a2, $v0 	    #mover el valor de $v0 a $a2
					    # $a1 = argumento 1 de la subrutina encontrarMenor
		
		#Preparar contador (argumento) para el procedimiento division
		li $a3, 0
		
		#Ir al procedimiento division
		jal divisionEntera
		
		#Guardar elm resultado de la division en un registro temporal
		move $t0, $v1
		
		#si el dividendo no es 0 (se debe seguir dividiendo) 
		bne $a1, $zero, multX100		#saltar a la etiqueta multX100
		
	#Procedimiento para dividir enteros
	#Argumentos:  $a1 = Dividendo
	#		$a2 = Divisor
	#		$a3 = contador(resultado) = 0
	#Resultado:  	$v1	
	divisionEntera:
				sub $a1, $a1, $a2		# Dividendo = Dividendo - Divisor
				addi $a3, $a3, 1		# Sumar 1 al contador
				bge $a1, $a2, divisionEtera	# Continuar restando mientras el dividendo sea mayor que el divisor 
				move $v1, $a3			# mover el resultado al registro de retornos de resultados
				j $ra				#volver al main
				
	#Procedimiento utilizado para multiplicar el dividendo por 10 en caso de tener que realizar una division decimal
	#Argumentos:  $a0 = contador = 0
	#		$a1 = dividendo
	#Resultado: 	$v1
	multX100: 
		  addi $sp, $sp, -4
		  sw $a0, 0($sp)
		  li $a0, 0
		  whileMult:
			 	add $v1, $v1, $a1			#sumar el numero2 al registro donde se va guardando el resultado
		      	 	addi $a0, $a0, 1			#Sumar 1 al contador 
			 	bne $a0, 10, multX100		# mientras contador < numero1 volver a la etiqueta multiplicacion
		  
		  #Restaurar Valor de $a0
		  lw
		  li $a0, 0				#restaurar valor de $a2
		  b divisionDecimal			#ir a la etiqueta divisionDecimal
	
	divisionDecimal: 	
				sub $a1, $a1, $a2
				
	exit: