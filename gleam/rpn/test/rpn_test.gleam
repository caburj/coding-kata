import gleeunit
import gleeunit/should
import rpn.{InvalidExpression, InvalidToken, rpn}

pub fn main() {
  gleeunit.main()
}

pub fn add_test() {
  rpn("10 4 +")
  |> should.equal(Ok(14))
}

pub fn subtract_test() {
  rpn("10 4 -")
  |> should.equal(Ok(6))
}

pub fn multiply_test() {
  rpn("10 4 *")
  |> should.equal(Ok(40))
}

pub fn divide_test() {
  rpn("10 4 /")
  |> should.equal(Ok(2))
}

pub fn mixed_test() {
  rpn("10 4 + 2 *")
  |> should.equal(Ok(28))
}

pub fn invalid_expression_test() {
  rpn("10 4 + 1")
  |> should.equal(Error(InvalidExpression(expr: "10 4 + 1")))
}

pub fn invalid_token_right_test() {
  rpn("10 a +")
  |> should.equal(Error(InvalidToken(token: "a")))
}

pub fn invalid_token_left_test() {
  rpn("b 10 +")
  |> should.equal(Error(InvalidToken(token: "b")))
}
