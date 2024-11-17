module Duplication

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;

import Utility;

int BLOCK_COUNT = 6;

real getDuplication(loc projectPath) {
    // list[Declaration] asts = getASTs(projectPath);

    list[str] lines = getLines(projectPath);
    int count = getDuplicationCount(lines);

    return (count * 1.0) / (size(lines) * 1.0);   
}

int getDuplicationCount(list[str] lines) {
    // Return no duplication if there are no lines or there are not more than 6 lines
    if (isEmpty(lines) || size(lines) < BLOCK_COUNT) {
        return 0;
    }


    // Holds all the blocks of size 6
    list[list[str]] blockList = [];

    // Holds all the indexes of each block
    map[list[str], list[int]] blockMap = ();
    
    // Holds all indexes with duplicated code over more or equal than 6 lines 
    set[int] duplicationIndex = {};

    // Make a list of 6 lines and calculte the distribution
    int length = size(lines) - BLOCK_COUNT;
    for (int startPos <- [0 .. length]) {        
        int endPos = startPos + BLOCK_COUNT;
        list[str] block =  [trim(line) | line <- lines[startPos .. endPos]];
        blockList += [block];
        blockMap += (block: [startPos..endPos]);
    }
    // compute the duplicatied blocks with List.distribution
    blockDistribution = distribution(blockList);
    duplicatedBlocks = [b | b <- blockDistribution, blockDistribution[b] > 1];

    // retrieve the duplicated blocks from the distribution and store the indexes of the blocks
    for (dupBlock <- duplicatedBlocks) {
       blockIndex = blockMap[dupBlock];
       for (index <- blockIndex) {
        duplicationIndex += {index};
       } 
    }
    return size(duplicationIndex);
}