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
import Location;

import Volume;
import Utility;
import UnitSize;
import UnitComplexity;
import Test;
import Duplication;
import Metrics;


void main() {
    list[str] entries = listEntries(|cwd:///resources|);

    println("Start analyzing following projects: <entries>. Can take a few minutes..");
    
    for(entry <- entries) {
        if(entry == ".gitkeep") {
            continue;
        }
        projectLocation = |cwd:///resources/| + entry;
        set[loc] fileLocations = find(projectLocation, "java");
        smallSqlVolume = getVolume(fileLocations);
        smallSqlDuplication = getDuplication(projectLocation);
        smallSqlUnitSize = getUnitSize(projectLocation);
        smallSqlComplexity = calculateComplexity(fileLocations);
        printMetricsReport(smallSqlVolume, smallSqlDuplication, smallSqlComplexity, smallSqlUnitSize, entry);
    }
}
