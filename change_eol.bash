#!/bin/bash
git config core.eol lf
git config core.autocrlf input
# git add --renormalize .
find . -type f \( -name "*.sh" -o -name "*.bash" \) -exec git add --renormalize {} \;
git commit -m "Change line endings to LF"
