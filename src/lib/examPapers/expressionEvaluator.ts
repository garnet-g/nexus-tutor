type TokenType = "number" | "identifier" | "operator" | "lparen" | "rparen" | "comma";

interface Token {
  type: TokenType;
  value: string;
}

const OPERATORS = new Set(["+", "-", "*", "/", "^"]);

function tokenize(expr: string): Token[] {
  const tokens: Token[] = [];
  let i = 0;

  while (i < expr.length) {
    const ch = expr[i];

    if (/\s/.test(ch)) {
      i += 1;
      continue;
    }
    if (/[0-9.]/.test(ch)) {
      let j = i + 1;
      while (j < expr.length && /[0-9.]/.test(expr[j])) j += 1;
      tokens.push({ type: "number", value: expr.slice(i, j) });
      i = j;
      continue;
    }
    if (/[A-Za-z_]/.test(ch)) {
      let j = i + 1;
      while (j < expr.length && /[A-Za-z0-9_]/.test(expr[j])) j += 1;
      tokens.push({ type: "identifier", value: expr.slice(i, j) });
      i = j;
      continue;
    }
    if (OPERATORS.has(ch)) {
      tokens.push({ type: "operator", value: ch });
      i += 1;
      continue;
    }
    if (ch === "(") {
      tokens.push({ type: "lparen", value: ch });
      i += 1;
      continue;
    }
    if (ch === ")") {
      tokens.push({ type: "rparen", value: ch });
      i += 1;
      continue;
    }
    if (ch === ",") {
      tokens.push({ type: "comma", value: ch });
      i += 1;
      continue;
    }

    throw new Error(`Unexpected character "${ch}" in expression "${expr}"`);
  }

  return tokens;
}

const FUNCTIONS: Record<string, (...args: number[]) => number> = {
  sqrt: Math.sqrt,
  abs: Math.abs,
  round: Math.round,
  floor: Math.floor,
  ceil: Math.ceil,
  min: (...args) => Math.min(...args),
  max: (...args) => Math.max(...args),
};

const CONSTANTS: Record<string, number> = { pi: Math.PI };

class Parser {
  private position = 0;

  constructor(
    private readonly tokens: Token[],
    private readonly params: Record<string, number>,
  ) {}

  parseExpression(): number {
    let value = this.parseTerm();
    while (this.peekOperator("+") || this.peekOperator("-")) {
      const op = this.consume().value;
      const rhs = this.parseTerm();
      value = op === "+" ? value + rhs : value - rhs;
    }
    return value;
  }

  private parseTerm(): number {
    let value = this.parseUnary();
    while (this.peekOperator("*") || this.peekOperator("/")) {
      const op = this.consume().value;
      const rhs = this.parseUnary();
      if (op === "/" && rhs === 0) {
        throw new Error("Division by zero in expression");
      }
      value = op === "*" ? value * rhs : value / rhs;
    }
    return value;
  }

  private parseUnary(): number {
    if (this.peekOperator("-")) {
      this.consume();
      return -this.parseUnary();
    }
    return this.parsePower();
  }

  private parsePower(): number {
    const base = this.parsePrimary();
    if (this.peekOperator("^")) {
      this.consume();
      const exponent = this.parseUnary();
      return Math.pow(base, exponent);
    }
    return base;
  }

  private parsePrimary(): number {
    const token = this.tokens[this.position];
    if (!token) {
      throw new Error("Unexpected end of expression");
    }

    if (token.type === "number") {
      this.consume();
      return Number.parseFloat(token.value);
    }

    if (token.type === "lparen") {
      this.consume();
      const value = this.parseExpression();
      this.expect("rparen");
      return value;
    }

    if (token.type === "identifier") {
      this.consume();
      const nextToken = this.tokens[this.position];

      if (nextToken && nextToken.type === "lparen") {
        this.consume();
        const args: number[] = [];
        if (!this.peekType("rparen")) {
          args.push(this.parseExpression());
          while (this.peekType("comma")) {
            this.consume();
            args.push(this.parseExpression());
          }
        }
        this.expect("rparen");

        const fn = FUNCTIONS[token.value];
        if (!fn) {
          throw new Error(`Unknown function "${token.value}"`);
        }
        return fn(...args);
      }

      if (token.value in this.params) {
        return this.params[token.value];
      }
      if (token.value in CONSTANTS) {
        return CONSTANTS[token.value];
      }
      throw new Error(`Unknown identifier "${token.value}"`);
    }

    throw new Error(`Unexpected token "${token.value}"`);
  }

  private peekOperator(op: string): boolean {
    const token = this.tokens[this.position];
    return !!token && token.type === "operator" && token.value === op;
  }

  private peekType(type: TokenType): boolean {
    const token = this.tokens[this.position];
    return !!token && token.type === type;
  }

  private consume(): Token {
    const token = this.tokens[this.position];
    this.position += 1;
    return token;
  }

  private expect(type: TokenType): Token {
    const token = this.tokens[this.position];
    if (!token || token.type !== type) {
      throw new Error(`Expected ${type} but got "${token?.value ?? "end of expression"}"`);
    }
    return this.consume();
  }

  expectEnd(): void {
    if (this.position < this.tokens.length) {
      throw new Error(`Unexpected trailing token "${this.tokens[this.position].value}"`);
    }
  }
}

export function evaluateExpression(expr: string, params: Record<string, number>): number {
  const tokens = tokenize(expr);
  const parser = new Parser(tokens, params);
  const value = parser.parseExpression();
  parser.expectEnd();

  if (!Number.isFinite(value)) {
    throw new Error(`Expression "${expr}" evaluated to a non-finite value`);
  }

  return value;
}
