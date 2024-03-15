#int main() {
#  int n;
#  printf("Introduzca el número de discos: ");
#  scanf("%d", &n);
#  hanoi(n, 1, 3, 2);
#  return 0;
#}

.text
	addi s0, zero, 3 #s0 = 3 numero de discos
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
	addi t0, zero, 1 
	bne a2, t0, else  #if a2 != 1 saltamos a else
	#Ojo con el movimiento
	sw zero, 0(a3)
	addi a3, a3, 4
	addi a5, a5, -4
	sw a2, 0(a5) 
	#jal t2, move	
	jalr ra 
else:
	#mas de dos discos
	#hanoi(n - 1, origen, destino, auxiliar);
	
	addi sp, sp, -4 #hacemos espacio en el stack para guardar ra
	sw ra, 0(sp)
	addi sp, sp, -4 ##hacemos espacio en el stack para guardar n
	sw a2, 0(sp)
	
	addi a2, a2, -1
	
	add t0, a4, zero #t0 = auxiliar
	add a4, a5, zero #a4 = destino
	add a5, t0, zero #a5 = auxiliar
	
	jal hanoi
	
	add t0, a4, zero #t0 = destino
	add a4, a5, zero #a4 = auxiliar
	add a5, t0, zero #a5 = destino
	
	#origen
	lw a2, 0(sp)
	addi sp, sp, 4
	lw ra, 0(sp)
	addi sp, sp, 4
	
	#mov
	sw zero, 0(a3)
	addi a3, a3, 4
	addi a5, a5, -4
	sw a2, 0(a5)
		
	#cambios de discos
	#hanoi(n - 1, auxiliar, destino, origen);
	#jal t2, move
	addi sp, sp, -4 #hacemos espacio en el stack para guardar ra
	sw ra, 0(sp)
	addi sp, sp, -4 ##hacemos espacio en el stack para guardar n
	sw a2, 0(sp)
	
	addi a2, a2, -1

	add t0, a3, zero #t0 = origen
	add a3, a4, zero #a3 = auxiliar
	add a4, t0, zero #a4 = origen
	
	jal hanoi
	
	add t0, a3, zero #temp = auxiliar
	add a3, a4, zero #a3 = origen
	add a4, t0, zero #a5 = auxiliar
	
	#origen
	lw a2, 0(sp)
	addi sp, sp, 4
	lw ra, 0(sp)
	addi sp, sp, 4
	
	jalr ra

#move:
#	sw zero, 0(a3) 
#	addi a3, a3, 4
#	addi a5, a5, -4
#	sw a2, 0(a5)
endcode:nop


