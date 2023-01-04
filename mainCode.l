%{
	#include <string.h>
	#include<stdio.h>
	#include "mainCode.tab.h"
	int yyparse();
	
	#undef yywrap
	#define yywrap() 1

%}

variable [_]*[a-zA-Z]+[0-9a-zA-Z_]*
digit [0-9]+

%%
"#"										{	
											char c = input();
											while( c!='\n' && c!=EOF){
												c = input();
											}
											printf("This is a single line comment\n");
											return COMMENT;
										}

['#']['#']								{
											printf("This is for Multiple line comment start\n");
											char demo = input();
											while (1){
												while (demo!='#' && demo!=EOF) demo = input();
												demo = input();
												if (demo=='#') break;
											}
											printf("Multiple Line comment End here\n");
											return COMMENT;
										}

"define"								{return DEFINE;}
"call"									{return CALL;}
"again"									{return FOR;}
"in"									{return IN;}
"scope"									{return SCOPE;}
"check"									{return IF;}
"check_again"							{return ELIF;}
"last"									{return ELSE;}
"input"									{return INPUT;}
"show"									{return SHOW;}
"INT"									{return INT_ARRAY;}
"DOUBLE"								{return DOUBLE_ARRAY;}
"STRING"								{return STRING_ARRAY;}
"VOID"									{return VOID;}
"append"								{return APPEND;}
"duration"								{return WHILE;}
"sequential_check"						{return SWITCH;}
"check_if"								{return CASE;}
"finally"								{return DEFAULT;}
"pop_back"								{return POP;}
"sort"									{return SORT;}

"=>"									{return ARROW;}

"++"									{return DOUBLEPLUS;}
"--"									{return DOUBLEMINUS;}
"=="									{return EQL;}
"!="									{return NOTEQL;}	
"<="									{return LESSEQL;}
">="									{return GREATEREQL;}

"and"									{return AND;}
"or"									{return OR;}
"!"										{return NOT;}	

"^"										{return MXOR;}
"&"										{return MAND;}
"|"										{return MOR;}
"~"										{return MNOT;}
"math_sin"								{return SIN;}
"math_cos"								{return COS;}
"math_tan"								{return TAN;}
"SQRT"									{return SQRT;}
"log"									{return LOG;}
"log2"									{return LOG2;}



['\n']									{}




{digit}									{yylval.integer = atoi(yytext); return INTEGER;}
[0-9]*[.][0-9]+([eE][+-]?[0-9]+)?		{yylval.real = atof(yytext);return REAL;}
{variable}								{yylval.string = strdup(yytext);return VARIABLE;}


\"(\\.|[^"\\])*\"						{
											char* tmp = strdup(yytext);
											int n = strlen(tmp);
											yylval.string = malloc(n*sizeof(char));
											memcpy(yylval.string,&tmp[1],n-2);
												yylval.string[n-2]='\0';
											return STRING;
										}



[-+/*<>=,%:().{}\]\[] 					{return yytext[0];}
[' ']								 	{}
. {
	printf("Error occour %s\n",yytext);
}
%%

int yyerror(char *s){
	fprintf(stderr,"error: %s\n", s);
}

