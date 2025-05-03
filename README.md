# C-like Language Compiler Project

## Overview

This project implements a simple compiler front-end for a C-like programming language using Flex (lex) for lexical analysis and Bison (yacc) for parsing. It supports variable declarations, assignments, conditional statements (`if`, `else`), `switch-case` constructs, and `return` statements. The compiler builds an Abstract Syntax Tree (AST) and manages a symbol table with scope handling.

## Features

- **Lexical Analysis**: Tokenizes keywords, identifiers, numbers, operators, and delimiters using Flex.
- **Parsing**: Recognizes C-like grammar including functions, compound statements, conditionals, switch-case, and assignments using Bison.
- **Symbol Table**: Tracks variable names, types, scopes, and values.
- **AST Construction**: Builds and prints a hierarchical AST for parsed programs.
- **Scope Management**: Handles nested scopes for variables and blocks.
- **Error Handling**: Detects redeclarations, undefined variables, and improper usage.

## File Structure

- `lex.l`: Flex lexer definition for tokenizing input.
- `parser.y`: Bison parser definition, symbol table, AST logic, and main function.
- `test.c`: Example C-like program to test the compiler.
- `parser.tab.c`, `parser.tab.h`, `lex.yy.c`: Auto-generated files from Bison and Flex.

## How It Works

1. **Lexical Analysis**: `lex.l` defines rules for recognizing keywords (`int`, `void`, `if`, `else`, `switch`, `case`, `default`, `break`, `return`), identifiers, numbers, and operators. Each token is printed for debugging.
2. **Parsing**: `parser.y` defines grammar rules for function definitions, statements, conditionals, switch-case, declarations, and assignments. It constructs an AST and manages a symbol table.
3. **Symbol Table**: Implemented as a linked list, storing variable name, type, scope, value, and data type string. Handles redeclaration and scope lookup.
4. **AST**: Each grammar rule creates AST nodes. The tree is printed after parsing for visualization.
5. **Scope**: `current_scope` variable tracks nesting. Entering `{` increases scope, exiting `}` decreases it.
6. **Error Handling**: Prints errors for redeclared or undefined variables.

## Example Input (`test.c`)

```cint main(){
    int x;
    x = 1;
    int y;
    y = 2;
    if (x == 1) {
        int x;
        x = 10;
        int z;
        z = 100;
        y = 20;
    }
    else {
        int y;
        y = 30;
        x = 3;
    }
    switch (x) {
        case 3:
            int y;
            y = 300;
            x = 33;
            break;
        case 1:
            y = 111;
            break;
        default:
            x = 0;
            break;
    }
    int w;
    w = 999;
    return 0;
}
```

## How to Build and Run

1. **Generate Parser and Lexer:**
   ```sh
   bison -d parser.y
   flex lex.l
   gcc parser.tab.c lex.yy.c -o parser -lfl
   ```
2. **Run the Compiler:**
   ```sh
   ./parser
   ```
   The program will read `test.c`, parse it, print the AST, and display the symbol table.

## Output

- **Token Stream:** Printed by the lexer for each recognized token.
- **AST:** Printed in a hierarchical format after parsing.
- **Symbol Table:** Printed after parsing, showing all variables, their scopes, types, and values.
- **Error Messages:** Printed for redeclaration or undefined variable usage.

## Implementation Details

- **lex.l**: Contains rules for all keywords, identifiers, numbers, operators, and whitespace. Ensures keywords like `return` are matched before identifiers.
- **parser.y**: Contains grammar rules, AST and symbol table logic, and error handling. Manages scope and variable tracking.
- **test.c**: Demonstrates all supported language features, including nested scopes, conditionals, switch-case, and return.

## Extending the Project

- Add more data types (e.g., `float`, `char`).
- Support for expressions and arithmetic operations.
- Implement code generation or interpretation.
- Add more complex error handling and reporting.

## Authors

- Siddhant Gaikwad

## License

This project is for educational purposes.
