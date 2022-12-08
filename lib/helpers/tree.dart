// Copyright (c) 2022 Razeware LLC
// For full license & permission details, see LICENSE.

import 'queue.dart';

class AdObject {
  String id;
  String name;
  AdObject(this.id, this.name);
}

class TreeNode<T> {
  TreeNode(this.value);
  T value;
  TreeNode? parent;
  List<TreeNode<T>> children = [];

  void add(TreeNode<T> child) {
    child.parent = this;
    children.add(child);
  }

  void forEachDepthFirst(void Function(TreeNode<T> node) performAction) {
    performAction(this);
    for (final child in children) {
      child.forEachDepthFirst(performAction);
    }
  }

  void forEachLevelOrder(void Function(TreeNode<T> node) performAction) {
    final queue = QueueStack<TreeNode<T>>();
    performAction(this);
    children.forEach(queue.enqueue);
    var node = queue.dequeue();
    while (node != null) {
      performAction(node);
      node.children.forEach(queue.enqueue);
      node = queue.dequeue();
    }
  }

  TreeNode? search(T value) {
    TreeNode? result;
    forEachLevelOrder((node) {
      AdObject adObj = node.value as AdObject;
      if (adObj.name == value) {
        result = node;
      }
    });
    return result;
  }
}
