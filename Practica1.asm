#int main() {
#  int n;
#  printf("Introduzca el número de discos: ");
#  scanf("%d", &n);
#  hanoi(n, 1, 3, 2);
#  return 0;
#}

.text
	addi s0, zero, 1 #s0 = 3 numero de discos
	#declarar torres
	lui s1, 0x10001 #torre 1
	slli t0, s0, 2 	#calculamos el espacio de cada arreglo basado en los discos
	add s2, s1, t0 #torre 2
	add s3, s2, t0 #torre 3
	
	add t0, zero, s0
	add t1, t1, s1
for:	#llenamos la torre inicial con los numeros 1-s0
	bge zero, t0 endfor 
	
	sw t0, 0(t1)
	addi t1, t1, 4
	
	addi t0, t0, -1
	
	jal for
		
endfor:
	
	#llamamos a la funcion
	add a2, a2, s0 #n
	add a3, a3, s1 #origen
	add a4, a4, s2 #auxiliar
	add a5, a5, s3 #destino
	jal hanoi
	jal endcode
	
	
#void hanoi(int n, int origen, int destino, int auxiliar) {
#  if (n == 1) {
#    printf("Mover disco 1 de %d a %d\n", origen, destino);
#  } else {
#    hanoi(n - 1, origen, auxiliar, destino);
#    printf("Mover disco %d de %d a %d\n", n, origen, destino);
#    hanoi(n - 1, auxiliar, destino, origen);
#  }
#}

hanoi:
	addi t0, zero, 1 
	bne a2, t0, else  #if a2 != 1 saltamos a else
	lw t1, 0(a3) #leemos el valor almacenado en la torre de origen
	sw zero, 0(a3) 	#sobre escribimos el valor con 0
	sw t1 0(a5) #lo cambiamos a la siguiente torre
	jalr ra
else:
	#mas de dos discos
	
	jalr ra

endcode:nop

