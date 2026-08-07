# 统一路线（AbseilPin → 同进程 PDF）

对应 Volition 讨论的阶段划分。

## 阶段 1（本仓 + MPS）— 已落地版本对齐

1. 本仓编出 **`20260107.1`** prefix（与 pdfium_all lock 一致）。  
2. MPS：`protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` → `find_package(absl)`，不再另编 abseil。  
3. 旁路存在时自动探测 `../AbseilPin/prefix/20260107.1`。  
4. Volition **暂不**并回 pdfium；继续 `volition_pdf_render` 旁路，直到 ABI/进程内一份 abseil 验收通过。

验收：Demo/Volition Host 旁只有 **一份** 来自 pin 的 `abseil_dll.dll`。

## 阶段 1b — ABI / 工具链（当前缺口）

版本号已可贴 **20260107.1**，但：

| 项 | MPS / AbseilPin | pdfium_all（典型） |
|----|-----------------|-------------------|
| 编译器 | MSVC `cl` | 推荐 **clang-cl** |
| C++ | **17** | **20**（`cxx_std_20`） |
| STL | MSVC STL | 开 V8 时为 Chromium **libc++** |
| Abseil 来源 | AbseilPin `/MD` DLL | vcpkg 或 FetchContent（CMake 内仍见 `20250127.0` 回退 tag） |

同进程合并前建议：pdfium **关 V8** + 显式链 AbseilPin / 同 pin 的 MSVC abseil，或接受继续 OOP render。

## 阶段 2 — Volition 同进程 PDF

前提：pdfium 与 `mps_*` 依赖 **同一 pin 且同一 STL ABI** 的 `abseil_dll.dll`。

1. `volition_pdf.dll` 直接链接 pdfium（可 delay-load）。  
2. 退役日常路径上的 `volition_pdf_render.exe`（可留 debug 开关）。  
3. `bin/pdf/` 只保留一份 abseil。

## 阶段 3（可选）

若只要加载失败隔离：浅 `pdfium_adapter.dll`，但仍必须与 Client **共用** pin 的 abseil（禁止第二份）。
