import lists

type
  OCTNode[T] = ref object
    value: tuple[k: T, v: int]
    left: OCTNode[T]
    right: OCTNode[T]
    height: int
  OrderedCountTable*[T] = object
    counter*: int
    root: OCTNode[T]

proc newOCTNode[T](k: T, v = 0, left: OCTNode[T] = nil, right: OCTNode[T] = nil): OCTNode[T] =
  result = new OCTNode[T]
  result.value = (k, v)
  result.left = left
  result.right = right

proc find[T](n: OCTNode[T], k: T): OCTNode[T] =
  if isNil(n):
    nil
  elif n.value.k == k:
    n
  elif n.value.k > k:
    find(n.left, k)
  else:
    find(n.right, k)

proc heightOf[T](n: OCTNode[T]): int =
  if isNil(n):
    -1
  else:
    n.height

proc rotate[T](n: OCTNode[T]): OCTNode[T] =
  var A, B, C, T1, T2, T3, T4: OCTNode[T]
  if not isNil(n.left) and not isNil(n.left.left) and n.left.left.value.k < n.left.value.k and n.left.value.k < n.value.k:
    A = n.left.left
    B = n.left
    C = n
    T1 = A.left
    T2 = A.right
    T3 = B.right
    T4 = C.right
  elif not isNil(n.right) and not isNil(n.right.right) and n.right.right.value.k > n.right.value.k and n.right.value.k > n.value.k:
    A = n
    B = n.right
    C = n.right.right
    T1 = A.left
    T2 = B.left
    T3 = C.left
    T4 = C.right
  elif not isNil(n.left) and not isNil(n.left.right) and n.left.right.value.k > n.left.value.k and n.left.value.k < n.value.k:
    A = n.left
    B = n.left.right
    C = n
    T1 = A.left
    T2 = B.left
    T3 = B.right
    T4 = C.right
  else:
    A = n
    B = n.right.left
    C = n.right
    T1 = A.left
    T2 = B.left
    T3 = B.right
    T4 = C.right
  B.left = A
  B.right = C
  A.left = T1
  A.right = T2
  C.left = T3
  C.right = T4
  A.height = max(heightOf(T1), heightOf(T2))
  C.height = max(heightOf(T3), heightOf(T4))
  B.height = max(heightOf(A), heightOf(C))
  return B

proc checkHeight[T](n: OCTNode[T]): OCTNode[T] =
  if abs(heightOf(n.left) - heightOf(n.right)) > 1:
    rotate(n)
  else:
    n.height = max(heightOf(n.left), heightOf(n.right)) + 1
    n

proc findOrCreate[T](n: OCTNode[T], k: T, default = 0, parent: OCTNode[T] = nil): OCTNode[T] =
  if isNil(n):
    result = newOCTNode(k, default)
    if not isNil(parent):
      if parent.value.k > k:
        parent.left = result
      else:
        parent.right = result
    return
  elif n.value.k == k:
    return n
  elif n.value.k > k:
    result = findOrCreate(n.left, k, default, n)
  else:
    result = findOrCreate(n.right, k, default, n)
  if not isNil(parent):
    if parent.value.k > k:
      parent.left = checkHeight(n)
    else:
      parent.right = checkHeight(n)

proc add*[T](t: var OrderedCountTable[T], k: T) =
  var node = findOrCreate(t.root, k)
  inc node.value.v
  if isNil(t.root):
    t.root = node
  inc t.counter

proc initOrderedCountTable*[T](keys: openarray[T]): OrderedCountTable[T] =
  for k in keys:
    result.add(k)

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
