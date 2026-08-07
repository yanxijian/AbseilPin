# Unification roadmap (AbseilPin → in-process PDF)

Stages aligned with the Volition discussion.

## Stage 1 (this repo + MPS) — version alignment landed

1. Build the **`20260107.1`** prefix here (matches pdfium_all lock).  
2. MPS: `protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` → `find_package(absl)`; no second abseil build.  
3. Auto-detect `../AbseilPin/prefix/20260107.1` when the sibling tree exists.  
4. Volition does **not** fold pdfium back yet; keep `volition_pdf_render` until one-abseil / ABI checks pass.

Acceptance: Demo / Volition Host directories contain **one** pin-built `abseil_dll.dll`.

## Stage 1b — ABI / toolchain (current gap)

Version tags can match **20260107.1**, but:

| Item | MPS / AbseilPin | pdfium_all (typical) |
|------|-----------------|----------------------|
| Compiler | MSVC `cl` | Prefer **clang-cl** |
| C++ | **17** | **20** (`cxx_std_20`) |
| STL | MSVC STL | Chromium **libc++** when V8 is on |
| Abseil source | AbseilPin `/MD` DLL | vcpkg or FetchContent (CMake still has a `20250127.0` fallback tag) |

Before in-process merge: rebuild pdfium **without V8** against AbseilPin / the same MSVC pin, or keep OOP render.

## Stage 2 — Volition in-process PDF

Prerequisite: pdfium and `mps_*` share **the same pin and the same STL ABI** for `abseil_dll.dll`.

1. Link pdfium directly from `volition_pdf.dll` (delay-load OK).  
2. Retire day-to-day `volition_pdf_render.exe` (optional debug switch OK).  
3. Keep a single abseil under `bin/pdf/`.

## Stage 3 (optional)

For load-failure isolation only: a thin `pdfium_adapter.dll` that still **must** share the Client’s pin abseil (no second copy).
