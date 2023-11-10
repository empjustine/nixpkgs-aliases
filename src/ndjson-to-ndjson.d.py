#!/usr/bin/env python3
import dataclasses
import fileinput
import json
import pathlib
import sys


@dataclasses.dataclass(frozen=True, slots=True)
class NdjsonLine:
    content: dict
    filename: str


def main():
    with fileinput.input(encoding="utf8") as lines:
        for input_line in lines:
            try:
                json_line = NdjsonLine(**json.loads(input_line))
                output_line = json.dumps(
                    json_line.content,
                    ensure_ascii=False,
                    separators=(",", ":"),
                    sort_keys=True,
                )
                pathlib.Path(json_line.filename).write_text(output_line + "\n")
            except:
                err_line = json.dumps(
                    {
                        "raw_content": input_line,
                        "err": "invalid json",
                    },
                    ensure_ascii=False,
                    separators=(",", ":"),
                    sort_keys=True,
                )
                sys.stderr.write(err_line)


if __name__ == "__main__":
    main()
