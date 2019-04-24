/*igraj- ispisuje tablu i vraca true ako je moguca data lista poteza, a inace vraca false*/
/*podrazumeva se da je lista poteza zapisana u validnoj sahovskoj notaciji 
 * primer: ["f4","e5","g4","Qh4#"]*/
igraj(L,T):-
    obrni(L,LOBR),
    nadjiTablu(LOBR,T,1),
    ispisiTablu(T).
/*obrtanje liste na pocetku, da bi rad sa potezima bio laksi*/ 
obrni(L,LO):-
    obrni1(L,LO,[]).
obrni1([],LO,LO).
obrni1([G|R],LO,A):-obrni1(R,LO,[G|A]).
/*broj elem u listi*/
count([],0).
count([_|R],N) :- count(R,N1) , N is N1+1.
/*ispisivanje table -red po red, svaki red element po element*/
ispisiTablu([]):-!.
ispisiTablu([G|R]):-
    ispisiRed(G),ispisiTablu(R).
ispisiRed([]):-
    format('~n',[]),!.
ispisiRed([G|R]):-
    format('~a ',[G]),ispisiRed(R).
/*nadjiTablu- vraca tablu nakon nekog niza poteza
 	1)izlaz iz rekurzije- pocetna tabla
 	2)za svaki elemenat liste igramo potez ako je moguc i vracamo izmenjenu tablu*/
nadjiTablu([],[ ['R','N','B','Q','K','B','N','R'],
                ['P','P','P','P','P','P','P','P'],
                ['O','O','O','O','O','O','O','O'],
                ['O','O','O','O','O','O','O','O'],
                ['O','O','O','O','O','O','O','O'],
                ['O','O','O','O','O','O','O','O'],
                ['p','p','p','p','p','p','p','p'],
                ['r','n','b','q','k','b','n','r'] ] ,1):-!.
nadjiTablu([G|R],T,P):-
    nadjiTablu(R,T1, P1), P is P1 + 1, odigrajPotez(G,T1,T, P).
/*odigrajPotez-ima tablu pre poteza i potez, vraca tablu posle poteza ako je moguc, inace je false
 	0)pretvaramo string u list karaktera da bi lakse radili sa njima
 	1)nadjemo figuru koju treba pomeriti
    1)nadjemo koordinate polja gde treba da se dodje 
    2)prodjemo kroz tablu i nadjemo sve figure koje mogu da dodju do tog polja
    3)za svako polje proveravamo da li postoji data figura na tog polju
      a)ako ih nema nijedna- nemoguc potez
      b)ako ima vise- ako je navedeno koja je-moguce, inace ne
      c)ako ima samo jedna- pomerimo je na to polje, a njeno pocetno polje postaje prazno
    X)obrada posebnih slucajeva poteza (sahovi, patovi, promocije, rokade, en-passant itd.)*/
odigrajPotez(S,TSTARA,TNOVA, P):-
    string_chars(S,C),
    /*ako je S = O-O, O-O-O, pretvroimo string u normalan potez*/
   	nadjiFiguru(C,F2,C2),
    nadjiIgraca(F2, P, F),
    obrni(C2,C3),
    nadjiPolje(C3,ROWEND,COLEND,C4),/*krajnje polje*/
    nadjiPolje(C4,ROWSTART,COLSTART,_),/*pocetno polje(   treba menjati*/
    pomeriSaKrajnjegNaPocetnoPolje(F, TSTARA,ROWSTART,COLSTART,ROWEND,COLEND,TNOVA, 8).
/*nadjiFiguru- nalazi tip figure koji treba da se pomeri
  1)ako je prvo slovo notacije neka od figura nju pomeramo
  2)inace figura koja treba da se pomeri je pesak
  nakon pronalazenja figure brise se odgovarajuci znak iz stringa*/
nadjiFiguru([G|R],G, R):-(==(G,'R');==(G,'N');==(G,'B');==(G,'Q');==(G,'K')),!.
nadjiFiguru(C,'P', C).
/*ako je potez paran, prebacujemo figuru u malo slovo
 Da li igra beli ili crni*/
nadjiIgraca(F2, P, F2):- P mod 2 =\= 0.
nadjiIgraca(F2, P, F):- P mod 2 =:= 0, char_code('a', ROA), char_code('A', ROCA), DIF is ROA - ROCA, 
    					char_code(F2, FIG2), FIG is FIG2 + DIF, char_code(F, FIG).
/*nalazi polje u potezu i brise ga iz poteza*/
nadjiPolje([G1,G2|X],ROWEND,COLEND,X):-
    char_code(G1,ROX),char_code('1',RO1),char_code('8',RO8),ROX>=RO1,ROX=<RO8,
	pretvoriUBrojeve(G1,G2,COLEND,ROWEND), !.
nadjiPolje([G|R],ROWEND,COLEND,R1):-nadjiPolje(R,ROWEND,COLEND,[G|R1]).                                            
pretvoriUBrojeve(BR,CH,COLEND,ROWEND):-
    char_code(CH,ROX),char_code('a',ROA),ROWEND is ROX-ROA+1,
    char_code(BR,COX),char_code('1',CO1),COLEND is COX-CO1+1.
/*nadjiPocetnoPolje
 * treba izmeniti- za sad isto sto i nadjiPolje*/
    
/*okPotez- ako neka figura moze da dodje sa jednog polja na drugo, tako da je potez validan
 proveravamo da li figura moze da dodje na neko mesto i da li su pocetak i kraj razliciti*/
okPotez(F,ROWEND,COLEND,ROWSTART,COLSTART):-
    (ROWEND=\=ROWSTART;COLEND=\=COLSTART),
    mozeDaDodje(F,ROWEND,COLEND,ROWSTART,COLSTART).
/*mozeDaDodje(F,xen,yen,xst,yst)- proverava da li figura F moze da dodje iz (xst,yst) na (xen,yen)*/
/*kraljica: moze da dodje na neko polje ako to moze lovac ili top */
mozeDaDodje('Q',ROWEND,COLEND,ROWSTART,COLSTART):-
    mozeDaDodje('B',ROWEND,COLEND,ROWSTART,COLSTART);
    mozeDaDodje('R',ROWEND,COLEND,ROWSTART,COLSTART).
/*top: moze da dodje na neko polje ako su vrste ili kolone jednake*/
mozeDaDodje('R',ROWEND,COLEND,ROWSTART,COLSTART):-
    (   ROWEND=:=ROWSTART;COLEND=:=COLSTART).
/*lovac: moze da dodje na neko polje ako su pocetno i startno na istoj dijagonali.
  Neka 2 polja su na istoj dijagonali akko je zbir ili razlika koordinata tih polja jednaka*/
mozeDaDodje('B',ROWEND,COLEND,ROWSTART,COLSTART):-
    ZB1 is ROWEND+COLEND,ZB2 is ROWSTART+COLSTART,RAZL1 is ROWEND-COLEND,RAZL2 is ROWSTART-COLSTART,
    (   ZB1=:=ZB2;RAZL1=:=RAZL2).
/*kralj: moze da dodje na neko polje ako je razlika apsolutnih vresnosti vrsta <=1 (isto vazi i za kolone)*/
mozeDaDodje('K',ROWEND,COLEND,ROWSTART,COLSTART):-
    R1 is ROWEND-ROWSTART,R2 is COLEND-COLSTART,
    abs(R1)=<1,abs(R2)=<1.
/*konj: moze da dodje na neko polje ako je razlika apsloutnih vrednosti vrsta 1, a kolona 2(i obrnuto)*/
mozeDaDodje('N',ROWEND,COLEND,ROWSTART,COLSTART):-
    R1 is ROWEND-ROWSTART,R2 is COLEND-COLSTART,
    (   (abs(R1)=:=1,abs(R2)=:=2);(abs(R1)=:=2,abs(R2)=:=1)  ) .
/*pesak: 2 slucaja:
  1)beli:ako je na vrsti 2 moze da dodje na vrstu 4 i istu kolonu.
  	Inace moze na 1 vrstu vise, ako je apsolutna razlika kolona<=1. 
  2)crni:ako je na vrsti 7 moze da dodje na vrstu 5 i istu kolonu.
  	Inace moze na 1 vrstu nize, ako je aposolutna razlika kolona<=1.*/
mozeDaDodje('p',4,X,2,X).
mozeDaDodje('p',ROWEND,COLEND,ROWSTART,COLSTART):-
    ROWS is ROWEND-1, ROWS=:=ROWSTART, R2 is COLEND-COLSTART,abs(R2)=<1.
mozeDaDodje('P',7,X,5,X).
mozeDaDodje('P',ROWEND,COLEND,ROWSTART,COLSTART):-
    ROWS is ROWEND+1, ROWS=:=ROWSTART, R2 is COLEND-COLSTART,abs(R2)=<1.
/*veliko slovo-upcase_atom(chstari,chnovi).*/ 
/*staru tablu pretvaramo u novu tako sto:
            1)brisemo sta se nalazilo na pocetnom polju i pisemo 'O' na tom mestu, a na krajnje pisemo slovo figure kojom igramo
            2) ostatak table ostavljamo neizmenjen*/
pomeriSaKrajnjegNaPocetnoPolje(_,[],_,_,_,_,[],0):-!.
pomeriSaKrajnjegNaPocetnoPolje(F, [G|R],ROWSTART,COLSTART,ROWEND,COLEND,[G1|R1], RED):- 
                                  obidjiRed(G,G1,RED,1,F,ROWSTART,COLSTART,ROWEND,COLEND),
                                  pomeriSaKrajnjegNaPocetnoPolje(F,R,ROWSTART,COLSTART,ROWEND,COLEND,R1, RED1),RED is RED1+1.
obidjiRed([],[],_,9,_,_,_,_,_):-!.
obidjiRed([G|R], [G1|R1], RED, KOLONA, F, ROWSTART,COLSTART,ROWEND,COLEND):-
    proveriPocetnoIliKrajnje(F, RED, KOLONA, ROWSTART, COLSTART, ROWEND, COLEND, G, G1),
    KOLONA1 is KOLONA+1, obidjiRed(R, R1, RED, KOLONA1, F, ROWSTART,COLSTART,ROWEND,COLEND).

proveriPocetnoIliKrajnje(_, RED, KOLONA, RED, KOLONA, _, _, _, 'O'):-!.
proveriPocetnoIliKrajnje(F, RED, KOLONA, _, _, RED, KOLONA, _, F):-!.
proveriPocetnoIliKrajnje(_, _, _, _, _, _, _, G, G).
