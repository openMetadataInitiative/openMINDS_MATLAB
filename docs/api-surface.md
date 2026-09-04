# Public API surface

What this toolbox promises to keep stable, and what it reserves the right to
change. Written ahead of v1.0.0, when those promises start binding.

## The rule

**A name is internal if reaching it means writing `internal`.** Every other name
under `openminds` is public.

The segment may sit at any depth. `openminds.internal.serializer.JsonLdSerializer`
is internal, and so would be `openminds.graph.internal.Walker` if it existed.
A subsystem can keep a private corner without inventing a second convention, and
the test stays one you apply by reading a call.

The test is about **reach, not about where a thing is declared.** A public class
may inherit from an internal one. A public method may return or accept an
internal type. Both are fine as long as the caller never has to name it. What is
promised is the set of members reachable through public names, not the identity
of the class that happens to declare them.

That distinction is what keeps this surface small. Without it, every
implementation detail that touches a public path has to be promoted to be
honest, and the public surface grows until it is the whole codebase.

There is one exception, called out because it cannot be expressed in a package
name: the unpackaged property validators in `code/validators` are public,
because generated type classes reference them unqualified in `arguments` blocks
and user-facing validation errors name them.

Folder layout follows the rule rather than defining it. Everything ships from
`code/+openminds`, so the package path is the only boundary a reader has to
learn.

## Closing a gap without growing the surface

When a consumer has to write an internal name, that is a gap. Close it with the
smallest affordance that removes the need, preferring earlier options:

1. **Nothing.** If the name is only observed — in `class` output, in a
   `superclasses` listing, in a stack trace — leave it. Observation is not
   dependence, and no promise is being asked for.
2. **A member on something already public.** A predicate, a property, an
   option, a documented protected hook.
3. **A small function**, in `openminds.utility` if it fits nowhere better.
4. **Promotion of the type itself.** Only when the consumer must name it: to
   construct it, to subclass it, or to declare it in an `arguments` block.

Type introspection reached step 4, because a caller constructs an
`openminds.meta.Type` and names the class. Most of what follows does not.

### Generated mixed types stay internal

The 1520 generated mixed-type classes are emitted into
`openminds.internal.mixedtype`. Under the rule they are internal, and they stay
there; moving them would add 1520 public class names to buy very little.

- `class(subject.species)` returns
  `openminds.internal.mixedtype.subject.Species` for an unassigned "one of"
  property. That is step 1: observed, never written. Assignment errors already
  name the allowed public types instead, which is the message that matters.
- `isa(value, ...MixedTypeSet)` is step 1 too, because
  `openminds.utility.isMixedInstance` already answers it.
- `getMixedTypeForProperty` returns one of these names, and that is the one to
  watch. It is fine as a handle to pass back into the toolbox, and not fine as a
  name to construct from. `listLinkedTypesForProperty` already answers the
  question a caller usually has, in public type names. Document the difference
  rather than moving the classes.

## Stability promise from v1.0.0

For public names, within a major version:

- A name is not removed or renamed without a deprecation shim that warns once
  per session and keeps working for at least one minor release.
- A function does not lose an input or output, and does not change the meaning
  of one.
- A class does not remove or rename a public property, method, or event.
- For a class declared extensible below, the same holds for its **protected**
  members. A subclass that overrides a protected method depends on its name and
  signature exactly as a caller depends on a public one, and "not sealed" is
  otherwise an accident rather than a promise.
- Additive change is always allowed: new functions, new optional name-value
  arguments, new properties.

For `openminds.internal.*`, nothing is promised. It may change in a patch
release.

Two things sit outside this promise because they track an external source:

- **Generated metadata types** follow the openMINDS metadata model. When the
  model changes a type, the toolbox follows it. Version selection
  (`openminds.selectModelVersion`) is how a user pins this.
- **`openminds.enum.Types` and `openminds.enum.Modules`** are generated from
  the model for the same reason.

## The public surface

### Core

| Name | Role |
|---|---|
| `openminds.<module>.<Type>` | The generated metadata types |
| `openminds.Node` | Base class of every metadata type |
| `openminds.Collection` | A linked graph of nodes, saved and loaded as JSON-LD |
| `openminds.fromTypeName` | Blank instance from a type name or IRI |
| `openminds.instanceFromIRI` | Controlled-term instance from its IRI |
| `openminds.enum.Types`, `openminds.enum.Modules` | Enumerations of the active model |
| `openminds.meta.Type` | Describes a type's properties: scalar, linked, embedded, mixed |
| `openminds.meta.fromInstance`, `openminds.meta.fromClassName` | Cached lookup of the above |

### Toolbox and model version

`openminds.startup`, `openminds.selectModelVersion`, `openminds.getModelVersion`,
`openminds.version`, `openminds.toolboxdir`, `openminds.toolboxversion`,
`openminds.getpref`, `openminds.setpref`, and the top-level `code/setup.m`.

### Extension points

For projects building on the toolbox rather than only consuming it.

| Name | Role |
|---|---|
| `openminds.interface.MetadataStore` | Contract for a backing store |
| `openminds.interface.LinkResolver` | Contract for resolving external links |
| `openminds.registerLinkResolver` | Register a resolver |
| `openminds.base.*` | Base classes to subclass: `Visitor`, `Serializer`, `Deserializer`, `Transformer`, `MixedTypeSet`, `ControlledTerm` |

### Helpers

`openminds.utility.*` (predicates and name parsing), `openminds.constant.*`,
`openminds.mustBeOpenMINDSIRI`, `openminds.mustBeValidModelVersion`, and the
unpackaged validators in `code/validators`.

## The internal surface

`openminds.internal.*`. It holds the serializer and deserializer
implementations, the resolver registry, type metadata, the vocabulary, the
metadata stores, the graph and display machinery, string and file utilities,
and the schema generator.

The generator and the download helpers are internal *and* are not needed at
runtime by a user. They currently ship inside the toolbox; moving them out is
tracked separately.

## What real consumers actually use

Two projects build on this toolbox. Both were surveyed on 2026-09-04. They are
the evidence for every gap listed in the next section, and neither should have
to reach into `openminds.internal` to do its job.

**`openminds-kg-sync`** implements `interface.MetadataStore` and
`interface.LinkResolver`, and subclasses the JSON-LD serializer. It is current
with v0.10.0.

**`openMINDS-MATLAB-GUI`** subclasses `Collection` and drives a property editor
from type introspection. It is written against a pre-`Node` toolbox and much of
what it references no longer exists, so treat its usage as a statement of need
rather than a working dependency.

## Gaps: internal names that consumers depend on

Each of these is a place where the boundary above is not yet honest. Ordered by
how much it matters.

**1. Type introspection.** *Done.* `openminds.internal.meta.Type` is now
`openminds.meta.Type`, with `fromInstance` and `fromClassName` alongside it.
The two lookups came too because they are the cached path, not sugar: the
constructor builds a fresh object each call, while they return one shared
object per type, and the public `openminds.base.Serializer` already used
`fromInstance` on every node it wrote. `MetaTypeRegistry` stayed behind as
`openminds.internal.meta.MetaTypeRegistry`, since it is the cache rather than
the interface to it.

Still coupled to the mixed-type question above: `getMixedTypeForProperty`
returns `openminds.internal.mixedtype.*` class names, so a public method
returns internal names until those classes move.

**2. `Node` hides members that extenders must call.** `isReference()`,
`getLinkedInstances()`, `getEmbeddedInstances()` and the `id` property are all
`Hidden`, and kg-sync calls every one of them from its store implementation.
`isReference()` is the canonical predicate as of the merged decision to keep
references as references, so hiding it contradicts its own documentation.
`Hidden` is orthogonal to the rule: these members are already reachable without
writing `internal`, so they are already public API in the sense that matters,
and hiding them only keeps them out of tab completion and `methods` listings.
Nothing here needs promoting. What is needed is a decision about which of them
the promise covers, since a consumer calls all four.

*Recommendation: keep them Hidden except `isReference`, which is documented as
the canonical predicate and should be advertised, and state that the promise
covers Hidden members that consumers call.* Hidden is then what it should be —
public but not advertised — rather than a second, unstated boundary.
Separately, kg-sync has a blocked TODO because a store cannot write back an
identifier: `id` is `SetAccess = protected` with no public path for a store.
That is a missing affordance, not a visibility question.

**3. The `LinkResolver` contract leaks an internal type.** This is a different
problem from gap 6 below, though the two share a shape. Here the *interface*
itself is the issue. Its own help text sets out a distinction every implementer
must act on: a reference whose type is known can be populated in place, while
one whose type is not known until it is probed must be replaced, because an
instance cannot change its class. The interface then offers no public way to
tell the two apart, so kg-sync tests
`isa(instance, 'openminds.internal.MixedTypeReference')`. An interface that
documents a fork and hides the switch is incomplete.
*Recommendation: add a static predicate to the interface, not the class.* An
implementer is already reading `openminds.interface.LinkResolver` to find out
what to write, so a `LinkResolver.isTypeKnown(instance)` there is where they
will look, adds no new top-level name, and keeps `MixedTypeReference` internal.
That is step 2 rather than step 4. While there, note the interface's help text
names `openminds.internal.resolver.ResolvingVisitor` twice, once in a
`See also` — public documentation pointing at an internal class.

**4. Instance events carry an internal payload.** `Node` declares
`InstanceChanged` and `PropertyWithLinkedInstanceChanged`. Nothing in the
toolbox or its tests listens to either, which is why they had been marked
`% Todo: Remove??`; the GUI listens to both to keep its graph view live. The
TODO is now gone and both events are documented in place. What remains is that
a listener receives an
`openminds.internal.event.PropertyValueChangedEventData` — a public event
delivering an internal type. *Recommendation: document its four properties —
`NewValue`, `OldValue`, `IsLinkedProperty`, `IsPropertyOf` — in the help of the
events themselves, and treat those as the payload contract.* A listener reads
fields off the object and never names its class, so this is step 1: no
promotion, only a written-down promise.

**5. `Collection` is extensible in fact but not in promise.** Nothing stops the
GUI subclassing it: `Collection` is not sealed, so MATLAB lets a subclass
override any protected method, and the GUI overrides `addNode`. The gap is not
capability, it is coverage. The stability promise above would otherwise reach
only public members, leaving `addNode`'s name and its name-value options free to
change under a subclass that depends on them exactly as a caller depends on a
public method.

**Decided: `Collection` is extensible**, and the promise now extends to the
protected members of classes declared so. What remains is to declare which
classes those are and to write down the protected surface: `addNode`,
`addSubNodes` and `getBlankNodeIdentifier`, plus read access to `Nodes` and the
`Hidden` `TypeMap` that the GUI writes.

Two findings from checking this. The GUI overrides `onNodesSet`, which exists
nowhere in the toolbox — so that override is dead code and whatever the GUI
expected on node changes is not happening. And a GUI comment admits it is
misusing `addNode` for want of a public way to update node links, which is a
missing method rather than a visibility question.

**6. Serializer subclassing goes through an internal class.** kg-sync extends
`openminds.internal.serializer.JsonLdSerializer` and overrides its protected
post-processing hook to emit a KG-flavoured document. `openminds.base.Serializer`
is already public, so the extension point exists but the concrete class worth
extending does not.

This is the one place where step 4 may be unavoidable: subclassing requires
naming the superclass, so if extending the concrete serializer is the supported
story, the class has to be public. Rebuilding JSON-LD from the abstract base to
change one post-processing step is not a real alternative.

*Recommendation: check what kg-sync's override actually does before promoting.*
If it only reshapes the emitted documents, a public post-processing option on
the serializer — a function handle, or a documented hook on the already-public
`openminds.base.Serializer` — serves the same need at step 2 and keeps the
concrete class internal. Promote only if subclassing turns out to be doing more
than that. Either way the hook was renamed to `postProcessDocuments` by the IRI
branch, which breaks the current override; see the clean-break note below.

**7. Type name, label and IRI conversion.** The GUI calls internal name helpers
at roughly thirty sites. `openminds.enum.Types` already covers class name to
type name in both directions, which likely removes most of them, but IRI to
class name and type name to human label have no public form.
*Recommendation: add the two missing conversions to `openminds.utility`, and
document that `enum.Types` is the answer for the rest.*

**8. Reading a class constant needs `eval`.** To list a controlled term's
allowed instances or a mixed type's allowed types, the GUI evaluates a string
because MATLAB cannot read a constant off a class name directly. The toolbox
does the same thing internally. `openminds.internal.listControlledInstances`
exists but is not public.
*Recommendation: promote it and add the mixed-type equivalent.*

**9. `openminds.utility.isEmbeddedType` was removed while in use.** It was
deleted as dead code, but `openminds.utility` is declared as the namespace
"useful for external developers" and the GUI calls it at two sites. Whether or
not the GUI is current, this is a public name removed without a shim.
*Recommendation: restore it, or provide the equivalent through the
introspection API of gap 1 and deprecate the old name properly.*

**10. Label access is inconsistent.** `getDisplayLabel()` is `protected`, yet
the GUI calls it from outside the class hierarchy. `DisplayString`, which the
GUI also reads, does exist and is public — an earlier note here said otherwise
and was wrong. It is inherited from an internal mixin; see gap 11.
*Recommendation: document `string(instance)` as the one public way to get a
display label, since it is already public and already returns it.*

**11. Public classes inherit from internal ones.** Four do, `Node` included:
it inherits `internal.mixin.StructAdapter` and
`internal.mixin.CustomInstanceDisplay`, `Visitor` and `Transformer` inherit
`internal.graph.TraversalCore`, and `MixedTypeSet` inherits the display mixin
too.

**Allowed, under the rule as now stated.** A subclass author writes
`< openminds.base.Visitor` and never names the superclass, so nothing is being
asked to promise a name it does not use. No moves needed.

What does need doing is smaller and is documentation. The promise attaches to
members reachable through public names, so it already covers what these
superclasses contribute, and today that contribution is invisible from the
public side:

- `DisplayString`, `char` and `string` come from `CustomInstanceDisplay`. They
  are public API of every metadata type and are documented nowhere a user would
  look.
- `TraversalCore` gives every `Visitor` a public `reset` and eight protected
  traversal helpers — `getLinkedEdges`, `getEmbeddedEdges`, `setEdgeChildren`,
  `wasVisited`, `markVisited`, `visitedNode`, `unmarkVisited`, static `nodeKey`.
  The toolbox's own `ResolvingVisitor` calls `nodeKey`, so a subclass author
  will want them.
- Both declare abstract members a subclass must implement, so the instructions
  for writing a public subclass currently live in `openminds.internal`.

*Recommendation: document the inherited surface in the help of the public
subclass, so `help openminds.base.Visitor` tells you what to implement and what
you may call.* Treat any change to those members as a change to the public
class.


## Decisions

Settled 2026-09-04.

1. **The public surface is kept as small as it can be.** A name is internal if
   reaching it means writing `internal`, and where a member is declared does not
   enter into it. Gaps are closed with the smallest affordance that removes the
   need to write an internal name; promotion is the last resort, not the first.
2. **Type introspection is public**, as `openminds.meta.Type` with
   `fromInstance` and `fromClassName`. Done. It earned step 4 because callers
   construct it by name.
3. **Generated mixed types stay internal.** All 1520 of them. What leaks is
   observation, and `openminds.utility.isMixedInstance` already covers the one
   real check.
4. **Internal superclasses are allowed.** `Node`, `Visitor`, `Transformer` and
   `MixedTypeSet` keep theirs. Their inherited members are covered by the
   promise and want documenting on the public subclass.
5. **`Collection` is extensible**, and the promise covers the protected members
   of classes declared extensible.
6. **v1.0.0 is the clean break.** No deprecation shims for anything the rename
   series changed.

### What the clean break commits us to

The shims stop being a question, but the communication does not. Nothing warns
a consumer that a name moved, so the release notes carry the whole burden, and
the substitution list has to be complete. Both surveyed projects will hit it:
kg-sync on `getUnresolvedLinks` becoming `getUnresolvedLinkIdentifiers` and
`postProcessInstances` becoming `postProcessDocuments`, the GUI on most of the
internal names it uses.

It also settles a smaller question by implication. `Node.isUnresolved` is the
one deprecation shim in the toolbox, warning once per session and forwarding to
`isReference`. A clean break at 1.0 is the moment to delete it rather than
carry it into a version whose whole point is that the names are now fixed.

## Still open

- **Whether the JSON-LD serializer has to be promoted**, or whether a public
  post-processing hook serves kg-sync. Needs a look at what its override does.
  This is the only remaining candidate for step 4.
- Whether store implementers traverse the graph through public `Node` methods
  or a separate visitor-shaped API. Gap 2's second half.
- Whether the promise covers Hidden members that consumers call. Recommended
  yes, but it decides how `id`, `getLinkedInstances` and `getEmbeddedInstances`
  are treated.

## What this leaves to do

Nothing on this list is a move. In rough order of value:

1. Document the inherited surface on `Node`, `Visitor`, `Transformer` and
   `MixedTypeSet`, including the abstract members a subclass must implement.
2. Add `LinkResolver.isTypeKnown`, and stop the interface's help pointing at
   internal classes.
3. Document the event payload's four properties as the contract.
4. Document `getMixedTypeForProperty`'s result as a handle, not a name to
   construct from.
5. Restore or replace `openminds.utility.isEmbeddedType`, removed while in use.
6. Un-hide `isReference`.
7. Settle the serializer question above.
