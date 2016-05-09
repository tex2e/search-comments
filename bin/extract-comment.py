#!/usr/bin/env python3

import sys
import glob
import re
from itertools import chain

if sys.version_info < (3, 5):
    raise RuntimeError("must use python 3.5")

target_dir = sys.argv[1]

def count_chars(text, chars):
    count = 0
    for char in chars:
        count += text.count(char)
    return count

def comment_select_filter(comment):
    return (
        len(comment) > 10 and  # comment's length is more than 10
        re.compile(r"^[-a-zA-Z0-9_ ,.:`'\"/*()]+$").match(comment) and  # comments is composed of
        count_chars(comment, "-0123456789_ ,.:`'\"\/") / len(comment) < 0.4  # less than 40% symbols
    )

def split_sentence(comment):
    splitter = re.compile(r"(?<=\.)(?<!e\.g\.|i\.e\.)\s+", re.I)
    return splitter.split(comment)

def flatten(listOfLists):
    "Flatten one level of nesting"
    return chain.from_iterable(listOfLists)

def extract_c_comment(code_string):
    comment_pattern = re.compile(r"""
        # multi-line comment
        /\*  # comment begin
            [^*]*\*+     # general
            (?:
                [^/*]    # special
                [^*]*\*+ # general
            )*
        /  # comment end
        |  # or
        # single line comment
        (?:
            \s+      # extra whitespace
            //[^\n]+ # comment
        )+
    """, re.X)
    comments = comment_pattern.findall(code_string)
    comments = [x.strip() for x in comments]
    comments = [re.sub(r"^/\*+|\*+/$", "", x) for x in comments] # remove "/*" and "*/"
    comments = [re.sub(r"^//+", "", x) for x in comments] # remove "//"
    comments = [re.sub(r"\n\s*((\*|//)[ \t]*)?", " ", x) for x in comments] # remove "\n" or "\n //"
    comments = [x.strip() for x in comments]
    comments = list(map(split_sentence, comments))
    comments = flatten(comments)
    comments = list(filter(comment_select_filter, comments))

    return comments

def extract_sh_comment(code_string):
    pass

for filename in glob.iglob('%s/**/*.*' % target_dir, recursive=True):
    with open(filename, 'r') as f:
        code_str = f.read()
        comments = []
        c_lang_ext = re.compile(r"\.(c|cpp|h|hpp|java|cs|php|js|go)$")
        sh_lang_ext = re.compile(r"\.(sh|py|rb|coffee)$")
        if c_lang_ext.search(filename):
            comments = extract_c_comment(code_str)
        elif sh_lang_ext.search(filename):
            comments = extract_sh_comment(code_str)
        else:
            continue

        if len(comments) == 0:
            continue

        # write result to stdin
        print("  =====%s=====" % filename)
        print("%s" % ("\n".join(comments)))
