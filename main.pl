/*igraj- ispisuje tablu i vraca true ako je moguca data lista poteza, a inace vraca false*/
/*podrazumeva se da je lista poteza zapisana u validnoj  sahovskoj notaciji 
 * primer: ["f2f4","e7e5","g2g4","Qd8h4#"]*/
odigrajPartiju(L):-
    igraj(L,_).
igraj(L,T):-
    obrni(L,LOBR),
    nadjiTablu(LOBR,T,_),
    ispisiTablu(T).
/*obrtanje liste na pocetku, da bi rad sa potezima bio laksi*/ 
obrni(L,LO):-
    obrni1(L,LO,[]).
obrni1([],LO,LO).
obrni1([G|R],LO,A):-obrni1(R,LO,[G|A]).
/*broj elem u listi*/
count([],1).
count([_|R],N) :- count(R,N1) , N is N1+1.
/*ispisivanje table -red po red, svaki red element po element
 * isisivanje radimo pomocu ugradjene funkcije format, gde se atom ispisuje kao ~a, a kraj reda kao ~n*/
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
 	0)pretvaramo string u listu karaktera uz pomoc ugradjene funkcije string_chars
 	1)nadjemo figuru koju treba pomeriti
    2)nadjemo koji igrac je trenutno na potezu i u zavisnosti od toga pretvaramo figuru i malo ili veliko slovo
    3)nadjemo koordinate polja gde treba da se dodje 
    4)nadjemo koordinate polja sa kog polazimo
    5)proveravamo da li je potez validan
    6)pomeramo figuru sa pocetnog na krajnje polje
    7)proverimo posebne slucajeve poteza(sahove,promocije)
    8)proverimo da kralj boje koja je upravo igrala nije napadnut nakon igranja poteza*/
/*poseban slucaj poteza-mala/velika rokada.
 * mala rokada je obelezena sa 'O-O',a velika sa 'O-O-O'
 * za malu prvo proveravaom uslove, a onda menjamo tablu i analogno za veliku.
 * kada obradimo rokadu ide rez, jer ne obradjujemo uslove kao za ostale poteze
 * */
odigrajPotez('O-O',TSTARA,TNOVA,P):-
    P mod 2=:=0,proveriUsloveZaMaluRokadu(TSTARA,1,'k','r'),odigrajMaluRokadu(TSTARA,1,TNOVA,'k','r'),!.
odigrajPotez('O-O',TSTARA,TNOVA,P):-
    P mod 2=:=1,proveriUsloveZaMaluRokadu(TSTARA,8,'K','R'),odigrajMaluRokadu(TSTARA,8,TNOVA,'K','R'),!.
odigrajPotez('O-O-O',TSTARA,TNOVA,P):-
    P mod 2=:=0,proveriUsloveZaVelikuRokadu(TSTARA,1,'k','r'),odigrajVelikuRokadu(TSTARA,1,TNOVA,'k','r'),!.
odigrajPotez('O-O-O',TSTARA,TNOVA,P):-
    P mod 2=:=1,proveriUsloveZaVelikuRokadu(TSTARA,8,'K','R'),odigrajVelikuRokadu(TSTARA,8,TNOVA,'K','R'),!.
/*uslovi su za sad da su figure na ok poljima (kralj i top na pocetnim poljima i nema nista izmedju)
 * uslovi za rokadu:
 * 1)polja izmedju kralja i topa su prazna
 * 2)kralj i top su na pocetnim pozicijama, tj. nisu se pomerali cele partije
 * (ovaj deo je komplikovaniji, jer treba videti poteze od ranije,pa se ovde samo proverava da li su na startnim pozicijama)
 * 3)polja od kraljevog pocetnog do krajnjeg nisu napadnuta
 * */
proveriUsloveZaMaluRokadu(T,RED,KRALJ,TOP):-
    boja(KRALJ,BOJA),BOJANAPADACA is 3-BOJA,
    nadjiFiguruNaDatojPoziciji(T,RED,5,KRALJ),
    nadjiFiguruNaDatojPoziciji(T,RED,6,'O'),
    nadjiFiguruNaDatojPoziciji(T,RED,7,'O'),
    nadjiFiguruNaDatojPoziciji(T,RED,8,TOP),
    not(proveriDaLiJeNapadnut(T,RED,5,BOJANAPADACA)),
    not(proveriDaLiJeNapadnut(T,RED,6,BOJANAPADACA)),
    not(proveriDaLiJeNapadnut(T,RED,7,BOJANAPADACA)).
proveriUsloveZaVelikuRokadu(T,RED,KRALJ,TOP):-
    boja(KRALJ,BOJA),BOJANAPADACA is 3-BOJA,
    nadjiFiguruNaDatojPoziciji(T,RED,5,KRALJ),
    nadjiFiguruNaDatojPoziciji(T,RED,4,'O'),
    nadjiFiguruNaDatojPoziciji(T,RED,3,'O'),
    nadjiFiguruNaDatojPoziciji(T,RED,2,'O'),
    nadjiFiguruNaDatojPoziciji(T,RED,1,TOP),
    not(proveriDaLiJeNapadnut(T,RED,5,BOJANAPADACA)),
    not(proveriDaLiJeNapadnut(T,RED,4,BOJANAPADACA)),
    not(proveriDaLiJeNapadnut(T,RED,3,BOJANAPADACA)).
/*rokadu igramo tako sto upsiujemo i topa na njihove krajnje pozicije, a stavljamo prazna polja na nijhove pocetne)
 * */
odigrajMaluRokadu(TSTARA,RED,TNOVA,KRALJ,TOP):-
    postaviFiguruNaMesto(TSTARA,T1,'O',RED,5),
    postaviFiguruNaMesto(T1,T2,TOP,RED,6),
    postaviFiguruNaMesto(T2,T3,KRALJ,RED,7),
    postaviFiguruNaMesto(T3,TNOVA,'O',RED,8).
odigrajVelikuRokadu(TSTARA,RED,TNOVA,KRALJ,TOP):-
    postaviFiguruNaMesto(TSTARA,T1,'O',RED,5),
    postaviFiguruNaMesto(T1,T2,TOP,RED,4),
    postaviFiguruNaMesto(T2,T3,KRALJ,RED,3),
    postaviFiguruNaMesto(T3,T4,'O',RED,2),
    postaviFiguruNaMesto(T4,TNOVA,'O',RED,1).
odigrajPotez(S,TSTARA,TNOVA, P):-
    /*dodaj za rokadu*/
    string_chars(S,C),
    /*ako je S = O-O, O-O-O, pretvroimo string u normalan potez*/
   	nadjiFiguru(C,F2,C2),
    nadjiIgraca(F2, P, F),
    obrni(C2,C3),
    nadjiPolje(C3,COLEND,ROWEND,C4),/*krajnje polje*/
    nadjiPolje(C4,COLSTART,ROWSTART,OGRANICENJA),/*pocetno polje*/
    proveriOgranicenja(OGRANICENJA,TSTARA,F,ROWSTART,COLSTART,ROWEND,COLEND),
    pomeriSaPocetnogNaKrajnjePolje(TSTARA,TNOVA1,F,ROWSTART,COLSTART,ROWEND,COLEND),
    izmeniTabluAkoJePromocija(TNOVA1,TNOVA,F,ROWEND,COLEND),
    proveriDaLiJeSah(TNOVA,OGRANICENJA,P),
    proveriDaLiJeMat(TNOVA,OGRANICENJA,P),
    PNOVI is P+1,
    not(kraljJeNapadnut(TNOVA,PNOVI)).
/*nadjiFiguru- nalazi tip figure koji treba da se pomeri
 * (figura je uvek zadata vilikim slovima)
  1)ako je prvo slovo notacije neka od figura nju pomeramo
  2)inace figura koja treba da se pomeri je pesak
  nakon pronalazenja figure brise se odgovarajuci znak iz stringa*/
nadjiFiguru([G|R],G, R):-(==(G,'R');==(G,'N');==(G,'B');==(G,'Q');==(G,'K')),!.
nadjiFiguru(C,'P', C).
/*nadji igraca-menja dobijenu figuru u malo slovoako je potez paran, a inace ostavlja veliko 
 ako znamo da li je figura mala ili velika, znamo koji igrac je na redu*/
nadjiIgraca(F2, P, F2):- P mod 2 =\= 0.
nadjiIgraca(F2, P, F):- P mod 2 =:= 0, char_code('a', ROA), char_code('A', ROCA), DIF is ROA - ROCA, 
    					char_code(F2, FIG2), FIG is FIG2 + DIF, char_code(F, FIG).
/*nadjiPolje-nalazi polje u potezu i brise ga iz poteza
 * posto se u sahovskoj notaciji prvo nadovdi slovo pa broj za neko polje a listu obrcemo,
 *  kada naidjemo na broj na intervalu [1,8] vratimo njega i karakter posle, koje zatim pretvaramo u brojeve*/
nadjiPolje([G1,G2|X],ROWEND,COLEND,X):-
    char_code(G1,ROX),char_code('1',RO1),char_code('8',RO8),ROX>=RO1,ROX=<RO8,
	pretvoriUBrojeve(G1,G2,COLEND,ROWEND), !.
nadjiPolje([G|R],ROWEND,COLEND,[G|R1]):-nadjiPolje(R,ROWEND,COLEND,R1).                                            
pretvoriUBrojeve(BR,CH,COLEND,ROWEND):-
    char_code(CH,ROX),char_code('a',ROA),ROWEND is ROX-ROA+1,
    char_code(BR,COX),char_code('1',CO1),COLEND is COX-CO1+1.
/*proveriOgranicenja:za neki potez proverava ogranicenja koja vaze PRE IGRANJA TOG POTEZA
  potez igramo ako zadovoljava sledece uslove:
  1)pocetno polje ima figuru kojom se navodi da igramo
  2)krajnje polje nema figuru iste boje
  3)datom figurom se moze stici od pocetnog do krajnjeg polja
  4)polja na putu od pocetnog do krajnjeg su sva prazna
  5)ako je figura na krajnjem polju suprotne boje, u notaciji se pojavljuje x, a u suprotnom ne sme da se pojavi x
  ogranicenja posle igranja poteza proveravamo u odigrajPotez,A NE OVDE
 * */
proveriOgranicenja(LISTAOGRANICENJA,T,F,ROWSTART,COLSTART,ROWEND,COLEND):-
    pocetnoPoljeImaDatuFiguru(T,F,ROWSTART,COLSTART),
    krajnjePoljeNemaFiguruIsteBoje(T,F,ROWEND,COLEND),
    okPotez(F,ROWSTART,COLSTART,ROWEND,COLEND,T),
    poljaNaPutuSuPrazna(T, ROWSTART, COLSTART, ROWEND, COLEND, F),
    daLiJede(T, F, ROWEND, COLEND, LISTAOGRANICENJA).
/*okPotez-vraca true ako figura moze da dodje sa pocetnog na krajnje polje
 *proveravamo da li su pocetno i krajnje polje razliciti i pravila za kretanjee svake od figura(funkcija mozeDaDodje)*/
okPotez(F,ROWSTART,COLSTART,ROWEND,COLEND,T):-
    (ROWEND=\=ROWSTART;COLEND=\=COLSTART), %format('figura je:~a\n a polja ~a ~a ~a ~a',[F,ROWSTART,COLSTART,ROWEND,COLEND]),
    mozeDaDodje(F,ROWSTART,COLSTART,ROWEND,COLEND,T).
/*mozeDaDodje proverava da li figura F moze da dodje iz sa pocetnog na krajnje polje u jednom potezu*/
/*kraljica: moze da dodje na neko polje ako to moze lovac ili top */
mozeDaDodje('q',ROWSTART,COLSTART,ROWEND,COLEND,_):-
   	mozeDaDodje('Q',ROWSTART,COLSTART,ROWEND,COLEND,_).
mozeDaDodje('Q',ROWSTART,COLSTART,ROWEND,COLEND,_):-
	(mozeDaDodje('B',ROWSTART,COLSTART,ROWEND,COLEND,_);
    mozeDaDodje('R',ROWSTART,COLSTART,ROWEND,COLEND,_)).
/*top: moze da dodje na neko polje ako su vrste ili kolone jednake*/
mozeDaDodje('r',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    mozeDaDodje('R',ROWSTART,COLSTART,ROWEND,COLEND,_).
mozeDaDodje('R',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    (   ROWEND=:=ROWSTART;COLEND=:=COLSTART).
/*lovac: moze da dodje na neko polje ako su pocetno i krajnje na istoj dijagonali.
  Neka 2 polja su na istoj dijagonali akko je zbir ili razlika koordinata tih polja jednaka*/
mozeDaDodje('b',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    mozeDaDodje('B',ROWSTART,COLSTART,ROWEND,COLEND,_).
mozeDaDodje('B',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    ZB1 is ROWEND+COLEND,ZB2 is ROWSTART+COLSTART,RAZL1 is ROWEND-COLEND,RAZL2 is ROWSTART-COLSTART,
    (   ZB1=:=ZB2;RAZL1=:=RAZL2).
/*kralj: moze da dodje na neko polje ako je razlika apsolutnih vresnosti vrsta <=1 i razlika apsolutnih vresnosti kolona <=1*/
mozeDaDodje('k',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    mozeDaDodje('K',ROWSTART,COLSTART,ROWEND,COLEND,_).
mozeDaDodje('K',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    R1 is ROWEND-ROWSTART,R2 is COLEND-COLSTART,
    abs(R1)=<1,abs(R2)=<1.
/*konj: moze da dodje na neko polje ako je razlika apsloutnih vrednosti vrsta 1, a kolona 2 ili razlika apsloutnih vrednosti vrsta 2, a kolona 1*/
mozeDaDodje('n',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    mozeDaDodje('N',ROWSTART,COLSTART,ROWEND,COLEND,_).
mozeDaDodje('N',ROWSTART,COLSTART,ROWEND,COLEND,_):-
    R1 is ROWEND-ROWSTART,R2 is COLEND-COLSTART,
    (   (abs(R1)=:=1,abs(R2)=:=2);(abs(R1)=:=2,abs(R2)=:=1)  ) .
/*pesak: 2 slucaja:
  1)beli:ako je na vrsti 2 moze da dodje na vrstu 4 i istu kolonu.
  	Inace moze na 1 vrstu vise, ako je apsolutna razlika kolona<=1. 
  2)crni:ako je na vrsti 7 moze da dodje na vrstu 5 i istu kolonu.
  	Inace moze na 1 vrstu nize, ako je aposolutna razlika kolona<=1.
    kod pesaka razlikujemo 2 tipa kretanja:
    1)normalno-pomera se za 1 polje napred(ili 2 na pocetku)-za ovaj slucaj krajnje polje mora biti prazno
    2)dijagonalno-pomera se za 1 polje napred i 1 u stranu-za ovaj slucaj krajnje polje mora da ima figuru suprotne boje*/
mozeDaDodje('p',2,X,4,X,T):-nadjiFiguruNaDatojPoziciji(T,4,X,'O').
mozeDaDodje('p',ROWSTART,COLSTART,ROWEND,COLEND,T):-
    ROWS is ROWEND-1, ROWS=:=ROWSTART, R2 is COLEND-COLSTART,abs(R2)=<1,krajnjePoljeNijePraznoAkoIdeDijagonalno(T,COLSTART,ROWEND,COLEND).
mozeDaDodje('P',7,X,5,X,T):-nadjiFiguruNaDatojPoziciji(T,5,X,'O').
mozeDaDodje('P',ROWSTART,COLSTART,ROWEND,COLEND,T):-
    ROWS is ROWEND+1, ROWS=:=ROWSTART, R2 is COLEND-COLSTART,abs(R2)=<1,krajnjePoljeNijePraznoAkoIdeDijagonalno(T,COLSTART,ROWEND,COLEND).
krajnjePoljeNijePraznoAkoIdeDijagonalno(T,COL,ROWEND,COL):-nadjiFiguruNaDatojPoziciji(T,ROWEND,COL,'O').
krajnjePoljeNijePraznoAkoIdeDijagonalno(T,COLSTART,ROWEND,COLEND):-
    COLSTART=\=COLEND,nadjiFiguruNaDatojPoziciji(T,ROWEND,COLEND,F),not(==(F,'O')).
/*pomeriSaPocetnogNaKrajnjePolje-na pocetno polje upisujemo 'O',a na krajnje figuru kojom igramo*/
pomeriSaPocetnogNaKrajnjePolje(TSTARA, TNOVA, F, ROWSTART, COLSTART, ROWEND, COLEND):-
    postaviFiguruNaMesto(TSTARA,T1,F,ROWEND,COLEND),postaviFiguruNaMesto(T1,TNOVA,'O',ROWSTART,COLSTART).
/*nadjiFiguruNaDatojPoziciji- vraca figuru koja se nalazi na datoj poziciji u tabli
  prvo nadjemo red koji se nalazi na poziciji 8-RED+1(jer nam je u tabli 8. red na pocetku itd.),
  zatim u tom redu nalzimo elemenat na poziciji KOLONA i to je upravo trazena figura
  (obe ove stvari radimo pomocu funkcije nadjiElemenatNaPozicijiUListi)*/
nadjiFiguruNaDatojPoziciji(T,RED,KOLONA,F):-
    NOVIRED is 8-RED+1,
    nadjiElemenatNaPozicijiUListi(T,L,1,NOVIRED),
    nadjiElemenatNaPozicijiUListi(L,F,1,KOLONA).
nadjiElemenatNaPozicijiUListi([G|_],G,TRAZENAPOZICIJA,TRAZENAPOZICIJA):-!.
nadjiElemenatNaPozicijiUListi([_|R],X,TRENUTNAPOZICIJA,TRAZENAPOZICIJA):-
    TRENUTNAPOZICIJA1 is TRENUTNAPOZICIJA+1,nadjiElemenatNaPozicijiUListi(R,X,TRENUTNAPOZICIJA1,TRAZENAPOZICIJA).
%pocetno polje ima datu figuru
pocetnoPoljeImaDatuFiguru(T,F,RED,KOLONA):-nadjiFiguruNaDatojPoziciji(T,RED,KOLONA,F).
%krajnje polje nema figuru iste boje
krajnjePoljeNemaFiguruIsteBoje(T,F,RED,KOLONA):-boja(F,X),nadjiFiguruNaDatojPoziciji(T,RED,KOLONA,F1),boja(F1,Y),X=\=Y.
%boja- 0 za prazno polje, 1 za bele figure i 2 za crne figure
boja('O',0).
boja('q',1).
boja('k',1).
boja('b',1).
boja('r',1).
boja('n',1).
boja('p',1).
boja('Q',2).
boja('K',2).
boja('B',2).
boja('R',2).
boja('N',2).
boja('P',2).
/*poljaNaPutuSuPrazna:
 1)za konja uvek vazi
 2)za pesaka isto uvek vazi, osim kad igra prvi potez za dva polja, pa proveravamo polje izmedju
 3)za topa, lovca i kraljicu:
 	a)nadjemo DX i DY, koji su nam pravci krtanja
    b)krecemo od polja odmah posle pocetnog i u svakom koraku ga menjamo za DX i DY dok ne dodjemo do krajnjeg polja
    c)za svako polje na putu, ako nije prazno vraca false, a ako su sva prazna vraca true*/
poljaNaPutuSuPrazna(_, _, _, _, _, X):- (   ==(X,'n');==(X,'N')),!.
poljaNaPutuSuPrazna(T, ROWSTART, COLSTART, ROWEND, COLEND, X):- ( ==(X,'b');==(X,'B') ;  ==(X,'r');==(X,'R') ;  ==(X,'q');==(X,'Q')),
	    DX is sign(ROWEND - ROWSTART), DY is sign(COLEND - COLSTART), ROWST is ROWSTART+DX,COLST is COLSTART+DY,
    	protrciKrozPut(T,ROWST,COLST, ROWEND, COLEND, DX, DY).

poljaNaPutuSuPrazna(T, 7, COL, 5, COL, 'P'):- nadjiFiguruNaDatojPoziciji(T,6,COL,'O'), !.
poljaNaPutuSuPrazna(T, 2, COL, 4, COL, 'p'):- nadjiFiguruNaDatojPoziciji(T,3,COL,'O'), !.
poljaNaPutuSuPrazna(_, RED1, _, RED2, _, X):- abs(RED2-RED1) =:= 1,( ==(X,'p');==(X,'P')).

protrciKrozPut(_,X,Y,X,Y,_,_):-!.
protrciKrozPut(T,ROWCURR,COLCURR,ROWEND,COLEND,DX,DY):-
    nadjiFiguruNaDatojPoziciji(T,ROWCURR,COLCURR,'O'),
    ROWNEW is ROWCURR + DX, COLNEW is COLCURR + DY,
    protrciKrozPut(T,ROWNEW, COLNEW, ROWEND, COLEND, DX, DY).

/*daLiJeUPotezu- proverava da li se neki elemenat nalazi u listi
 * lista za koju proveravamo je lista koju smo dobili brisanjem pocetnog, krajnjeg polja i figure iz poteza(lista ogranicenja)
 * u listi se mogu nalaziti
 *  x-jedenje
 *  +-sah
 *  #-mat(nije jos implementiran)
 * (=,tj. promocija se ne pojavljuje, jer koristimo auto-queen(tj. pesaka pretvaramo u kraljicu ukoliko dodje do kraja table)
 * */

daLiJeUPotezu(C, [C|_]):-!.
daLiJeUPotezu(C, [_|R]):-daLiJeUPotezu(C, R).

/*1)ako se u potezu pojavljuje x, na krajnjem polju mora biti figura suprotne boje
 * kako je boja belih figura 1, a crnih 2, dooljno je proveriti da je zbir boja figure kojom igramo i figure na krajnjem polju 3
 * 2)ako se u potezu ne pojavljuje x, krajnje polje mora biti slobodno(ne moze biti figura iste boje nikad, a posto nema x u listi, ne moze biti ni suprotne boje)
 * */
daLiJede(T, F, ROWEND, COLEND, S):- daLiJeUPotezu('x', S), 
    nadjiFiguruNaDatojPoziciji(T, ROWEND, COLEND, F2), boja(F, X), boja(F2, Y), Z is X+Y, Z =:= 3.
daLiJede(T, _, ROWEND, COLEND, S):- not(daLiJeUPotezu('x', S)), nadjiFiguruNaDatojPoziciji(T, ROWEND, COLEND, 'O').

/*proveri daLiJeSah-pozivamo nakon igranja poteza
 * 1)ako je u listi ogranicenja + ,protivnicki kralj mora biti napadnut
 * 2)ako u listi ogranicenja nije +, protivnicki kralj ne sme biti napadnut
 * */
proveriDaLiJeSah(T, LISTAOGRANICENJA, P):- (   daLiJeUPotezu('+', LISTAOGRANICENJA);daLiJeUPotezu('#', LISTAOGRANICENJA)),kraljJeNapadnut(T,P).
proveriDaLiJeSah(T, LISTAOGRANICENJA, P):-not(daLiJeUPotezu('+', LISTAOGRANICENJA)),not(daLiJeUPotezu('#', LISTAOGRANICENJA)),not(kraljJeNapadnut(T,P)).
/*kraljJeNapadnut-
 * 1)ako je potez paran beli igra, pa je boja napadaca 1 i protivnicki kralj je 'K'
 * 2)ako je potez neparan crni igra, pa je boja napadaca 2 i protivnicki kralj je 'k'*/
kraljJeNapadnut(T,P):-P mod 2=:=0,proveriDaLiJeNapadnut('K',1,T).
kraljJeNapadnut(T,P):-P mod 2=:=1,proveriDaLiJeNapadnut('k',2,T).
/*proveriDaLiJeNapadnut-proverava da li je kralj napadnut od strane protivnickih figura
 * 1)prvo nalazi kraljevo mesto u tabli
 * 2)za dato mesto proverava da li postoji figura suprotne boje koja moze da dodje na to polje u sledecem potezu
 * */
proveriDaLiJeNapadnut(F,BOJANAPADACA,T):-
    nadjiMestoGdeJeFigura(F,T,ROW,COL),proveriDaLiJeNapadnut(T,ROW,COL,BOJANAPADACA).%itd
/*nadjiMestoGdeJeFigura-nalazi mesto figure F u trenutnoj tabli(ako ih ima vise vraca samo prvo ponavljanje
 * (namenjeno da se koristi samo za kralja, gde moze biti samo jedno ponavljlanje)
 * prolazi red po red i kroz svaki red polje po polje,sve dok se ne nadje data figura
 * (figura bi trebala uvek da bude nadjena u slucaju kralja, za ostale figure se moze desiti beskonacna petlja, ako se data figura ne nadje)
 * */
nadjiMestoGdeJeFigura(F,T,ROW,COL):-
    nadjiMestoUTabli(F,T,8,1,ROW,COL).
nadjiMestoUTabli(F,[G|_],TRENUTNIRED,1,TRENUTNIRED,TRAZENAKOLONA):-
    nadjiMestoURedu(F,G,1,TRAZENAKOLONA),!.
nadjiMestoUTabli(F,[_|R],TRENUTNIRED,1,TRAZENIRED,TRAZENAKOLONA):-
    NOVIRED is TRENUTNIRED-1,nadjiMestoUTabli(F,R,NOVIRED,1,TRAZENIRED,TRAZENAKOLONA).
nadjiMestoURedu(F,[F|_],TRENUTNAKOLONA,TRENUTNAKOLONA):-!.
nadjiMestoURedu(F,[_|R],TRENUTNAKOLONA,TRAZENAKOLONA):-
    NOVAKOLONA is TRENUTNAKOLONA+1,
    nadjiMestoURedu(F,R,NOVAKOLONA,TRAZENAKOLONA).
/*nadjiDaLiJeNapadnut- prolazi kroz celu tablu i kada dodje do nekog polja proverava:
 * 1)da li je boja figure na tom polju suprotna boji figure koja se napada
 * 2)da li figura moze da dodje sa tog polja do kralja(okPotez)
 * 3)proverava da li su polja na putu prazna
 * kralj je napadnut akko za bilo koje polje vaze ovi uslovi
 * */
proveriDaLiJeNapadnut(T,ROW,COL,BOJANAPADACA):-
    nadjiDaLiJeNapadnut(T,8,ROW,COL,BOJANAPADACA,T).
nadjiDaLiJeNapadnut([G|_], TRENUTNIRED, ROW, COL, BOJANAPADACA, T):-
    nadjiDaLiJeNapadnutURedu(T, G, TRENUTNIRED, 1, ROW, COL, BOJANAPADACA)/*,format("jeste u redu~a~n",TRENUTNIRED)*/,!.
nadjiDaLiJeNapadnut([_|R], TRENUTNIRED, ROW, COL, BOJANAPADACA, T):-
    NOVIRED is TRENUTNIRED - 1, nadjiDaLiJeNapadnut(R, NOVIRED,ROW,COL,BOJANAPADACA, T).
nadjiDaLiJeNapadnutURedu(T,[F|_], TRENUTNIRED, TRENUTNAKOLONA, ROW, COL, BOJANAPADACA):-
    boja(F, BOJANAPADACA),
    okPotez(F,TRENUTNIRED,TRENUTNAKOLONA,ROW,COL,T),
    poljaNaPutuSuPrazna(T, TRENUTNIRED, TRENUTNAKOLONA, ROW, COL, F)/*,format("jeste u koloni~a~n tabla~n",TRENUTNAKOLONA),ispisiTablu(T)*/,!.
nadjiDaLiJeNapadnutURedu(T,[_|R],TRENUTNIRED,TRENUTNAKOLONA,ROW,COL,BOJANAPADACA):-
    NOVAKOLONA is TRENUTNAKOLONA+1,nadjiDaLiJeNapadnutURedu(T,R,TRENUTNIRED,NOVAKOLONA,ROW,COL,BOJANAPADACA).
%postaviFiguruNaMesto-postavlja figuru F na polje (TRAZENIRED,TRAZENAKOLONA) u tabli TSTARA i vraca tablu TNOVA
postaviFiguruNaMesto(TSTARA,TNOVA,F,TRAZENIRED,TRAZENAKOLONA):-
    postaviFiguru(TSTARA,TNOVA,F,TRAZENIRED,TRAZENAKOLONA,8).
%izmeniTabluAkoJePromocija-postavlja damu na polje gde bi pesak dosao u slucaju promocije,inace ostavlja startu tablu
izmeniTabluAkoJePromocija(TSTARA,TNOVA,'p',8,COLEND):-
    postaviFiguruNaMesto(TSTARA,TNOVA,'q',8,COLEND), !.
izmeniTabluAkoJePromocija(TSTARA,TNOVA,'P',1,COLEND):-
    postaviFiguruNaMesto(TSTARA,TNOVA,'Q',1,COLEND), !.
izmeniTabluAkoJePromocija(TSTARA,TSTARA,_,_,_):-!.
%postaviFiguru-prolazi kroz tablu i upisuje figuru F na polje (TRAZENIRED, TRAZENAKOLONA)
postaviFiguru([G|R], [G1|R], F, TRAZENIRED, TRAZENAKOLONA, TRAZENIRED):-
    postaviFiguruURed(G, G1, F, TRAZENAKOLONA, 1),!.
postaviFiguru([G|R], [G|R1], F, TRAZENIRED, TRAZENAKOLONA, TRENUTNIRED):-
    NOVIRED is TRENUTNIRED-1, postaviFiguru(R,R1,F,TRAZENIRED,TRAZENAKOLONA,NOVIRED).
%postaviFiguruURed-prolazi kroz trazeni red i upisuje F na polje trazene kolone i vraca izmenjen red 
postaviFiguruURed([_|R],[F|R], F, TRAZENAKOLONA,TRAZENAKOLONA ):-!.
postaviFiguruURed([G|R],[G|R1],F,TRAZENAKOLONA,TRENUTNAKOLONA):-
    NOVAKOLONA is TRENUTNAKOLONA+1,postaviFiguruURed(R,R1,F,TRAZENAKOLONA,NOVAKOLONA).


/*uslovi za mat:
 * 1)kralj je napadnut
 * 2)ne postoji koji protivnik moze da odigra, a da mu kralj ne bude napdnut
 * */
proveriDaLiJeMat(T,LISTAOGRANICENJA,P):- daLiJeUPotezu('#', LISTAOGRANICENJA),proveriUsloveZaMat(T,P).
proveriDaLiJeMat(T,LISTAOGRANICENJA,P):-not(daLiJeUPotezu('#', LISTAOGRANICENJA)),not(proveriUsloveZaMat(T,P)).
proveriUsloveZaMat(T,P):-kraljJeNapadnut(T,P),nePostojiPotez(T,P).
%ako je beli igrao, crni treba da se pomeri i obrnuto
nePostojiPotez(T,P):-P mod 2=:=0,not(postojiPotez(T,2,P)).
nePostojiPotez(T,P):-P mod 2=:=1,not(postojiPotez(T,1,P)).
/*postojiPotez-prolazimo kroz sve moguce parove pocetnog i krajnjeg polja i za svako proveravamo:
 * 1)da li je figura na pocetnom polju dobre boje
 * 2)da li je ok potez figure od pocetnog do krajnjeg polja
 * 3)da li krajnje polje nema figuru iste boje
 * 4)da li su polja n putu prazna
 * ako ti uslovi vaze, pomeramo figuru sa pocetnog na krajnje polje i proveravamo da li je kralj napadnut
 * ako u bilo kom slucaju kralj nije napadnut potez nije mat, a inace jeste
 * */
postojiPotez(T,BOJA,P):-
    jePolje(ROWSTART,COLSTART),jePolje(ROWEND,COLEND),
    nadjiFiguruNaDatojPoziciji(T,ROWSTART,COLSTART,F),
    boja(F,BOJA),
    okPotez(F,ROWSTART,COLSTART,ROWEND,COLEND,T),
    krajnjePoljeNemaFiguruIsteBoje(T,F,ROWEND,COLEND),
    poljaNaPutuSuPrazna(T,ROWSTART,COLSTART,ROWEND,COLEND,F),
    pomeriSaPocetnogNaKrajnjePolje(T,TNOVA,F,ROWSTART,COLSTART,ROWEND,COLEND),
    not(kraljJeNapadnut(TNOVA,P)),!.
jePolje(X,Y):-
    okKoordinata(X),okKoordinata(Y).
okKoordinata(1).
okKoordinata(2).
okKoordinata(3).
okKoordinata(4).
okKoordinata(5).
okKoordinata(6).
okKoordinata(7).
okKoordinata(8).


