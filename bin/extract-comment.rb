#!/usr/bin/env ruby -w

def extract_c_comment(code_string)
  comments = code_string.scan(
    %r{(
      # multi-line comment
      /\*  # comment begin
        [^*]*\*++   # general
        (?:
          [^/*]     # special
          [^*]*\*++ # general
        )*
      /  # comment end
      |  # or
      # single line comment
      (?:
        \s++      # extra whitespace
        //[^\n]++ # comment
      )+
    )}x
  ).flatten

  comments = comments
    .map(&:strip)
    .map { |e| e.sub(/^\/\*+/, '') }  # delete "/*"
    .map { |e| e.sub(/\*+\/$/, '') }  # delete "*/"
    .map { |e| e.sub(/^\/\//,  '') }  # delete "//"
    .map { |e| e.gsub(/\n\s*+((\*|\/\/)[ \t]*+)?/, ' ') }  # delete "\n" or "\n *"
    .map(&:strip)
    .map { |e| e.split(/(?<=\.)(?<!e\.g\.|i\.e\.)\s++/) }
    .flatten
    .reject { |e| e.length <= 10 }
end

def extract_python_comment(code_string)
  comments = code_string.scan(
    %r{(
      # multi-line comment
      """  # comment begin
        (?:
          [^\\"]++  # general
          |
          \\.       # special
          |
          "(?!=")   # special
          |
          ""(?!=")  # special
        )*
      """  # comment end
      |  # or
      # single line comment
      (?:
        \s++      # extra whitespace
        #[^\n]++ # comment
      )+
    )}x
  ).flatten

  comments = comments
    .map(&:strip)
    .map { |e| e.sub(/^"""/, '') }  # delete '"""'
    .map { |e| e.sub(/^#/,  '') }  # delete "#"
    .map { |e| e.gsub(/\n\s*+/, ' ') }  # delete "\n"
    .map(&:strip)
    .map { |e| e.split(/(?<=\.)(?<!e\.g\.|i\.e\.)\s++/) }
    .flatten
    .reject { |e| e.length <= 10 }
end

# --- main ---

ARGV.each do |arg|
  comments = []

  code_str = File.read(arg, encoding: 'UTF-8')
    .encode("UTF-16BE", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?')
    .encode("UTF-8")

  if arg =~ /\.(c|cpp|h|hpp|java|cs|php|js)$/
    comments = extract_c_comment(code_str)
  elsif arg =~ /\.(sh|py|rb|coffee)$/
    comments = extract_python_comment(code_str)
  else
    next
  end

  next if comments.empty?

  # write result to stdin
  puts "  =====#{arg}=====\n"
  puts "#{comments.join("\n")}\n"
end
