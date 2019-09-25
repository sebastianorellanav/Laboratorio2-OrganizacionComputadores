######################################################################################################################################
#######################################   LABORATORIO 2 ORGANIZACIÓN DE COMPUTADORES   ###############################################

############### PARTE 1: USO DE SYSCALL  

#Segmento de datos
.data	
	mensaje1: .asciiz "Por favor ingrese el primer entero: "
	mensaje2: .asciiz "Por favor ingrese el segundo entero: "
	mensaje3: .asciiz "El minimo es: "

#Segmento de texto
.text
#Rutina Principal
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
	
	#ir a la subrutina que determina el mayor de los dos enteros ingresados
	jal buscarMenor
	
	#imprimir por pantalla el resultado de la subrutina (guardado en $v1)	    
	li $v0, 1	      #indicarle al sistema que se quiere mostrar un entero
	move $a0, $v1       #mover el entero de $v1 a $a0
	syscall             #llamada al sistema: mostrar el entero por pantalla
	
	#Ir a la etiqueta terminarPrograma
	j terminarPrograma

#Subrutina para busacr el menor de dos numeros
#Argumentos:  $a1 = entero 1
#		$a2 = entero 2
#Resultado:   $v1
buscarMenor: 
		#Guardar valores de los registros que van a ser utilizados
		addi $sp, $sp, -8	#modificar el stackPointer
		sw $t0, 4($sp)	#guardar el registro $t0 en el stack
		sw $t1, 0($sp)	#guardar el registro $t1 en el stack

		#mover los argumentos a registros temporales
		move $t0, $a1
		move $t1, $a2
		
		#Mostrar mensaje 3 al usuario: "El minimo es: "
		li $v0, 4	      #indicar al sistema que se quiere mostrar un string por pantalla
		la $a0, mensaje3    #cargar la dirección de memoria del mensaje 3
		syscall	      #llamada al sistema: mostrar el mensaje por pantalla
		
		#determinar cual entero es menor
		blt $t0, $t1, entero1EsMenor  #if entero1 < entero2 ir a entero1EsMenor
		move $v1, $t1		      	  #else mover valor de $t1 a $v1
		
		lw $t1, 0($sp)	#restaurar el valor del registro $t1
		lw $t0, 4($sp)	#restaurar el valor del registro $t0
		addi $sp, $sp, 8	#restaurar memoria en el stack
		
		jr $ra			#salir de la sub-rutina

		#Sub-rutina para mover el valor de $t0 a $v1 (resultado de la subrutina)
		entero1EsMenor: 
			#mover el valor de $t0 a $v1 (resultado)
			move $v1, $t0     
			
			#Restaurar stackPointer y Registros
			lw $t1, 0($sp)	#restaurar el valor del registro $v0 en el stack
			lw $t0, 4($sp)	#restaurar el valor del registro $a0
			addi $sp, $sp, 8	#restaurar memoria en el stack
			
			#salir de la subrutina
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