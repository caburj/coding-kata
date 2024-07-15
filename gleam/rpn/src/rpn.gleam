import gleam/int
import gleam/list
import gleam/string

pub type RPNError {
  InvalidExpression(expr: String)
  InvalidToken(token: String)
}

type Operator {
  Add
  Subtract
  Multiply
  Divide
}

type Token {
  Op(op: Operator)
  Val(val: Int)
  Invalid(val: String)
}

pub fn rpn(input_str) {
  do_rpn(input_str_to_tokens(input_str), #([], input_str))
}

fn do_rpn(tokens, iter_state) -> Result(Int, RPNError) {
  let #(stack, input_str) = iter_state
  case tokens, stack {
    [], [Val(res)] -> {
      Ok(res)
    }
    [Op(op), ..xs], [Val(x), Val(y), ..rest] -> {
      do_rpn(xs, #([apply_op(op, y, x), ..rest], input_str))
    }
    [Val(_) as x, ..xs], _ -> {
      do_rpn(xs, #([x, ..stack], input_str))
    }
    [Invalid(x), ..], _ | _, [Invalid(x), ..] | _, [_, Invalid(x), ..] -> {
      Error(InvalidToken(token: x))
    }
    _, _ -> {
      Error(InvalidExpression(expr: input_str))
    }
  }
}

fn input_str_to_tokens(input_str) {
  input_str
  |> string.split(" ")
  |> list.map(fn(s) {
    case s {
      "+" -> Op(Add)
      "-" -> Op(Subtract)
      "*" -> Op(Multiply)
      "/" -> Op(Divide)
      other -> {
        case int.parse(other) {
          Ok(val) -> Val(val)
          Error(_) -> Invalid(other)
        }
      }
    }
  })
}

fn apply_op(op: Operator, a: Int, b: Int) -> Token {
  case op {
    Add -> Val(a + b)
    Subtract -> Val(a - b)
    Multiply -> Val(a * b)
    Divide -> Val(a / b)
  }
}
