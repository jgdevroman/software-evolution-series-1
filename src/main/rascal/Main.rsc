module Main

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;

import Volume;

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

void main() {
    loc projectPathSmallSql = |cwd:///smallsql0.21_src|;
    list[Declaration] astsSmallSql = getASTs(projectPathSmallSql);
    
    smallSqlVolume = getVolume(astsSmallSql);

    println("Volume: <smallSqlVolume>");
}
