import re


def init_parse_line():  # split the line into name and email and return

    pattern = re.compile(r"(\S+\s?\S+\s?\S+)\s+(\S+)\s*(\d*)")

    def parse_line(line):
        return re.match(pattern, line.strip()).groups()

    return parse_line


def format_name(name):
    parts = name.split(",")
    return ("%s %s" % (parts[1], parts[0]))


def main():  # read in each line of input and load into csv
    parse_line = init_parse_line()

    myin = open("input", "r")
    myout = open("output.csv", "w")
    myout.write("Full Name,Email,SID")
    for line in myin:
        output = parse_line(line)
        output = (format_name(output[0]),output[1])
        myout.write("%s,%s\n" % output)

    myin.close()
    myout.close()


if __name__ == "__main__":
    main()
