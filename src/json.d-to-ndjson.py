#!/usr/bin/env python3
import json
import pathlib
import sys


def main():
    assert len(sys.argv) == 2, f"{sys.argv[0]} <directory>"
    directory = sys.argv[1]
    for p in pathlib.Path(directory).rglob("*"):
        if p.is_file():
            ndjson = {
                "content": json.loads(p.read_text()),
                "filename": str(p),
            }
            line = json.dumps(
                ndjson,
                ensure_ascii=False,
                separators=(",", ":"),
                sort_keys=True,
            )
            print(line)


if __name__ == "__main__":
    main()
