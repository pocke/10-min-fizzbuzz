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
  in [:TYPE]
  end
end

# @param node [RubyVM::AbstractSyntaxTree::Node]
# @return [String] Code of JavaScript
def compile_stmt(node)
  compile_expr(node)
rescue NoMatchingPatternError
  case node
  in [:TYPE]
  end
end


node = RubyVM::AbstractSyntaxTree.parse(ARGF.read)
puts compile_stmt(node)
