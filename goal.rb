module AstExt
  refine RubyVM::AbstractSyntaxTree::Node do
    def deconstruct
      [type, *children]
    end
  end
end

using AstExt

# @param node [RubyVM::AbstractSyntaxTree::Node]
# @return [String] Code of JavaScript
def compile_expr(node)
  case node
  in [:FCALL, :puts, [:ARRAY, arg, nil]]
    arg_src = compile_expr(arg)
    "console.log(#{arg_src})"
  in [:STR, str]
    str.dump
  in [:LIT, num]
    num.to_s
  in [:LVAR, name]
    name.to_s
  in [:OPCALL, l, op, [:ARRAY, r, nil]]
    "#{compile_expr(l)} #{op} #{compile_expr(r)}"
  end
end

# @param node [RubyVM::AbstractSyntaxTree::Node]
# @return [String] Code of JavaScript
def compile_stmt(node)
  compile_expr(node)
rescue NoMatchingPatternError
  case node
  in [:LASGN, name, value]
    value_src = compile_expr(value)
    "#{name} = #{value_src}"
  in [:BLOCK, *children]
    children.map { compile_stmt(@1) }.join("\n")
  in [:SCOPE, _, _, body]
    compile_stmt(body)
  in [:WHILE, cond, body, true]
    cond_src = compile_expr(cond)
    body_src = compile_stmt(body)
    <<~JS
      while (#{cond_src}) {
        #{body_src}
      }
    JS
  in [:IF, cond, body, else_body]
    cond_src = compile_expr(cond)
    body_src = compile_stmt(body)
    else_src = compile_stmt(else_body) if else_body
    if else_src
      <<~JS
        if (#{cond_src}) {
          #{body_src}
        } else {
          #{else_src}
        }
      JS
    else
      <<~JS
        if (#{cond_src}) {
          #{body_src}
        }
      JS
    end
  end
end


node = RubyVM::AbstractSyntaxTree.parse(ARGF.read)
puts compile_stmt(node)
