"""Python side of the openMINDS_MATLAB interoperability test.

Builds a collection from the shared fixture specification with the Python
reference implementation, round-trips a JSON-LD file through it, and
compares two JSON-LD collection documents structurally.

    openminds_interop.py build     SPEC.json  OUT.jsonld
    openminds_interop.py roundtrip IN.jsonld  OUT.jsonld
    openminds_interop.py compare   A.jsonld   B.jsonld
    openminds_interop.py normalize IN.jsonld

The comparison normalizes only what may legitimately differ between two
implementations: blank node labels, the order of keys, and the order of
nodes in the graph. Everything else is compared as written, so a property
written as a list by one implementation and as a scalar by the other is
reported as a difference.

Exit status: 0 same, 1 different, 2 error.
"""

import copy
import difflib
import json
import sys
from datetime import date, datetime
from importlib import import_module

TYPE_IRI_BASE = "https://openminds.om-i.org/types/"
MODEL_VERSION = "latest"


# ---------------------------------------------------------------- build

def build(spec_path, out_path):
    from openminds import Collection
    from openminds.registry import lookup_type

    # Types register on import of their version module
    import_module("openminds." + MODEL_VERSION)

    with open(spec_path, encoding="utf-8") as spec_file:
        spec = json.load(spec_file)

    nodes_by_key = {}

    def resolve(value):
        if isinstance(value, list):
            return [resolve(item) for item in value]
        if not isinstance(value, dict):
            return value
        if "$ref" in value:
            return nodes_by_key[value["$ref"]]
        if "$instance" in value:
            return controlled_instance(value["$instance"])
        if "$embedded" in value:
            return instantiate(value["$embedded"], value["properties"])
        if "$date" in value:
            return date.fromisoformat(value["$date"])
        if "$datetime" in value:
            return datetime.fromisoformat(value["$datetime"])
        raise ValueError(f"Unknown value object: {value}")

    def instantiate(type_name, properties):
        cls = lookup_type(TYPE_IRI_BASE + type_name, version=MODEL_VERSION)
        attribute_names = {p.path: p.name for p in cls.properties}
        kwargs = {}
        for schema_name, value in properties.items():
            if schema_name not in attribute_names:
                raise KeyError(f"{type_name} has no property {schema_name}")
            kwargs[attribute_names[schema_name]] = resolve(value)
        return cls(**kwargs)

    def controlled_instance(iri):
        type_name = iri.split("/instances/")[1].split("/")[0]
        type_name = type_name[0].upper() + type_name[1:]
        cls = lookup_type(TYPE_IRI_BASE + type_name, version=MODEL_VERSION)
        for instance in cls.instances():
            if instance.id == iri:
                return instance
        raise KeyError(f"No controlled instance with IRI {iri}")

    for node in spec["nodes"]:
        nodes_by_key[node["key"]] = instantiate(node["type"], node["properties"])

    Collection(*nodes_by_key.values()).save(out_path)


# ------------------------------------------------------------ roundtrip

def roundtrip(in_path, out_path):
    from openminds import Collection

    collection = Collection()
    collection.load(in_path, version=MODEL_VERSION)
    collection.save(out_path)


# -------------------------------------------------------------- compare

def load_document(path):
    with open(path, encoding="utf-8") as document_file:
        return json.load(document_file)


def is_blank(identifier):
    return isinstance(identifier, str) and identifier.startswith("_:")


def rewrite_ids(value, mapping):
    """Replace every blank node @id in value using mapping, recursively."""
    if isinstance(value, list):
        return [rewrite_ids(item, mapping) for item in value]
    if isinstance(value, dict):
        result = {}
        for key, item in value.items():
            if key == "@id" and is_blank(item):
                result[key] = mapping[item]
            else:
                result[key] = rewrite_ids(item, mapping)
        return result
    return value


def normalize(document):
    """Relabel blank nodes by content and sort keys and nodes.

    A node's signature is its content with every blank node label
    replaced by a placeholder. Nodes are sorted by signature and labelled
    in that order, so two documents holding the same graph get the same
    labels whatever the original ones were. Two nodes with the same
    signature cannot be told apart, and the fixture must avoid that.
    """
    document = copy.deepcopy(document)
    graph = document.get("@graph")
    if graph is None:
        graph = [{k: v for k, v in document.items() if k != "@context"}]
    else:
        graph = list(graph)

    placeholder = {}
    signatures = []
    for node in graph:
        blank_ids = collect_blank_ids(node)
        signature = json.dumps(
            rewrite_ids(node, {b: "_:" for b in blank_ids}), sort_keys=True,
            ensure_ascii=False)
        signatures.append(signature)

    duplicates = {s for s in signatures if signatures.count(s) > 1}
    if duplicates:
        raise ValueError(
            "Nodes with identical content cannot be relabelled unambiguously:\n"
            + "\n".join(sorted(duplicates)))

    order = sorted(range(len(graph)), key=lambda i: signatures[i])
    mapping = {}
    for label_index, node_index in enumerate(order):
        node_id = graph[node_index].get("@id")
        if is_blank(node_id):
            mapping[node_id] = f"_:n{label_index}"

    # A reference to a blank node that has no node of its own keeps a
    # stable label too, so the difference shows as a dangling reference
    # rather than a crash.
    for node in graph:
        for blank_id in collect_blank_ids(node):
            mapping.setdefault(blank_id, "_:dangling:" + blank_id)

    normalized_graph = [rewrite_ids(graph[i], mapping) for i in order]
    normalized = {"@context": document.get("@context"), "@graph": normalized_graph}
    return json.loads(json.dumps(normalized, sort_keys=True, ensure_ascii=False))


def collect_blank_ids(value, found=None):
    if found is None:
        found = []
    if isinstance(value, list):
        for item in value:
            collect_blank_ids(item, found)
    elif isinstance(value, dict):
        for key, item in value.items():
            if key == "@id" and is_blank(item):
                found.append(item)
            else:
                collect_blank_ids(item, found)
    return found


def compare(a_path, b_path):
    a = normalize(load_document(a_path))
    b = normalize(load_document(b_path))
    if a == b:
        print(f"Same graph: {a_path} and {b_path}")
        return 0

    a_text = json.dumps(a, indent=2, sort_keys=True, ensure_ascii=False).splitlines()
    b_text = json.dumps(b, indent=2, sort_keys=True, ensure_ascii=False).splitlines()
    diff = difflib.unified_diff(a_text, b_text, fromfile=a_path, tofile=b_path, lineterm="")
    print("\n".join(diff))
    return 1


# ----------------------------------------------------------------- main

def main(argv):
    try:
        command, *args = argv
        if command == "build":
            build(*args)
        elif command == "roundtrip":
            roundtrip(*args)
        elif command == "compare":
            return compare(*args)
        elif command == "normalize":
            print(json.dumps(normalize(load_document(args[0])), indent=2,
                             sort_keys=True, ensure_ascii=False))
        else:
            raise ValueError(f"Unknown command {command}")
        return 0
    except Exception as error:  # noqa: BLE001 - reported to the caller as text
        print(f"{type(error).__name__}: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
