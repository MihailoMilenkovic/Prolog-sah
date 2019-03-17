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
    nadjiTablu(R,T1, P1),odigrajPotez(G,T1,T), P is P1+1.
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
odigrajPotez(S,TSTARA,TNOVA):-
    string_chars(S,C),
   	nadjiFiguru(C,F,C2),
    nadjiKrajnjePolje(C2,ROWEND,COLEND,C3),
    nadjiPocetnoPolje(F,ROWEND,COLEND,ROWSTART,COLSTART),
    pomeriSaKrajnjegNaPocetnoPolje(TSTARA,ROWSTART,COLSTART,ROWEND,COLEND,TNOVA),
    proveriUslove(C3,TSTARA,TNOVA).
/*nadjiFiguru- nalazi tip figure koji treba da se pomeri
  1)ako je prvo slovo notacije neka od figura nju pomeramo
  2)inace figura koja treba da se pomeri je pesak
  nakon pronalazenja figure brise se odgovarajuci znak iz stringa*/
nadjiFiguru([G|R],G, R):-(==(G,'R');==(G,'N');==(G,'B');==(G,'Q');==(G,'K')),!.
nadjiFiguru(C,'P', C).
/*nadjiKrajnjePolje-u listi poteza su zadate vrsta i kolona krajnjeg polja npr 'b','4'.
  Garantovano je da je je posledje mesto gde su karakter izmedju 'a' i 'h' i broj izemdju '1' i '8'
  bas ono mesto gde treba da se dodje.
  Da bismo dobili koordinate, obrcemo listu karaktera i trezimo prvo mesto gde je broj
  (ovo radimo jer potezi kao sto su "Rc8xb8" su validni, ali c8 u ovom slucaju nije mesto gde top treba da dodje)*/
nadjiKrajnjePolje(C2,ROWEND,COLEND,C3):- /*obrisi krajpolja da osta
                                     Rce1 * ne lista ogranicenja sah mat...*/
    obrni(C2,COBR),nadjiKrajnjePolje1(COBR,ROWEND,COLEND), char_code('a',ROA), char_code(G1,ROWEND+ROA-1), 
    													   char_code('1',CO1), char_code(G2,ROA+CO1-1),
    													   ocisti(G1, C2, PL), ocisti(G2, PL, C3).
nadjiKrajnjePolje1([G1|[G2|_]],ROWEND,COLEND):-
    char_code(G1,ROX),char_code('1',RO1),char_code('8',RO8),ROX>=RO1,ROX=<RO8,
	nadjiPolja(G1,G2,ROWEND,COLEND), !.
nadjiKrajnjePolje1([_|R],ROWEND,COLEND):-nadjiKrajnjePolje1(R,ROWEND,COLEND).
nadjiPolja(BR,CH,ROWEND,COLEND):-
    char_code(CH,ROX),char_code('a',ROA),ROWEND is ROX-ROA+1,
    char_code(BR,COX),char_code('1',CO1),COLEND is COX-CO1+1.
/* ocisti brise prvo ponavljanje odredjenog elementa u datoj listi*/
ocisti(_, [], []).
ocisti(X, [X|R], R) :- !.
ocisti(X, [_|R], NL) :- ocisti(X, R, NL).
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
