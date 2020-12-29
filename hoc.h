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

typedef union Datum {		/* interpreter stack type */
  double val;
  Symbol *sym;
} Datum;

extern Datum pop();

typedef void (*Inst)();		/* machine instruction */
#define STOP (Inst) 0

extern Inst prog[];
extern void eval(), add(), sub(), mul(), divide(), negate(), power();
extern void assign(), bltin(), varpush(), constpush(), print();
