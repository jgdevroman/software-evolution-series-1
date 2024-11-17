module Main

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;
import util::FileSystem;

import Volume;
import Utility;
import UnitSize;
import UnitComplexity;
import Test;
import Duplication;


void main() {
    loc projectPathSmallSql = |cwd:///smallsql0.21_src|;
    loc projectPathHsql = |cwd:///hsqldb-2.3.1|;
    loc testLocation = |cwd:///Tests///Complexity|;

    set[loc] smallsqlAST = find(projectPathSmallSql, "java");
    set[loc] hsqldbAST = find(projectPathHsql, "java");
    set[loc] testloc = find(testLocation, "java");
    
    int smallSqlVolume = getVolume(smallsqlAST);
    println("Volume smallSql: <smallSqlVolume>");

    getUnitSize(projectPathSmallSql);
    calculateComplexity(smallsqlAST);
}
