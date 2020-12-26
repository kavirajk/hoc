%{
#include<stdio.h>
void yyerror(char *);
int yylex();
double mem[26];			/* memory for variables 'a'..'z' */
%}
%union {
    double val;			/* actual value */
    int    index;		/* index into mem[] */
}
%token	<val>		NUMBER
%token	<index>		VAR
%token	<val>		 expr
%right			'='
%left			'+' '-'	/* left associative, same precedence */
%left			'*' '/'	/* left associative, higher precedence */
%left			UNARYMINUS
%%
list:
	| 	list '\n'
	| 	list expr '\n' { printf("\t%.8g\n", $2); }
		;

expr: 		NUMBER { $$ = $1; }
	|	VAR        { $$ = mem[$1]; }
	|	VAR '=' expr { $$ = mem[$1] = $3; }
	| 	expr '+' expr  { $$ = $1 + $3; }
	| 	expr '-' expr  { $$ = $1 - $3; }
	| 	expr '*' expr  { $$ = $1 * $3; }
	| 	expr '/' expr  { $$ = $1 / $3; }
	| '(' 	expr ')'   { $$ = $2; }
	|	'-' expr %prec UNARYMINUS { $$ = -$2; }

		;
%%
#include<stdio.h>
#include<ctype.h>
char *progname;
int lineno=1;
jum_buf begin;

int main(int argc, char *argv[]) {
    int fpecatch();
    progname = argv[0];
    setjmp(begin);
    signal(SIGFPE, fpecatch);
    yyparse();
    return 0;
}

execerror(char *s, char *t) {
    warning(s, t);
    longjmp(begin, 0);
}

fpecatch() {
    execerror("floating point exception", (char *)0);
}

int yylex() {
    int c;
    while((c=getchar()) == ' ' || c == '\t')
	;
    if (c == EOF)
	return 0;
    if (c == '.' || isdigit(c)) {
	ungetc(c, stdin);
	scanf("%lf", &yylval);
	return NUMBER;
    }
    if (islower(c)) {
	yylval.index = c - 'a';
	return VAR;
    }
    if (c=='\n')
	lineno++;

    return c;
}

void warning(char *s, char *t) {
    fprintf(stderr, "%s: %s", progname, s);
    if(t)
	fprintf(stderr, " %s", t);
    fprintf(stderr, " near line %d\n", lineno);
}

void yyerror(char* s) {
    warning(s, (char *) 0);
}
