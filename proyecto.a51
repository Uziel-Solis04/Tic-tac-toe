org 0000h
	jmp inicio
	
org 0013h //Interrupcion del teclado, externa 1
	jmp turn
	
org 0040h
	inicio:
		MOV IE, #10000100b
		setb it1
		mov r0, #90h
		mov r3, #0h
		mov r4, #0h
		mov r6, #0h
		mov r7, #0h
		acall initMemo // for que inicializa memoria
		mov r0, #90h
		setb P1.5 //Turno amarillo
		clr P1.6 //Led azul
		mov r3, #0h //Contador de turnos 0-> amarillo, 1->azul
		mov P0, #00h
		mov P2, #00h
		clr P3.6
		clr P3.7
		clr P1.4
		clr P1.7
		sjmp wait //valores matriz 1-> amarillo , 2-> azul
		
	initMemo:
		mov @r0, #0h
		inc r3
		inc r0
		cjne r3, #3, initMemo
		mov r3, #0h
		mov a, r0
		dec a
		dec a
		dec a
		add a , #10h
		mov r0, a
		inc r4
		cjne r4, #3, initMemo
		ret
		
	wait:
		sjmp $
	
	turn:
		mov r0, #90h
		mov a, P1 //binario de tecla presionada
		anl a, #00001111b
		cjne r3, #0h, azulTurn //r3 -> 1 -> turno azul
		jmp amaTurn //r3 -> 0 -> turno amarillo
	
	retif3:
		reti 
		
		Alet:
		mov r4, #20h
		acall checkOcc //checa que el espacio este vacio 
		cjne a, #0, retif3 //si el valor en matriz no es cero, esta ocupada
		setb P3.7
		acall check
		acall check_normal_diagonal
		dec r3
		jmp save
		
	azulTurn:
		mov r5, #02h
		jz cero
		dec a
		jz uno
		dec a
		jz dos
		dec a
		dec a
		jz cuatro
		dec a
		jz cinco
		dec a
		jz seis
		dec a
		dec a
		jz ocho
		dec a
		jz nueve
		dec a
		jz Alet
		reti
		cero:
			mov r4, #02h //cantidad de saltos a dar en memoria
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif3 //si el valor en matriz no es cero, esta ocupada
			setb P2.0 //prender let
			acall check
			acall check_normal_diagonal
			dec r3
			jmp save //guarda en memoria
		uno:
			mov r4, #12h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P2.1
			acall check
			dec r3
			jmp save
		dos:
			mov r4, #22h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P2.2
			acall check
			acall check_normal_diagonal
			dec r3
			jmp save
		cuatro:
			mov r4, #01h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P2.3
			acall check
			dec r3
			jmp save
		cinco:
			mov r4, #11h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			mov r7, #01h
			setb P2.4
			acall check
			mov r1, #0A1h
			mov a, r5
			mov @r1, a
			acall check_center
			dec r3
			cpl P1.6
			cpl P1.5
			reti
		seis:
			mov r4, #21h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P2.5
			acall check
			dec r3
			jmp save
		ocho:
			mov r4, #0h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P2.6
			acall check
			acall check_normal_diagonal
			dec r3
			jmp save
		nueve:
			mov r4, #10h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P2.7
			acall check
			dec r3
			jmp save
	
		retif:
			reti
	ceroA:
			mov r4, #02h //cantidad de saltos a dar en memoria
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P0.0 //prender let
			acall check
			acall check_normal_diagonal
			inc r3
			jmp save //guarda en memoria
			
	amaTurn:
		mov r5, #01h //-> valor a insertar en matriz
		jz ceroA
		dec a
		jz unoA
		dec a
		jz dosA
		dec a
		dec a
		jz cuatroA
		dec a
		jz cincoA
		dec a
		jz seisA
		dec a
		dec a
		jz ochoA
		dec a
		jz nueveA
		dec a
		jz AletA
		reti
		unoA:
			mov r4, #12h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P0.1
			acall check
			inc r3
			sjmp save
		dosA:
			mov r4, #22h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P0.2
			acall check
			acall check_normal_diagonal
			inc r3
			sjmp save
		cuatroA:
			mov r4, #01h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P0.3
			acall check
			inc r3
			sjmp save
		cincoA:
			mov r4, #11h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P0.4
			mov r7, #01h
			acall check
			mov r1, #0A1h
			mov a, r5
			mov @r1, a
			acall check_center
			inc r3
			cpl P1.6
			cpl P1.5
			reti
		seisA:
			mov r4, #21h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif //si el valor en matriz no es cero, esta ocupada
			setb P0.5
			acall check
			inc r3
			sjmp save
		ochoA:
			mov r4, #0h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif2 //si el valor en matriz no es cero, esta ocupada
			setb P0.6
			acall check
			acall check_normal_diagonal
			inc r3
			sjmp save
		nueveA:
			mov r4, #10h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif2 //si el valor en matriz no es cero, esta ocupada
			setb P0.7
			acall check
			inc r3
			sjmp save
		AletA:
			mov r4, #20h
			acall checkOcc //checa que el espacio este vacio 
			cjne a, #0, retif2 //si el valor en matriz no es cero, esta ocupada
			setb P3.6
			acall check
			acall check_normal_diagonal
			inc r3
			sjmp save
			
		checkOcc:
			mov a, r0
			add a, r4
			mov r0, a
			mov a, @r0
			ret 
		
		retif2:
			reti
			
		save:
			mov a, r5
			mov @r0, a
			cpl P1.6
			cpl P1.5
			reti
			
		check:
			mov r4, #10h
			acall check2
			mov r4, #01h
			acall check2
			ret
				
		check2:
			mov r6, #01h
			mov a, r0
			mov r1, a
			acall addi
			mov a, r0
			mov r1, a
			acall subi
			ret
			
		addi:
			mov a, r1
			add a, r4
			mov r1, a
			mov a, @r1
			mov b, r5
			cjne a, b, retf
			inc r6
			cjne r6, #03h, addi
			sjmp win
			
		subi:
			mov a, r1
			clr c
			subb a, r4
			mov r1, a
			mov a, @r1
			mov b, r5
			cjne a, b, retf
			inc r6
			cjne r6, #03h, subi
			sjmp win
			
		win:
			cjne r3, #0, winBlue
			setb P1.4
			sjmp endi
			
		winBlue:
			setb P1.7
			sjmp endi
			
		endi:
			sjmp $
		
		retf:
			ret
		
		check_normal_diagonal:
			acall check_normal_diagonal_up
			acall check_normal_diagonal_down
			ret
			
		check_normal_diagonal_up:
			mov r6, #01h
			mov r4, #11h
			mov a, r0
			mov r1, a
			acall addi
			mov r6, #01h
			mov r4, #11h
			mov a, r0
			mov r1, a
			acall subi
			ret
			
		check_normal_diagonal_down:
			mov r6, #01h
			mov r4, #0Fh
			mov a, r0
			mov r1, a
			acall addi
			mov r6, #01h
			mov r4, #0Fh
			mov a, r0
			mov r1, a
			acall subi
			ret
		
		check_diagonal_up:
			mov r6, #01h
			mov r4, #11h
			mov a, r0
			mov r1, a
			acall addi
			mov r6, #01h
			mov r4, #0Fh
			mov a, r0
			mov r1, a
			acall subi
			ret
			
		check_diagonal_down:
			mov r6, #01h
			mov r4, #0Fh
			mov a, r0
			mov r1, a
			acall addi
			mov r6, #01h
			mov r4, #11h
			mov a, r0
			mov r1, a
			acall subi
			ret
		
		check_center:
			mov r0, #90h
			mov a, @r0
			mov b, r5
			cjne a, b, checkOther
			acall check_diagonal_up
			ret
			
		checkOther:
			mov r0, #92H
			mov a, @r0
			mov b, r5
			cjne a, b, retf
			acall check_diagonal_down
			ret
	end
		