#!/usr/bin/env -S jq -f
.nodes
|
with_entries(
    select(
        .value
        |
        .locked != null and .original != null
    )
    |
    {
        "key": (
            .value.original
            |
            .type + ":" + .owner + "/" + .repo + (
                if .ref then
                    "/" + .ref
                else
                    ""
                end
            )
        ),
        "value": (
            .value.locked
            |
            .type + ":" + .owner + "/" + .repo + "/" + .rev
        ),
    }
)