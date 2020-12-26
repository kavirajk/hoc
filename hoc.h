typedef struct Symbol {		/* symbol table entry  */
  char *name;
  short type;			/* VAR, BLTIN, UNDEF */
  union {
    double val;			/* If VAR */
    double (*ptr)();		/* if BTLIN */
  } u;
  struct Symbol *next;		/* linked list */
} Symbol;

Symbol *install();
Symbol *lookup();
