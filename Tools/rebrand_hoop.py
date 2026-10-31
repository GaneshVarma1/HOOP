#!/usr/bin/env python3
"""Refresh standalone app-name prose without changing persistent identifiers.

Run from the repository root. Source history and license notices are intentionally
left alone; package names, bundle IDs, backup formats, and URL schemes must remain
compatible with existing installations.
"""

from __future__ import annotations

import pathlib
import json
import re
import subprocess


ROOT = pathlib.Path(__file__).resolve().parents[1]
TEXT_SUFFIXES = {
    ".swift", ".kt", ".kts", ".xml", ".xcstrings", ".md", ".yml",
    ".json", ".py", ".sh", ".svg", ".plist", ".html", ".pro", ".txt",
}
PROTECTED_FILES = {"LICENSE", "NOTICE", "ATTRIBUTION.md", "CHANGELOG.md", "altstore-source.json", "rebrand_hoop.py"}
NAME = re.compile(r"(?<![\w./-])(?:NOOP|Noop)(?![\w/-]|\.[A-Za-z0-9])")
GERMAN_POSSESSIVE = re.compile(r"(?<![\w./-])NOOPs(?![\w/-]|\.[A-Za-z0-9])")
PROTECTED_LINE = re.compile(r"NoopApp|ryanbr/noop|original NOOP|NOOP\.app|NOOP/|NOOP-iOS|enum class SleepStagePalette")


def main() -> None:
    tracked = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT).split(b"\0")
    files_changed = 0
    replacements = 0
    for raw in tracked:
        if not raw:
            continue
        relative = pathlib.Path(raw.decode())
        if relative.name in PROTECTED_FILES or relative.suffix not in TEXT_SUFFIXES:
            continue
        # Oracle samples and archived translations record historical input, not app UI.
        if "Tests" in relative.parts or "test" in relative.parts or "Resources" in relative.parts and relative.suffix == ".json":
            continue
        path = ROOT / relative
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        changed_lines = []
        for line in original.splitlines(keepends=True):
            if PROTECTED_LINE.search(line):
                changed_lines.append(line)
                continue
            changed, genitive_count = GERMAN_POSSESSIVE.subn("HOOPs", line)
            changed, count = NAME.subn("HOOP", changed)
            changed_lines.append(changed)
            replacements += count + genitive_count
        updated = "".join(changed_lines)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            files_changed += 1
    # Prior releases are another project's binaries. Keep a valid source shell,
    # but list no app until this repository publishes its own IPA.
    source_path = ROOT / "altstore-source.json"
    source = {
        "name": "HOOP",
        "identifier": "com.ganeshvarma1.hoop.altstore",
        "sourceURL": "https://raw.githubusercontent.com/GaneshVarma1/HOOP/main/altstore-source.json",
        "subtitle": "Your strap, your data, your phone.",
        "description": "HOOP is an independent, on-device companion for compatible WHOOP straps. App downloads will appear here after a HOOP release is published.",
        "iconURL": "https://raw.githubusercontent.com/GaneshVarma1/HOOP/main/docs/assets/hoop/hoop-logo-dark.png",
        "website": "https://github.com/GaneshVarma1/HOOP",
        "tintColor": "2257D6",
        "apps": [],
    }
    source_text = json.dumps(source, ensure_ascii=False, indent=2) + "\n"
    if source_path.read_text(encoding="utf-8") != source_text:
        source_path.write_text(source_text, encoding="utf-8")
        files_changed += 1
    print(f"Updated {replacements} app-name mentions in {files_changed} tracked text files.")


if __name__ == "__main__":
    main()
