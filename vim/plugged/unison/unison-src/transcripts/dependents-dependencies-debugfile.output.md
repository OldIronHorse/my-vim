### `debug.file`
I can use `debug.file` to see the hashes of the last typechecked file.

Given this .u file:
```unison
type outside.A = A Nat outside.B
type outside.B = B Int
outside.c = 3
outside.d = c < (p + 1)

type inside.M = M outside.A
inside.p = c
inside.q x = x + p * p
inside.r = d
```

```ucm
.> debug.file

  type inside.M#4idrjau939
  type outside.A#0n4pbd0q9u
  type outside.B#muulibntaq
  inside.p#fiupm7pl7o
  inside.q#l5pndeifuh
  inside.r#im2kiu2hmn
  outside.c#msp7bv40rv
  outside.d#6cdi7g1oi2

```
This will help me make progress in some situations when UCM is being deficient or broken.

### `dependents` / `dependencies`
But wait, there's more.  I can check the dependencies and dependents of a definition:
```ucm
.> add

  ⍟ I've added these definitions:
  
    type inside.M
    type outside.A
    type outside.B
    inside.p  : Nat
    inside.q  : Nat -> Nat
    inside.r  : Boolean
    outside.c : Nat
    outside.d : Boolean

.> dependents q

  #l5pndeifuh doesn't have any dependents.

.> dependencies q

  Dependencies of #l5pndeifuh:
  
       Reference   Name
    1. ##Nat.*     builtin.Nat.*
    2. ##Nat.+     builtin.Nat.+
    3. #fiupm7pl7o inside.p

.> dependencies B

  Dependencies of #muulibntaq:
  
       Reference Name
    1. ##Int     builtin.Int

  Dependencies of #muulibntaq#0:
  
       Reference   Name
    1. ##Int       builtin.Int
    2. #muulibntaq outside.B

.> dependencies d

  Dependencies of #6cdi7g1oi2:
  
       Reference     Name
    1. ##Nat         builtin.Nat
    2. ##Nat.+       builtin.Nat.+
    3. ##Universal.< builtin.Universal.<
    4. #fiupm7pl7o   inside.p
    5. #msp7bv40rv   outside.c

.> dependents d

  Dependents of #6cdi7g1oi2:
  
       Reference   Name
    1. #im2kiu2hmn inside.r

```
We don't have an index for dependents of constructors, but iirc if you ask for that, it will show you dependents of the type that provided the constructor.
