import lists

type
  OrderedCountTable*[T] = object
    pairs*: SinglyLinkedList[tuple[k: T, v: int]]
    counter*: int

iterator items*[T](t: OrderedCountTable[T]): tuple[k: T, v: int] =
  for i in items(t.pairs):
    yield i

proc inc*[T](t: var OrderedCountTable[T], k: T, v = 1) =
  var current = t.pairs.head
  var prev, newNode: SinglyLinkedNode[tuple[k: T, v: int]]
  t.counter += v
  if current == nil:
    t.pairs.prepend((k, v))
    return
  while current != nil:
    if current.value.k == k:
      current.value.v += v
      return
    if current.value.k > k:
      if prev != nil:
        newNode = newSinglyLinkedNode((k, v))
        newNode.next = current
        prev.next = newNode
        return
      else:
        t.pairs.prepend((k, v))
      return
    prev = current
    current = current.next
  newNode = newSinglyLinkedNode((k, v))
  prev.next = newNode

proc initOrderedCountTable*[T](keys: openarray[T]): OrderedCountTable[T] =
  for k in keys:
    result.inc(k)

proc `[]`*[T](t: OrderedCountTable[T], key: T): int =
  for i in items(t):
    if i.k == key:
      return i.v
  when compiles($key):
    raise newException(KeyError, "key not found: " & $key)
  else:
    raise newException(KeyError, "key not found")

proc getOrDefault*[T](t: OrderedCountTable[T], key: T, default = 0): int =
  try:
    result = t[key]
  except KeyError:
    result = default
