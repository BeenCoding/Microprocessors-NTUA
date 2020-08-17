module exc_5_i (A,B,C,D,E,F1,F2,F3,F4);

    output F1,F2,F3,F4;
    input A,B,C,D,E;
    wire a,b,c,d;        //global wires NOT A,NOT B,NOT C, NOT D
    not (a,A);
    not (b,B);
    not (c,C);
    not (d,D);
/* ----------F1---------- */
//F1=A(CD + B) + BC'D'
    wire w1,w2,w3,w4;
    and (w1,C,D);  //CD
    or (w2,w1,B);  //B+CD
    and (w3,A,w2); // A(B+CD)
    and (w4,B,c,d); //BC'D'
    or (F1,w4,w3);
/*-------END OF F1-------*/

/*----------F2-----------*/
    //F2=B'D' + A'BD + AC + B'C
    wire w5,w6,w7,w8;
    and (w5,b,d);   //B'D'
    and (w6,a,B,D); //A'BD
    and (w7,A,C);   // AC
    and (w8,b,C);   // B'C
    or (F2,w5,w6,w7,w8);
/*-------END OF F2-------*/

/* ----------F3---------- */
//F3=ABC + (A + B)CD +(B+ CD)E
    wire w9,w10,w11,w12,w13,w14;
    and (w9,A,B,C);  //ABC
    and (w10,C,D);  // CD
    or (w11,A,B); // A+B
    and(w12,w11,w10); //(A+B)CD
    or (w13,w10,B);     //CD+B
    and (w14,E,w13);    //(CD+B)E
    or (F3,w14,w12,w9);
/*-------END OF F3-------*/

/* ----------F4---------- */
//F4=A(BC + D + E) + CDE
    wire w15,w16,w17,w18;
    and (w15,w10,E); //CDE where w10==CD(look F3) 
    and (w16,B,C); //BC
    or (w17,w16,D,E); // BC+D+E
    and (w18,w17,A); //A(BC+D+E)
    or (F4,w18,w15); 
/*-------END OF F4-------*/



endmodule