%{ 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
FILE *file_pointer;
char name[21];
short line=1;
char decl[21];
char funct[21];
int c=0;
int e=0;
struct Node{
	char caller[21];
	char callee[21];
	short count;
	short line[500];
	struct Node * next;
};
struct list{
	struct Node * head;
};
struct Node * createnode(char * er , char * ee){
	struct Node * newNode = malloc(sizeof(struct Node));
	if(!newNode) { return NULL; }
	strcpy(newNode->caller, er);
	if(ee != NULL)
	strcpy(newNode->callee, ee);
	newNode->line[0] = line;
	newNode->count = 1;
	newNode->next = NULL;
	return newNode;
}

struct list * makelist(){
	struct list * list = malloc(sizeof(struct list));
	if (!list){ return NULL; }
	list->head = NULL;
	return list;
}
struct list * func = NULL;

void add(char *er, char *ee, struct list * list){
	struct Node * current = NULL;
	if(list->head == NULL){
		list->head = createnode(er, ee);
	}
	else{
		current = list->head;
		while(current->next != NULL){
			current = current->next;
		}
		current->next = createnode(er, ee);
	}
}

struct Node * selection(char *s, struct list * list){
	struct Node * a = NULL;
	struct Node * b = NULL;
	if(list->head == NULL)  return a;
	a = list->head;
	if(!strcmp(a->caller, s)){
		list->head = a->next;
		return a;
	}
	else{
		b = list->head;
		a = a->next;
	}
	while(a != NULL){
		if(!strcmp(a->caller, s)) {
			b->next = a->next;
			return a;
		}
		b = a;
		a = a->next;
	}
	return a;
}
void equalsearch(struct list * list){
	struct Node * j = NULL;
        struct Node * b = NULL;
	struct Node * i = NULL;
	if(list->head == NULL) return;
        i = list->head;
	while(i != NULL){
		b = i;
		j = b->next;
		if(j==NULL) break;
		while(!strcmp(i->caller, j->caller)){	
			if(!strcmp(i->callee, j->callee)){
				i->count++;
				i->line[i->count - 1] = j->line[0];
				b->next = j->next;
				j = b->next;
				if(j == NULL) break;
				
			}
			else{
				if(j->next == NULL) break;
				b = j;
				j = j->next;
				
			}	
		}
		i = i->next;
	}	
	
}

int yylex();
%}
%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token BOOL COMPLEX IMAGINARY
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit
%%

primary_expression 
	: IDENTIFIER	{
					if(e==0)strcpy(funct, name); e=1;
			}
	| CONSTANT
	| STRING_LITERAL
	| '(' expression ')'
	;

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'				{add(decl, funct, func); e=0;}
	| postfix_expression '(' argument_expression_list ')'	{add(decl, funct, func); e=0;}
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER 
	| postfix_expression INC_OP 
	| postfix_expression DEC_OP 
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression 
	| DEC_OP unary_expression 
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression 
	| multiplicative_expression '/' cast_expression 
	| multiplicative_expression '%' cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression 
	| additive_expression '-' multiplicative_expression 
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression 
	| shift_expression RIGHT_OP additive_expression 
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression 
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression 
	| relational_expression GE_OP shift_expression 
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression 
	| equality_expression NE_OP relational_expression 
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression 
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression 
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression 
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression 
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression 
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression 
	;

assignment_operator
	: '=' {e=0;}
	| MUL_ASSIGN {e=0;}
	| DIV_ASSIGN {e=0;}
	| MOD_ASSIGN {e=0;}
	| ADD_ASSIGN {e=0;}
	| SUB_ASSIGN {e=0;}
	| LEFT_ASSIGN {e=0;}
	| RIGHT_ASSIGN {e=0;}
	| AND_ASSIGN {e=0;}
	| XOR_ASSIGN {e=0;}
	| OR_ASSIGN {e=0;}
	;

expression
	: assignment_expression {e=0;}
	| expression ',' assignment_expression {e=0;}
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';' 
	| declaration_specifiers init_declarator_list ';' 
	;

init_declarator
	: declarator 
	| declarator '=' initializer 
	;

declaration_specifiers
	: storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list
	: init_declarator 
	| init_declarator_list ',' init_declarator
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID 
	| CHAR 
	| SHORT 
	| INT 
	| LONG 
	| FLOAT
	| DOUBLE 
	| SIGNED 
	| UNSIGNED
	| BOOL 
	| COMPLEX 
	| IMAGINARY 
	| struct_or_union_specifier 
	| enum_specifier 
	| TYPE_NAME 
	;
struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator 
	| struct_declarator_list ',' struct_declarator 
	;

struct_declarator
	: declarator 
	| ':' constant_expression
	| declarator ':' constant_expression 
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

type_qualifier
	: CONST
	| RESTRICT
	| VOLATILE
	;
declarator
	: pointer direct_declarator
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER {
		if(c==0) strcpy(decl, name);
		c = 1;
	}
	| '(' declarator ')'
	| direct_declarator '[' type_qualifier_list assignment_expression ']' 
	| direct_declarator '[' type_qualifier_list ']' 	
	| direct_declarator '[' assignment_expression ']' 	
	| direct_declarator '[' type_qualifier_list '*' ']' 	
	| direct_declarator '[' ']' 				
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')' 			
	;

pointer
	: '*' 
	| '*' type_qualifier_list 
	| '*' pointer 
	| '*' type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;

parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator 
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list 
	| specifier_qualifier_list abstract_declarator 
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' assignment_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' assignment_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| designation initializer
	| initializer_list ',' initializer
	| initializer_list ',' designation initializer
	;

designation
	: designator_list '=' 
	;

designator_list
	: designator
	| designator_list designator
	;

designator
	: '[' constant_expression ']'
	| '.' IDENTIFIER
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement 
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{' block_item_list '}'
	;

block_item_list
	: block_item
	| block_item_list block_item
	;

block_item
	: declaration
	| statement
	;

expression_statement
	: ';'
	| expression ';' 
	;

selection_statement
	: IF '(' expression ')' statement 
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement 
	| DO statement WHILE '(' expression ')' ';' 
	| FOR '(' expression_statement expression_statement ')' statement 
	| FOR '(' expression_statement expression_statement expression ')' statement 
	| FOR '(' declaration expression_statement ')' statement
	| FOR '(' declaration expression_statement expression ')' statement
	;
jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';' 
	| RETURN expression ';'
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition {c=0;}
	| declaration {c=0;}
	| include
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	| declarator declaration_list compound_statement
	| declarator compound_statement
	;

declaration_list
	: declaration
	| declaration_list declaration
	;
include 
	: '#' IDENTIFIER
	| '#' IDENTIFIER '<' IDENTIFIER '>'
	| '#' IDENTIFIER '<' IDENTIFIER '.' IDENTIFIER '>'
	;
%%

void yyerror(const char *str)
{
	fprintf(stderr, "error : %s\n", str);
}

void printNode(struct Node * a, int space){
	if(a == NULL) return;
	struct Node * b;
	char second[21];
	int i = 0;
	int j=1;
	fprintf(file_pointer,"    %s -> %s[label= \" %d times ", a->caller, a->callee, a->count);
        if(a->count > 1) {for(i; i<a->count - 1; i++) fprintf(file_pointer,"%d,", a->line[i]); }
        fprintf(file_pointer,"%d\"]\n", a->line[i]);
	strcpy(second, a->callee);
	free(a);
	while(b = selection(second, func)){
		printNode(b, space);
	}
}
int main(void){
	file_pointer=fopen("B511074.dot", "w");
	
	struct Node * a;
	func = makelist();

	yyparse();

	equalsearch(func);
	fprintf(file_pointer,"digraph B511074 {\nnode[shape = ellipse]\n");
	
	while(a = selection("main", func)){
		int space =0;
		printNode(a, space);
	}
	fprintf(file_pointer,"}\n");
	fclose(file_pointer);
	system("dot -Tjpg B511074.dot -o B511074.jpg");
	return 0;
}
