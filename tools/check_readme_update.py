#!/usr/bin/env python3
"""Require README changes alongside implementation changes; uses only stdlib/Git."""

import argparse
import json
from pathlib import PurePosixPath, Path
import subprocess
import sys


def git(*args):
    return subprocess.check_output(["git", *args])


def implementation_path(path):
    # Documentation-only edits do not require a redundant README edit.
    return not (path.startswith("docs/") or PurePosixPath(path).suffix.lower() == ".md")


def check(base, head):
    # Disable rename detection so a move out of a source directory is still seen.
    paths = git("diff", "--name-only", "--no-renames", "-z", base, head).decode().split("\0")
    changed = [path for path in paths if path and implementation_path(path)]
    if not changed:
        print("PASS: documentation-only change.")
        return 0
    readme_diff = git("diff", "--ignore-all-space", base, head, "--", "README.md")
    try:
        readme = git("show", f"{head}:README.md").strip()
    except subprocess.CalledProcessError:
        readme = b""
    if not readme or not readme_diff:
        print("FAIL: implementation changed without a substantive README.md edit:", file=sys.stderr)
        for path in changed:
            print(f"  {path}", file=sys.stderr)
        print("Update the relevant walkthrough sections or Maintenance notes in the same change set.", file=sys.stderr)
        return 1
    print("PASS: README.md accompanies implementation changes. Review accuracy manually.")
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("base", nargs="?")
    parser.add_argument("head", nargs="?", default="HEAD")
    parser.add_argument("--event", type=Path, help="GitHub push or pull_request event JSON")
    args = parser.parse_args()
    if args.event:
        event = json.loads(args.event.read_text())
        if "pull_request" in event:
            pr = event["pull_request"]
            head = pr["head"]["sha"]
            base = git("merge-base", pr["base"]["sha"], head).decode().strip()
        elif event.get("deleted"):
            print("PASS: branch deletion has no implementation to review.")
            return 0
        else:
            base, head = event["before"], event["after"]
            if set(base) == {"0"}:
                # A new branch/ref is checked as a complete initial tree.
                base = subprocess.check_output(
                    ["git", "hash-object", "-t", "tree", "--stdin"], input=b""
                ).decode().strip()
    else:
        if not args.base:
            parser.error("provide a base commit or --event")
        base, head = args.base, args.head
    return check(base, head)


if __name__ == "__main__":
    sys.exit(main())
