import lists

type
  OCTNode[T] = ref object
    red: bool
    value: tuple[k: T, v: int]
    left, right: OCTNode[T]
  OrderedCountTable*[T] = object
    root: OCTNode[T]
    counter*: int

proc isRed[T](n: OCTNode[T]): bool =
  not isNil(n) and n.red

proc rotateRight[T](n: OCTNode[T]): OCTNode[T] =
  result = n.left
  n.left = result.right
  result.right = n
  n.red = true
  result.red = false

proc rotateLeft[T](n: OCTNode[T]): OCTNode[T] =
  result = n.right
  n.right = result.left
  result.left = n
  n.red = true
  result.red = false

proc rotateLeftRight[T](n: OCTNode[T]): OCTNode[T] =
  result = n.left.right
  n.left.right = result.left
  result.left = n.left
  n.left = result.right
  result.right = n
  n.red = true
  result.red = false

proc rotateRightLeft[T](n: OCTNode[T]): OCTNode[T] =
  result = n.right.left
  n.right.left = result.right
  result.right = n.right
  n.right = result.left
  result.left = n
  n.red = true
  result.red = false

proc newOCTNode[T](key: T, value: int): OCTNode[T] =
  result = new OCTNode[T]
  result.red = true
  result.value = (key, value)

proc rebalanceLeft[T](n: OCTNode[T]): OCTNode[T] =
  if isRed(n.left):
    if isRed(n.right):
      n.red = true
      n.left.red = false
      n.right.red = false
      return n
    if isRed(n.left.left):
      return rotateRight(n)
    if isRed(n.left.right):
      return rotateLeftRight(n)
  return n

proc rebalanceRight[T](n: OCTNode[T]): OCTNode[T] =
  if isRed(n.right):
    if isRed(n.left):
      n.red = true
      n.left.red = false
      n.right.red = false
      return n
    if isRed(n.right.right):
      return rotateLeft(n)
    if isRed(n.right.left):
      return rotateRightLeft(n)
  return n

proc insertOrAdd[T](n: OCTNode[T], key: T, val: int): OCTNode[T] =
  if isNil(n):
    newOCTNode(key, val)
  elif key == n.value.k:
    n.value.v += val
    n
  elif key < n.value.k:
    n.left = insertOrAdd(n.left, key, val)
    rebalanceLeft(n)
  else:
    n.right = insertOrAdd(n.right, key, val)
    rebalanceRight(n)

proc find[T](n: OCTNode[T], k: T): OCTNode[T] =
  if isNil(n) or n.value.k == k:
    n
  elif n.value.k > k:
    find(n.left, k)
  else:
    find(n.right, k)

proc inc*[T](t: var OrderedCountTable[T], key: T, val = 1) =
  t.root = insertOrAdd(t.root, key, val)
  t.root.red = false
  t.counter += val

proc initOrderedCountTable*[T](keys: openarray[T]): OrderedCountTable[T] =
  for k in keys:
    result.inc(k)

proc getOrDefault*[T](t: OrderedCountTable[T], k: T, default = 0): int =
  let node = find(t.root, k)
  if isNil(node):
    default
  else:
    node.value.v

iterator items*[T](t: OrderedCountTable[T]): tuple[k: T, v: int] =
  var nodes = initDoublyLinkedList[OCTNode[T]]()
  var current = t.root
  while true:
    while not isNil(current):
      nodes.prepend(current)
      current = current.left
    if isNil(nodes.head):
      break
    yield nodes.head.value.value
    current = nodes.head.value.right
    nodes.remove(nodes.head)
