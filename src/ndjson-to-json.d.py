#!/usr/bin/env python3
import dataclasses
import fileinput
import json
import pathlib


@dataclasses.dataclass(frozen=True, slots=True)
class NdjsonLine:
    content: dict
    filename: str


def main():
    for input_line in fileinput.input():
        json_line = NdjsonLine(**json.loads(input_line))
        output_line = json.dumps(
            json_line.content,
            ensure_ascii=False,
            separators=(",", ":"),
            sort_keys=True,
        )
        pathlib.Path(json_line.filename).write_text(output_line)


if __name__ == "__main__":
    main()
