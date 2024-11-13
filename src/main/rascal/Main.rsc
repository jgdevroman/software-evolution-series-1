module Main

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;

loc projectLocation = |cwd:///smallsql0.21_src|;

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

void printAllSourceLocations(list[Declaration] asts) {
    for (decl <- asts) {
        println("Source location for declaration:");
        println("File: <decl.src.top>");
        str file = readFile(decl.src.top);
        println(file);

        break;
    }
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


void main(loc projectPath = projectLocation) {
    list[Declaration] asts = getASTs(projectPath);
    
    totalCount = 0;

    for (decl <- asts){
        totalCount += getLineCount(decl.src.top);
    }

    println("Volume: <totalCount>");
}
