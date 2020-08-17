module exc_5_ii (A,B,C,D,E,F1,F2,F3,F4);
    output F1,F2,F3,F4;
    input A,B,C,D,E;
    
/* ---------F1-------*/
//F1=A(CD + B) + BC'D'
    assign F1= (A&((C&D)|B))|(B&~C&~D);
/*-------END OF F1-------*/

/*----------F2-----------*/
//F2=B'D' + A'BD + AC + B'C
    assign F2= (~B&~D)|(~A&B&D)|(A&C)|(~B&C);
/*-------END OF F2-------*/

/* ---------F3-------*/
//F3=ABC + (A + B)CD +(B+ CD)E
    assign F3= (A&B&C)|((A|B)&C&D)|((B|(C&D))&E);
/*-------END OF F3-------*/

/* ---------F4-------*/
//F4=A(BC + D + E) + CDE
    assign F4= (A&((B&C)|D|E))|(C&D&E);
/*-------END OF F4-------*/

endmodule