import re
import sys

regex = r"stored in (.+)\.$"

input_string = sys.argv[1]

matches = re.finditer(regex, input_string, re.MULTILINE | re.IGNORECASE)

for m in matches:
    print  m.group(1)


