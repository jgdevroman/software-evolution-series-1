module Volume

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;


int getVolume(list[Declaration] asts) {
    totalCount = 0;

    for (decl <- asts){
        totalCount += getLineCount(decl.src.top);
    }

    return totalCount;
}

int getLineCount(loc file) {
    code = readFile(file);

    for (/<comment:\/\*(?:.|\n)*?\*\/>/ := code) { 
        code = replaceAll(code, comment, "");
    }
    
    list[str] lines = split("\n", code);
    int totalCount = 0;

    for (str line <- lines) {
      line = trim(line);

      if(!startsWith(line, "//") && line != "") {
        totalCount += 1; 
      }
    }

    return totalCount;
}