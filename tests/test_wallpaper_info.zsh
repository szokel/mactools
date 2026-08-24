#!/bin/zsh

set -eu

readonly project_directory="${0:A:h:h}"
readonly command_path="$project_directory/bin/mi-ez-a-hatterkep"
test_directory="$(mktemp -d "${TMPDIR:-/tmp}/mactools-test.XXXXXX")"
trap '/bin/rm -rf -- "$test_directory"' EXIT

manifest="$test_directory/entries.json"
video_directory="$test_directory/videos"
/bin/mkdir -p "$video_directory"

/usr/bin/printf '%s\n' '{"assets":[{"id":"TEST-ASSET","accessibilityLabel":"Test Landscape","shotID":"TEST-SHOT"}]}' > "$manifest"
/usr/bin/touch "$video_directory/TEST-ASSET.mov"

export MACTOOLS_ALLOW_NON_MACOS=1
export MACTOOLS_WALLPAPER_MANIFEST="$manifest"
export MACTOOLS_WALLPAPER_VIDEO_DIRECTORY="$video_directory"
export MACTOOLS_ACTIVE_VIDEO="$video_directory/TEST-ASSET.mov"

failures=0

assert_equal() {
  local expected="$1"
  local actual="$2"
  local description="$3"

  if [[ "$actual" == "$expected" ]]; then
    print "ok - $description"
  else
    print -u2 "not ok - $description"
    print -u2 "  expected: $expected"
    print -u2 "  actual:   $actual"
    failures=$((failures + 1))
  fi
}

text_output="$($command_path)"
assert_equal "Aktuális háttérkép: Test Landscape" "$text_output" "prints the wallpaper name"

details_output="$($command_path --details)"
if [[ "$details_output" == *"Asset ID: TEST-ASSET"* && "$details_output" == *"Shot ID: TEST-SHOT"* ]]; then
  print "ok - prints detailed metadata"
else
  print -u2 "not ok - prints detailed metadata"
  failures=$((failures + 1))
fi

json_name="$($command_path --json | /usr/bin/python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])')"
assert_equal "Test Landscape" "$json_name" "prints valid JSON"

version_output="$($command_path --version)"
assert_equal "mi-ez-a-hatterkep 0.1.0" "$version_output" "prints the version"

if (( failures > 0 )); then
  print -u2 "$failures test(s) failed"
  exit 1
fi

print "All tests passed"
