#!/usr/bin/env ruby -w

def comment_reject_filter(comment)
  return (
    comment.length <= 10 ||  # comment's length is less than 10
    !comment.match(/\A[-a-zA-Z0-9_ ,.:`'"\/*(){}]++\z/) ||  # comments isn't composed of
    comment.count("-_ ,.:`'\"\/") / comment.length.to_f >= 0.4  # more than 40% symbols
  )
end

def split_sentence(comment)
  comment.split(/(?<=\.)(?<!e\.g\.|i\.e\.)\s++/i)
end

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
    .map { |e| e.sub(/^\/\/++/, '') }  # delete "//"
    .map { |e| e.gsub(/\n\s*+((\*|\/\/)[ \t]*+)?/, ' ') }  # delete "\n" or "\n //"
    .map(&:strip)
    .map(&method(:split_sentence))
    .flatten
    .reject(&method(:comment_reject_filter))
end

def extract_sh_comment(code_string)
  comments = code_string.scan(
    %r{(
      # single line comment
      (?:
        \s++      # extra whitespace
        \#[^\n]++ # comment
      )+
    )}x
  ).flatten

  comments = comments
    .map(&:strip)
    .map { |e| e.sub(/^#/, '') }  # delete "#"
    .map { |e| e.gsub(/\n\s*+(\#[ \t]*+)?/, ' ') }  # delete "\n" or "\n #"
    .map(&:strip)
    .map(&method(:split_sentence))
    .flatten
    .reject(&method(:comment_reject_filter))
end

# --- main ---

ARGV.each do |arg|
  next unless File.exist?(arg)

  code_str = File.read(arg, encoding: 'UTF-8')
    .encode("UTF-16BE", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?')
    .encode("UTF-8")

  comments = []
  if arg =~ /\.(c|cpp|h|hpp|java|cs|php|js|go)$/
    comments = extract_c_comment(code_str)
  elsif arg =~ /\.(sh|py|rb|coffee)$/
    comments = extract_sh_comment(code_str)
  else
    next
  end

  next if comments.empty?

  # write result to stdin
  puts "  =====#{arg}=====\n"
  puts "#{comments.join("\n")}\n"
end
