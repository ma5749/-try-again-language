/* try again language */

%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<math.h>
    #include<string.h>
    #include "main.tab.h"     /*header for token defination*/    
    extern YYSTYPE yylval;
    int line_number = 1;
    
%}

/* Token Definations */
header  "import ".*


/*REGULAR EXPRESSIONS defining the tokens for the R language */

%%
"int"           {return INT;}      // When the lexer enters the string int as input, it returns the token type INT (match textfile vs reg)
"float"         {return FLOAT;}
"char"          {return CHAR;}
[0-9]+  {                   // allow one or more digites 
        yylval = atoi(yytext);  // convert into string (atoi) //match it in f‎ile yytext  // store it into yylval
        return NUM;     //Return the token type declared in the .y file.
        }
[a-zA-Z]   {               // allow one or more alpha
        yylval = *yytext - 'a';   //every char - from ascll for a //store in yylval   // to every char has uniqe value
        return VAR;              // Return the token type declared in the .y file
        }
[-+/*<>=,():;%^!]    {
                    yylval = yytext[0];	
                    return  *yytext;	
                    }
"ADD" { return ADD; }
"IF"    {return IF;}
"ELSE"  {return ELSE;}
"switch"   { return SWITCH; }

"fact"                { return FACT;}
"sin"                 { return SIN;}
"cos"                 { return COS;}
"tan"                 { return TAN;}
"ln"                  { return LN;}
"DEFAULT"      {return DEFAULT;}
"{"             {return LB;}
"}"             {return RB;}
"print"         {return PRINT;}
"BREAK"         {return BREAK;}
"FOR"           {return FOR;}
"WHILE"         {return WHILE;}


[#].*   {
        printf(" ##### ");ECHO;printf("Comment line \n");
        }
{header}    {
            printf("\nHeader file found :\n");ECHO;printf("\n");
            }
"root"      {return ROOT;}
[\n]*   {}
[\t]*       {}
[ ]*	    {}
.       { printf("Unknown Character '%s' at line %d.\n", yytext, line_number); }

%%

int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();
    
	return 0;
}