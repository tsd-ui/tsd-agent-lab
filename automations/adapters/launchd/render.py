#!/usr/bin/env python3
"""Render LaunchDaemon plists from job YAML definitions and a template."""

import os
import re
import sys

REPO_ROOT = "/Users/agent-lab/tsd-agent-lab"


def parse_yaml_simple(path):
    """Minimal YAML parser for flat and one-level-nested key-value pairs."""
    result = {}
    current_section = None
    with open(path) as f:
        for line in f:
            stripped = line.rstrip()
            if not stripped or stripped.startswith("#"):
                continue
            indent = len(line) - len(line.lstrip())
            if indent == 0:
                if stripped.endswith(":"):
                    current_section = stripped[:-1]
                    result[current_section] = {}
                else:
                    m = re.match(r"^(\w[\w-]*): *(.*)", stripped)
                    if m:
                        key, val = m.group(1), m.group(2)
                        val = val.strip().strip("\"'")
                        if val == "true":
                            val = True
                        elif val == "false":
                            val = False
                        elif val.isdigit():
                            val = int(val)
                        elif val.startswith("[") and val.endswith("]"):
                            items = val[1:-1].split(",")
                            val = [i.strip().strip("\"'") for i in items if i.strip()]
                        result[key] = val
                        current_section = None
            elif indent > 0 and current_section is not None:
                m = re.match(r"^\s+(\w[\w-]*): *(.*)", stripped)
                if m:
                    key, val = m.group(1), m.group(2)
                    val = val.strip().strip("\"'")
                    if val == "true":
                        val = True
                    elif val == "false":
                        val = False
                    elif val.isdigit():
                        val = int(val)
                    elif val.startswith("[") and val.endswith("]"):
                        items = val[1:-1].split(",")
                        val = [i.strip().strip("\"'") for i in items if i.strip()]
                    if isinstance(result.get(current_section), dict):
                        result[current_section][key] = val
    return result


def render_schedule(job):
    schedule = job.get("schedule", {})
    stype = schedule.get("type", "calendar")
    if stype == "calendar":
        hour = schedule.get("hour", 0)
        minute = schedule.get("minute", 0)
        return (
            "    <key>StartCalendarInterval</key>\n"
            "    <dict>\n"
            f"        <key>Hour</key>\n"
            f"        <integer>{hour}</integer>\n"
            f"        <key>Minute</key>\n"
            f"        <integer>{minute}</integer>\n"
            "    </dict>"
        )
    elif stype == "interval":
        seconds = schedule.get("seconds", 600)
        return (
            "    <key>StartInterval</key>\n"
            f"    <integer>{seconds}</integer>"
        )
    return ""


def render_plist(template, job):
    name = job.get("name", "")
    label = job.get("label", f"com.tsd-agent-lab.{name}")
    log_name = job.get("log_name", name)
    run_at_load = "true" if job.get("run_at_load", False) else "false"
    schedule_xml = render_schedule(job)

    result = template
    result = result.replace("{{label}}", label)
    result = result.replace("{{name}}", name)
    result = result.replace("{{repo_root}}", REPO_ROOT)
    result = result.replace("{{log_name}}", log_name)
    result = result.replace("{{run_at_load}}", run_at_load)
    result = result.replace("{{schedule}}", schedule_xml)
    return result


def main():
    if len(sys.argv) < 3:
        print("Usage: render.py <jobs-dir> <output-dir>", file=sys.stderr)
        sys.exit(1)

    jobs_dir = sys.argv[1]
    output_dir = sys.argv[2]

    template_path = os.path.join(os.path.dirname(__file__), "template.plist")
    with open(template_path) as f:
        template = f.read()

    os.makedirs(output_dir, exist_ok=True)

    for fname in sorted(os.listdir(jobs_dir)):
        if not fname.endswith(".yaml"):
            continue
        job_path = os.path.join(jobs_dir, fname)
        job = parse_yaml_simple(job_path)
        label = job.get("label", "")
        if not label:
            print(f"SKIP: {fname} — no label", file=sys.stderr)
            continue

        plist_content = render_plist(template, job)
        out_path = os.path.join(output_dir, f"{label}.plist")
        with open(out_path, "w") as f:
            f.write(plist_content)
        print(f"  rendered {os.path.basename(out_path)}")


if __name__ == "__main__":
    main()
