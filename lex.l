%{
#include <stdio.h>
#include "y.tab.h"
extern char name[10];
extern short line;
%}

D	[0-9]
L	[a-zA-Z_]
A	[a-zA-Z_0-9]
H	[a-fA-F0-9]
E	([Ee][+-]?{D}+)
P       ([Pp][+-]?{D}+)
FS	(f|F|l|L)
IS      ((u|U)|(u|U)?(l|L|ll|LL)|(l|L|ll|LL)(u|U))	

%%

"int" {return INT;}
"char" {return CHAR;}
"void" {return VOID;}
"long" {return LONG;}
"float" {return FLOAT;}
"double" {return DOUBLE;}
"short" {return SHORT;}
"signed" {return SIGNED;}
"unsigned" {return UNSIGNED;}
"enum" {return ENUM;}
"auto"  {return AUTO;}
"extern" {return EXTERN;}
"typedef" {return TYPEDEF;}
"register" {return REGISTER;}
"sizeof" {return SIZEOF;}
"const" {return CONST;}
"volatile" {return VOLATILE;}
"return" {return RETURN;}
"default" {return DEFAULT;}
"continue" {return CONTINUE;}
"goto" {return GOTO;}
"break" {return BREAK;}
"case" {return CASE;}
"union" {return UNION;}
"struct" {return STRUCT;}
"if" {return IF;}
"switch" {return SWITCH;}
"while" {return WHILE;}
"do" {return DO;}
"for" {return FOR;}
"_Imaginary" {return IMAGINARY;}
"inline" {return INLINE;}
"static" {return STATIC;}
"_Complex" {return COMPLEX;}
"_Bool" {return BOOL;}
"restrict" {return RESTRICT;}

{L}({L}|{D})*	{ strcpy(name, yytext); return IDENTIFIER ;}

0[xX]{H}+{IS}?		{return CONSTANT;}
0[0-7]*{IS}?		{return CONSTANT;}
[1-9]{D}*{IS}?		{return CONSTANT;}
L?'(\\.|[^\\'\n])+'	{return CONSTANT;}
{D}+{E}{FS}?		{return CONSTANT;}
{D}*"."{D}+{E}?{FS}?	{return CONSTANT;}
{D}+"."{D}*{E}?{FS}?	{return CONSTANT;}
0[xX]{H}+{P}{FS}?	{return CONSTANT;}
0[xX]{H}*"."{H}+{P}?{FS}? {return CONSTANT;}
0[xX]{H}+"."{H}*{P}?{FS}? {return CONSTANT;}

L?\"(\\.|[^\\"\n])*\"	{return STRING_LITERAL;}

"..." {return ELLIPSIS;}
"*=" {return MUL_ASSIGN;}
"/=" {return DIV_ASSIGN;}
"%=" {return MOD_ASSIGN;}
"+=" {return ADD_ASSIGN;}
"-=" {return SUB_ASSIGN;}
"<<=" {return LEFT_ASSIGN;}
">>=" {return RIGHT_ASSIGN;}
"&=" {return AND_ASSIGN;}
"^=" {return XOR_ASSIGN;}
"|=" {return OR_ASSIGN;}
"||" {return OR_OP;}
"&&" {return AND_OP;}
"==" {return EQ_OP;}
"!=" {return NE_OP;}
"<=" {return LE_OP;}
">=" {return GE_OP;}
"<<" {return LEFT_OP;}
">>" {return RIGHT_OP;}
"->" {return PTR_OP;}
"++" {return INC_OP;}
"--" {return DEC_OP;}
"="	{return '=';}
";"	{return ';';}
","	{return ',';}
"*"	{return '*';}
"["	{return '[';}
"]"	{return ']';}
"?"	{return '?';}
":"	{return ':';}
"|"	{return '|';}
"^"	{return '^';}
"&"	{return '&';}
"<"	{return '<';}
">"	{return '>';}
"+"     {return '+';}
"-"     {return '-';}
"~"     {return '~';}
"/"     {return '/';}
"%"     {return '%';}
"!"     {return '!';}
"("     {return '(';}
")"     {return ')';}
"."	{return '.';}
("{"|"<%") {return '{';}
("}"|"%>") {return '}';}
"#"	{return '#';}
[\n] { line++; }
[\t\v\f]	{}
.	{}
%%

int yywrap()
{
	return 1;
}

void comment(void)
{
	char c, prev = 0;
  
	while ((c = input()) != 0)      /* (EOF maps to 0) */
	{
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
	error("unterminated comment");
}
