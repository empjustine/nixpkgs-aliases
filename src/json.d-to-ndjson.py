#!/usr/bin/env python3
import json
import pathlib
import sys


def main():
    assert len(sys.argv) == 2, f"{sys.argv[0]} <directory>"
    directory = sys.argv[1]
    for p in pathlib.Path(directory).rglob("*"):
        if p.is_file():
            raw_content = p.read_text()
            try:
                ok_json = json.loads(raw_content)
                ok_line = json.dumps(
                    {
                        "content": ok_json,
                        "filename": str(p),
                    },
                    ensure_ascii=False,
                    separators=(",", ":"),
                    sort_keys=True,
                )
                sys.stdout.write(ok_line + "\n")
            except:
                err_line = json.dumps(
                    {
                        "raw_content": raw_content,
                        "err": "invalid json",
                        "filename": str(p),
                    },
                    ensure_ascii=False,
                    separators=(",", ":"),
                    sort_keys=True,
                )
                sys.stderr.write(err_line + "\n")


if __name__ == "__main__":
    main()
