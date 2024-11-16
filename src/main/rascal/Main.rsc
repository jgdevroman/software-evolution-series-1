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
    loc projectPathHsql = |cwd:///hsqldb-2.3.1|;
    
    smallSqlVolume = getVolume(projectPathSmallSql);
    // Getting errors. Need to fix 
    // hsqlVolume = getVolume(projectPathHsql);

    println("Volume smallSql: <smallSqlVolume>");
    // println("Volume hsql: <hsqlVolume>");
}
