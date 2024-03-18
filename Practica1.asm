#Practica 1: Torres de hanoi
# Yaotecatl Miguel Martinez Ramirez
# Jordie Jeoshua Cervantes Jaramillo

#int main() {
#  int n;
#  printf("Introduzca el número de discos: ");
#  scanf("%d", &n);
#  hanoi(n, 1, 3, 2);
#  return 0;
#}

.text
	addi s0, zero, 2 #s0 = 3 numero de discos
	#declarar torres
	lui s1, 0x10001 #asignamos la torre origen
	slli t0, s0, 2 #calculamos el espacio de cada arreglo basado en los discos
	add s2, s1, t0 #asignamos la torre auxiliar
	add s3, s2, t0 #asignamos la torre destino
	
	add a2, a2, s0 #Guardamos n para no perder el apuntado original
	add a3, s1, zero #Guardamos el puntero de la torre original 
	
	#Detalle importante, es necesario settear los siguiente punteros 
	#una posicion después del inicio de la torre, asi que volvemos a sumar al puntero inicial
	add a4, s2, t0 #auxiliar
	add a5, s3, t0 #destino
	
	#Tomamos unas variables temporales para llenar la torre basandonos en el numero de discos
	addi t0, zero, 1
	add t1, t1, s1
	
for:	#llenamos la torre origen con los numeros 1-s0
	blt s0, t0 endfor 
	#guardamos el numero en la posicion actual
	sw t0, 0(t1)
	addi t1, t1, 4 #movemos el apuntador a la siguiente posicion
	addi t0, t0, 1 #actualizamos t0
	
	jal for
		
endfor:
	#llamamos a la funcion
	jal hanoi
	#Terminamos el programa
	jal endcode
	
	
#void hanoi(int n, int origen, int auxiliar, int destino) {
#  if (n == 1) {
#    printf("Mover disco 1 de %d a %d\n", origen, destino);
#  } else {
#    hanoi(n - 1, origen, destino, auxiliar);
#    printf("Mover disco %d de %d a %d\n", n, origen, destino);
#    hanoi(n - 1, auxiliar, destino, origen);
#  }
#}

hanoi:
	addi t0, zero, 1 #t0 = 1 para comparar
	bne a2, t0, else  #if a2 != 1 saltamos a else
	#Ojo con el movimiento, a3 es la posicion del elemento que vamos a mover
	sw zero, 0(a3)
	#Tenemos que mover ambos apuntadores para poder gaurdar en la posicion correcta
	addi a3, a3, 4
	#a5 Siempre va a estar una posicion desfazada, por lo que lo tenemos que ajustar
	addi a5, a5, -4
	#Guardamos el valor actual de n (a2) que deberia ser el disco actual
	sw a2, 0(a5) 
	#jal zero, move	esta seria una llamada a una supuesta funcion pero daba un problema con los saltos
	jalr ra 
else:
	#hanoi(n - 1, origen, destino, auxiliar);	
	addi sp, sp, -4 #hacemos espacio en el stack para guardar ra
	sw ra, 0(sp)
	addi sp, sp, -4 ##hacemos espacio en el stack para guardar n
	sw a2, 0(sp)
	 
	addi a2, a2, -1 #restamos 1 a n antes de la siguiente llamada a la fn
	
	#Realizamos un swap para cambiar la torre auxiliar y la destino
	add t0, a4, zero #t0 = auxiliar
	add a4, a5, zero #a4 = destino
	add a5, t0, zero #a5 = auxiliar
	
	#hacemos la 'llamada a la fn'
	jal hanoi
	
	#debido a que hicimos un swap con los apuntadores anteriormente, debemos regresarlos 
	add t0, a4, zero #t0 = destino
	add a4, a5, zero #a4 = auxiliar
	add a5, t0, zero #a5 = destino
	
	#Sacamos los valores guardados en el stack
	lw a2, 0(sp)
	addi sp, sp, 4
	lw ra, 0(sp)
	addi sp, sp, 4
	
	#Realizamos el movimiento de origen a destino
	sw zero, 0(a3)
	addi a3, a3, 4
	addi a5, a5, -4
	sw a2, 0(a5)
	
	#jal zero, move
		
	#hanoi(n - 1, auxiliar, destino, origen);
	#toca hacer la segunda llamada a la fn
	addi sp, sp, -4 #hacemos espacio en el stack para guardar ra
	sw ra, 0(sp)
	addi sp, sp, -4 ##hacemos espacio en el stack para guardar n
	sw a2, 0(sp)
	
	addi a2, a2, -1  #restamos 1 a n antes de la siguiente llamada a la fn

	#el mismo swap que antes pero ahora cambiando origen y auxiliar
	add t0, a3, zero #t0 = origen
	add a3, a4, zero #a3 = auxiliar
	add a4, t0, zero #a4 = origen
	
	jal hanoi
	
	#Nuevamente regresamos el orden de los apuntadores
	add t0, a3, zero #temp = auxiliar
	add a3, a4, zero #a3 = origen
	add a4, t0, zero #a5 = auxiliar
	
	#Sacamos los valores guardados en el stack
	lw a2, 0(sp)
	addi sp, sp, 4
	lw ra, 0(sp)
	addi sp, sp, 4
	 
	#Saltamos a la direccion guardada
	jalr ra

#move:
#	sw zero, 0(a3) 
#	addi a5, a5, -4
#	sw a2, 0(a5)
#	jalr ra
	
endcode:nop


