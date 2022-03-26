#!/usr/bin/python
import sys
import re

def convertQuotes(latex):
    startTag = "\\begin{quote}"
    endTag = "\\end{quote}"

    while True:
        endPos = latex.find(endTag)
        if endPos == -1:
            break
        endPos += len(endTag)
        startPos = latex.rfind(startTag, 0, endPos)

        substring = latex[startPos:endPos]
        mdQuoted = substring
        mdQuoted = re.sub(r"\n", r" \n >", mdQuoted, flags=re.MULTILINE)
        mdQuoted = mdQuoted.replace(startTag, "")
        mdQuoted = mdQuoted.replace(endTag, "")
        latex = latex.replace(substring, mdQuoted)

    return latex

def convertTable(match):
    latex = match.group()
    latex = re.sub(r"\\begin{tabular}(?:\{([^\}]*)\})?", r"", latex)
    latex = re.sub(r"\\end\{tabular\}", r"", latex)
    latex = latex.strip()
    latex = re.sub(r"\\hline$", r"", latex)

    latex = re.sub(r"\\hline\n", r"| ", latex)
    latex = re.sub(r"\\\\\n", r" |\n", latex)
    latex = re.sub(r"&", r" | ", latex)

    numberOfColumns = latex[0:latex.find("\n")].count("|") - 1
    latex = "| " * numberOfColumns + "|\n" + "|---" * numberOfColumns + "|\n" + latex
    
    return latex

def convertEquationArray(match):
    latex = match.group()
    latex = re.sub(r"\\\\", r" \\newline", latex)
    
    return latex

def mdfy(latex):
    latex = re.sub(r"(\\section{Exercises})((.|\n)*)", r"", latex, flags=re.MULTILINE)

    # Text formating
    latex = re.sub(r"\{\\em ([^}]*)\}", r"*\g<1>*", latex)
    latex = re.sub(r"\{\\it ([^}]*)\}", r"*\g<1>*", latex)
    latex = re.sub(r"\{\\bf ([^}]*)\}", r"**\g<1>**", latex)
    latex = re.sub(r"``([^']*)''", r'"\g<1>"', latex)
    latex = re.sub(r"\\url{([^}]*)}", r"[\g<1>](\g<1>)", latex)

    latex = re.sub(r"\\\{", "{", latex)
    latex = re.sub(r"\\\}", "}", latex)
    latex = re.sub(r"\\%", "%", latex)
    latex = re.sub(r"\\ldots", "...", latex)

    latex = re.sub(r"\\begin\{small\}", "", latex)
    latex = re.sub(r"\\end\{small\}", "", latex)

    latex = re.sub(r"\{\\sf ([^}]*)\}", r"**\g<1>**", latex)
    latex = re.sub(r"\\textbf\{([^}]*)\}", r"**\g<1>**", latex)

    # Sections and subsections
    latex = re.sub(r"\\chapter\{([^}]*)\}", r"# \g<1>", latex)
    latex = re.sub(r"\\section\{([^}]*)\}", r"## \g<1>", latex)

    # Codeblocks
    latex = re.sub(r"\\java\{([^}]*)\}", r"`\g<1>`", latex)
    latex = re.sub(r"\{\\tt ([^}]*)\}", r"`\g<1>`", latex)
    latex = re.sub(r"\\begin\{code\}", r"```", latex)
    latex = re.sub(r"\\end\{code\}", r"```", latex)
    latex = re.sub(r"\\begin\{stdout\}", r"```", latex)
    latex = re.sub(r"\\end\{stdout\}", r"```", latex)
    latex = re.sub(r"\\begin\{trinket\}(\[[0-9]+\])?\{([^}]*)\}", r"```", latex)
    latex = re.sub(r"\\end\{trinket\}", r"```", latex)
    latex = re.sub(r'\\verb"([^"]*)"', r'`\g<1>`', latex)
    latex = re.sub(r"\\verb'([^']*)'", r'`\g<1>`', latex)

    # Comments and unnecesary tags
    latex = re.sub(r"^\%([^\n]*)\n", r"", latex, flags=re.MULTILINE)
    latex = re.sub(r"\\index\{([^}]*)\}", r"", latex)
    latex = re.sub(r"\\label\{([^}]*)\}", r"", latex)
    latex = re.sub(r"\\begin\{itemize\}", r"", latex)
    latex = re.sub(r"\\end\{itemize\}", r"", latex)
    latex = re.sub(r"\\begin\{enumerate\}", r"", latex)
    latex = re.sub(r"\\end\{enumerate\}", r"", latex)

    # Spacing
    latex = re.sub(r"\\vspace\{([^}]*)\}", r"", latex)
    latex = re.sub(r"\\hspace\{([^}]*)\}", r"", latex)

    # Items
    latex = re.sub(r"\n\n\\item", r"\n  *", latex)
    latex = re.sub(r"\\item\[([^\]]*)\]", r"  * **\g<1>**", latex)
    latex = re.sub(r"\\item ([^\n]*)", r"  * \g<1>", latex)

    # Equations
    latex = re.sub(r"\\\[([^\]]*)\\\]", r"$\g<1>$", latex)

    #images
    latex = re.sub(r"figs/([^\.]*)\.pdf", r"\g<1>.png", latex)
    latex = re.sub(r"figs/([^\.]*)\.jpg", r"\g<1>.jpg", latex)
    latex = re.sub(r"\\includegraphics\{([^}]*)\}", r"![\g<1>](\g<1>)", latex)
    latex = re.sub(r"\\caption\{([^}]*)\}", r"<p>\g<1></p>", latex)
    latex = re.sub(r"\\begin\{figure\}(\[([^\]]*)\])?", r"", latex)
    latex = re.sub(r"\\begin\{center\}", r"", latex)
    latex = re.sub(r"\\end\{figure\}", r"", latex)
    latex = re.sub(r"\\end\{center\}", r"", latex)
    latex = re.sub(r"\\includegraphics(?:\[([^\]]*)\])?\{([^}]*)\}", r"![\g<2>](\g<2>)", latex)

    # Vocabullary definition
    latex = re.sub(r"\\begin\{description\}", r"", latex)
    latex = re.sub(r"\\end\{description\}", r"", latex)
    latex = re.sub(r"\\term\{([^}]*)\}", r"***\g<1>:***", latex)
    latex = re.sub(r"\\term\{([^}]*)\}", r"***\g<1>:***", latex)

    # Table
    latex = re.sub(r"\\begin\{table\}(\[[^\]]+\])?", r"", latex)
    latex = re.sub(r"(?:\\begin{tabular})(?:\{([^\}]*)\})?((.|\n)*)(?:\\end{tabular})", convertTable, latex, flags=re.MULTILINE)
    latex = re.sub(r"\\end\{table\}", r"", latex)
    
    # Equation array
    latex = re.sub(r"(?:\\begin{eqnarray\*})((.|\n)*)(?:\\end{eqnarray\*})", convertEquationArray, latex, flags=re.MULTILINE)

    # Quotes
    latex = convertQuotes(latex)

    return latex

def main(argv):
    inputfile = argv[0]
    outputfile = argv[1]
    

    with open(inputfile, 'r') as texFile:
        latex = texFile.read().rstrip()

    markdown = mdfy(latex)

    mdFile = open(outputfile, "w")
    mdFile.write(markdown)
    mdFile.close()


if __name__ == "__main__":
    main(sys.argv[1:])
