#!/bin/zsh

# ========= colors =========
GREEN=$'\033[32m'
RED=$'\033[31m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
RESET=$'\033[0m'

set -u

if [ $# -lt 1 ]; then
  echo "Usage: runsample <problem-name>"
  exit 1
fi

NAME="$1"

# Prefer .cpp, fallback to .cc
if [ -f "${NAME}.cpp" ]; then
  SRC="${NAME}.cpp"
else
  SRC="${NAME}.cc"
fi

TEST_DIR="tests/${NAME}"

if [ ! -d "$TEST_DIR" ]; then
  echo "No test directory found: $TEST_DIR"
  exit 1
fi

# Create temporary binary (to avoid clutter)
BIN="$(mktemp -t ${NAME}.bin.XXXXXX)"

# Cleanup temporary files on exit
cleanup() {
  rm -f "$BIN"
  rm -rf "${BIN}.dSYM"
}
trap cleanup EXIT

if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC"
  exit 1
fi

echo "[DEBUG MODE] Compiling $SRC with c++23."
if ! g++ "$SRC" \
  -std=c++23 \
  -O2 \
  -Wall -Wextra -pedantic \
  -DLOCAL \
  -D_GLIBCXX_DEBUG \
  -g \
  -o "$BIN"; then
  echo "${RED}Compile Error!${RESET}"
  exit 1
fi

passed=0
total=0
found_test=0

print_file_block() {
  local file=$1
  python3 - "$file" <<'PY2'
import sys
from pathlib import Path
path = Path(sys.argv[1])
data = path.read_bytes()
sys.stdout.buffer.write(data)
if not data.endswith(b'\n'):
    sys.stdout.write('\n')
PY2
}

files_match() {
  local left=$1
  local right=$2
  python3 - "$left" "$right" <<'PY2'
import sys
from pathlib import Path
left = Path(sys.argv[1]).read_bytes().rstrip(b'\n')
right = Path(sys.argv[2]).read_bytes().rstrip(b'\n')
sys.exit(0 if left == right else 1)
PY2
}

for infile in "$TEST_DIR"/*.in(N); do
  found_test=1
  total=$((total + 1))

  base="${infile%.in}"
  outfile="${base}.out"
  tmpfile="$(mktemp)"
  timefile="$(mktemp)"

  echo "Running ${NAME}-${total}.in:"

  set +e
  /usr/bin/time -l "$BIN" < "$infile" > "$tmpfile" 2> "$timefile"
  exit_code=$?
  set -e

  # ===== extract execution time =====
  real_time=$(grep -E '^[[:space:]]*[0-9.]+[[:space:]]+real' "$timefile" | awk '{print $1}')
  [ -z "$real_time" ] && real_time="0.000"

  # ===== extract memory usage =====
  max_rss=$(grep "maximum resident set size" "$timefile" | awk '{print $1}')
  if [ -z "$max_rss" ]; then
    mem_text="0 KB"
  else
    mem_kb=$((max_rss / 1024))
    mem_text="${mem_kb} KB"
  fi

  echo "Memory: $mem_text"
  echo "Time: ${real_time}s"
  echo "-------------"

  echo "${BLUE}Output:${RESET}"
  print_file_block "$tmpfile"
  echo "-------------"

  echo "${BLUE}Expected:${RESET}"
  if [ -f "$outfile" ]; then
    print_file_block "$outfile"
  else
    echo "(no expected file)"
  fi
  echo "-------------"

  # Runtime error handling
  if [ $exit_code -ne 0 ]; then
    echo "${YELLOW}⚠ Runtime Error!${RESET}"
    echo
    rm -f "$tmpfile" "$timefile"
    continue
  fi

  # Compare output with expected
  if [ -f "$outfile" ] && files_match "$tmpfile" "$outfile"; then
    echo "${GREEN}✔ Passed!${RESET}"
    passed=$((passed + 1))
  else
    echo "${RED}✖ Failed!${RESET}"
  fi

  echo
  rm -f "$tmpfile" "$timefile"
done

# No test files case
if [ $found_test -eq 0 ]; then
  echo "No test files found in $TEST_DIR"
  exit 1
fi

# Final result summary
if [ $passed -eq $total ]; then
  echo "${GREEN}$passed / $total tests passed!${RESET}"
else
  echo "${RED}$passed / $total tests passed!${RESET}"
fi