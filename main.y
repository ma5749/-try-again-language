/* try again language */

%{
    
    int data[100];     //array store value that retuen from tokens
#define PI 3.14159265
#include <math.h>
#include<stdio.h>
int sym[50];
int r;
int store[5];    
int fact(int n)
{
int i,sum=1;
for(i=1;i<=n;i++)
{ 
	sum=sum*i;
}
return sum;
}

%}

/* bison declarations */

%token ROOT INT FLOAT CHAR NUM VAR IF ELSE SWITCH CASE  LB RB PRINT BREAK FOR WHILE SIN COS TAN LN FACT ADD
%nonassoc IFX
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left '>' '<'       //precedence
%left '+' '-'
%left '/' '*'     //start from here
%left '='
%right FACT
%left '^'
/*bison grammers */
%%

program: ROOT ':' LB statements RB  {printf("Main Function Ends\n");}
        ;

statements: /*NULL*/           //statement empty
        |statements statement     //statement anthor statement
        ;                       //empty

statement: ';'
        | declaration ';'       {printf("Decleration\n");}       //represent declaration
        | expression ';'        {printf("The value is: %d\n",$1); $$=$1;         // $$=result    //$1=expression                                        
                        }
        | VAR '=' expression ';'        {
                                        data[$1] = $3;   //array ($1) name var   $3=vlaue
					printf("The Value is: %d\t\n",$3);
					$$=$3;   //to assgin
                                        }
        | ADD '(' expression ',' expression ')' {
        printf("\nAdd Function: %d + %d = %d\n", $3, $5, $3 + $5);
        $$ = $3 + $5;
        }
        | NUM '+''+'';'         {
                                printf("\nnum before Increment : %d",$1 );
                                printf("\nnum after Increment : %d\n",$1+1 );
                                $$=$1+1;
                        }
           | VAR '+''+'';'         {
                                printf("\nbefore Increment : %d",data[$1]  );
                                printf("\nafter Increment : %d\n",data[$1] =+1 );
                                $$=data[$1]+1;
                        }                
        | PRINT '(' expression ')' ';' {
            printf("Printed Value: %d\n", $3);
        }
        | PRINT '(' VAR ')' ';' {
            printf("Printed Value: %d\n", data[$3]);
        }               
        | NUM '-''-'';'         {
                                printf("\nnum before Decrement : %d",$1 );
                                printf("\nnum after Decrement : %d\n\n",$1-1 );
                                $$=$1-1;
                        }
        | VAR '-''-'';'         {
                                printf("\nbefore Decrement : %d",$1 );
                                printf("\nafter Decrement : %d\n\n",data[$1] -1 );
                                $$=data[$1]-1;
                        }  
        | FOR '(' NUM '<' NUM ')' LB statement RB       {                //this rule represents the syntax for a FOR loop
                                                        int i;
                                                        printf("\nFOR Loop\n");
	                                                for(i=$3 ; i<$5 ; i++) {printf("%dth Loop's expression value: %d\n", i,$8);}
                                                        }
        | WHILE '(' NUM '<' NUM ')' LB statement RB {
	                                                int i;
	                                                printf("\nWHILE Loop\n");
	                                                for(i=$3 ; i<$5 ; i++) 
                                                        {
                                                                printf("%dth Loop's expression value: %d\n", i,$8);
                                                        }
	                                               									
				        }

        | SWITCH '(' VAR ')' LB CS RB           
        | IF '(' expression ')' LB expression ';' RB %prec IFX {
								if($3){
									printf("\nThe value in IF: %d\n",$6);
								}
								else{
									printf("condition value zero in IF block\n");
								}
							}
        | IF '(' expression ')' LB expression ';' RB ELSE LB expression ';' RB {
                                                                                if($3){
									        printf("The value in IF: %d\n",$6);
								                }
								                else{
									        printf("The value in ELSE: %d\n\n",$11);
								                }
                                                                        }


        ; 

CS: C
        | C D
        ;
C: C '+' C 
        | CASE NUM ':' expression ';' BREAK ';'         {}
        ;
D: DEFAULT ':' expression ';' BREAK ';'           {}
        ;

declaration: TYPE ID1     //declaration variable
        ;
TYPE: INT
        |FLOAT
        |CHAR
        ;
ID1: ID1 ',' VAR     //This rule defines a list of identifiers (ID1). It can be a single variable (VAR) or a comma-separated list of variables.
        |VAR 
        ;
expression: NUM	{ printf("\nNumber :  %d\n",$1 ); $$ = $1;  }

	| VAR				{ $$ = data[$1]; }


	
	| expression '+' expression	{printf("\nAdd Two Numbers : %d+%d = %d \n",$1,$3,$1+$3 );  $$ = $1 + $3;}

	| expression '-' expression	{printf("\nSubtract Two Numbers : %d-%d=%d \n ",$1,$3,$1-$3); $$ = $1 - $3; }

	| expression '*' expression	{printf("\nMulti of Two Numbers : %d*%d \n ",$1,$3,$1*$3); $$ = $1 * $3;}

	| expression '/' expression	{ if($3){
				     		printf("\nDivi :%d/%d \n ",$1,$3,$1/$3);
				     		$$ = $1 / $3;
				     					
				  	}
				  	else{
						$$ = 0;
						printf("\nDiv by zero\n\t");
				  	} 	
				}
                             
	
	| expression '<' expression	{printf("\nLess-Than :%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }
	
	| expression '>' expression	{printf("\nGreater-Than  :%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }
        | expression '=''=' expression  {
                                        
                                        printf("\nEqual : %d == %d\n",$1,$4);
                                        $$ = $1 == $4;                                        
                                }
        | expression '!''=' expression  {
                                        
                                        printf("\nInequal : %d == %d\n",$1,$4);
                                        $$ = $1 != $4;                                        
                                }

	
        | expression '^' expression	            { $$ = pow($1,$3); }                        
        | VAR '^' expression                        { $$ = pow(sym[$1],$3);}
        | FACT '(' expression ')'            {  $$ = fact($3); } 	
        | FACT '(' VAR ')'                   {  $$ = fact(sym[$3]);}

        | SIN '(' expression ')'             {  $$ = sin(($3*PI)/180); }  
        | SIN '(' VAR ')'                    {  $$ = sin((sym[$3]*PI)/180);}

        | COS '(' expression ')'             {  $$ = cos(($3*PI)/180); }  
        | COS '(' VAR ')'                    {  $$ = cos((sym[$3]*PI)/180);}

        | TAN '(' expression ')'             {  $$ = tan(($3*PI)/180); }  
        | TAN '(' VAR ')'                    {  $$ = tan((sym[$3]*PI)/180);}

        | LN '(' expression ')'              {  $$ = log($3); }  
        | LN '(' VAR ')'                     {  $$ = log(sym[$3]);}
        

	| '(' expression ')'		{$$ = $2; }                

	
        ;  
    
         	

%%

/*Additional C code*/

yyerror(char *s){    //called by yyparse on error
	printf( "%s\n", s);
}

