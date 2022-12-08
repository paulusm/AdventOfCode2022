import 'dart:collection';
import 'dart:io';
import 'helpers/tree.dart';
import 'package:uuid/uuid.dart';

class AdFile extends AdObject {
  int fsize;
  AdFile(String id, String name, this.fsize) : super(id, name);
}

class AdDir extends AdObject {
  AdDir(String id, String name) : super(id, name);
}

class Day7 {
  Day7() {
    readData().then((data) {
      TreeNode fileTree = TreeNode(AdDir(Uuid().v4(), 'root'));
      TreeNode subFolder;
      TreeNode parentFolder = fileTree;

      for (String logLine in data) {
        //CD commands
        RegExp cdRE = RegExp(r'. cd (.*)');
        Match? ptnMatch = cdRE.firstMatch(logLine);
        if (ptnMatch != null) {
          String cdCmd = ptnMatch.group(1) ?? '';
          //print('cd command ${cdCmd}');
          if (cdCmd != '/') {
            if (cdCmd == '..') {
              parentFolder = parentFolder.parent ?? fileTree;
            } else {
              parentFolder = parentFolder.children
                  .where((element) => element.value.name == cdCmd)
                  .first;
            }
          }
        }

        //Folders
        cdRE = RegExp(r'dir (.*)');
        ptnMatch = cdRE.firstMatch(logLine);
        if (ptnMatch != null) {
          //print('Folder ${ptnMatch.group(1)}');
          String cdCmd = ptnMatch.group(1) ?? '';
          subFolder = TreeNode(AdDir(Uuid().v4(), cdCmd));
          parentFolder.add(subFolder);
        }

        //Files
        cdRE = RegExp(r'([0-9]+) (.*)');
        ptnMatch = cdRE.firstMatch(logLine);
        if (ptnMatch != null) {
          //print('file size - ${ptnMatch.group(1)} name - ${ptnMatch.group(2)}');
          AdFile newFile = AdFile(Uuid().v4(), ptnMatch.group(2) ?? 'not found',
              int.tryParse(ptnMatch.group(1) ?? '0') ?? 0);
          parentFolder.add(TreeNode(newFile));
        }
      }
      HashMap<String, int> sizes = getDirSize(fileTree);
      print(sizes.toString());
      //printTree(fileTree);
    });
  }

  void printTree(TreeNode fromNode) {
    String retVal = '';
    fromNode.forEachLevelOrder((node) {
      if (node.value.runtimeType.toString() == 'AdDir') {
        retVal +=
            ('${(node.parent ?? node).value.name} dir ${node.value.name}\n');
      } else {
        retVal += ('${(node.parent ?? node).value.name} ${node.value.name}\n');
      }
    });
    print(retVal);
  }

  HashMap<String, int> getDirSize(TreeNode startDir) {
    int dirSize = 0;
    HashMap<String, int> hRet = HashMap();

    startDir.forEachDepthFirst((node) {
      if (node.value.id != startDir.value.id) {
        if (node.value.runtimeType.toString() == 'AdDir') {
          //print(node.value.name);
          if (!hRet.containsKey(node.value.id + '-' + node.value.name)) {
            HashMap<String, int> subFolder = getDirSize(node);
            hRet.addEntries(subFolder.entries);
            for (String keyName in subFolder.keys) {
              dirSize += subFolder[keyName] as int;
            }
          }
        } else {
          dirSize += node.value.fsize as int;
        }
      }
    });

    hRet[startDir.value.id + '-' + startDir.value.name] = dirSize;
    return hRet;
  }

  Future<List<String>> readData() async {
    return (await File('data/7-bash-test.txt').readAsLines());
  }
}
