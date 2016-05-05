#!/usr/bin/env ruby -w

target_dir = 'extracted-data'
dist_dir = 'database'

Struct.new('Comment', :filepath, :content)

# split by separator, "  =====path/to/file.ext====="
# return array of each file comments
def split_output_of_extracted_comment(output)
  output
    .lines
    .slice_before(/^  =====([^=\n]+)=====$/)
    .map do |comment|
      Struct::Comment.new(
        comment[0].gsub(/^  =====|=====$/, ''),
        comment[1..-1].join('')
      )
    end
end

# --- main ---

Dir.glob("#{target_dir}/*.txt") do |arg|
  output = File.read(arg, encoding: 'UTF-8')
    .encode("UTF-16BE", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?')
    .encode("UTF-8")

  # split to each files comment
  splited_outputs = split_output_of_extracted_comment(output)
  # group by file extention (written at first line)
  grouped_outputs = splited_outputs.group_by { |e| e.filepath.match(/\.([a-z]++)$/)[1] }

  grouped_outputs.each do |key, value|
    content = value.map { |e| e.content }.join('')
    File.open("#{dist_dir}/#{key}", 'a') do |f|
      f.write(content)
    end
  end
end
