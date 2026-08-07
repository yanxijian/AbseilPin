# 统一路线（AbseilPin → 同进程 PDF）

对应 Volition 讨论的阶段划分。

## 阶段 1（本仓 + MPS）— 已落地版本对齐

1. 本仓编出 **`20260107.1`** prefix（与 pdfium_all lock 一致）。  
2. MPS：`protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` → `find_package(absl)`，不再另编 abseil。  
3. 旁路存在时自动探测 `../AbseilPin/prefix/20260107.1`。  
4. Volition **暂不**并回 pdfium；继续 `volition_pdf_render` 旁路，直到 ABI/进程内一份 abseil 验收通过。

验收：Demo/Volition Host 旁只有 **一份** 来自 pin 的 `abseil_dll.dll`。

## 阶段 1b — VolitionToolchain（进行中）

全栈契约见 Volition `docs/zh/toolchain.md`：

| 项 | 值 |
|----|-----|
| C++ | **20**（壳与 pdfium 一致；不再把 pdfium 降到 17） |
| Windows 编译器 | **MSVC `cl`** + `/MD` |
| Abseil | AbseilPin **`20260107.1`** |
| pdfium 同进程 | **`PDFIUM_ENABLE_V8=OFF`**（开 V8 仍为 libc++，与壳冲突） |

缺口：pdfium fork（`volition-toolchain`）用 `cl` 编通产品路径，并默认接本仓 pin。

## 阶段 2 — Volition 同进程 PDF

前提：pdfium 与 `mps_*` 依赖 **同一 pin 且同一 STL ABI** 的 `abseil_dll.dll`。

1. `volition_pdf.dll` 直接链接 pdfium（可 delay-load）。  
2. 退役日常路径上的 `volition_pdf_render.exe`（可留 debug 开关 `VOLITION_PDF_OOP_RENDER` + `VOLITION_PDF_OOP=1`）。  
3. `bin/` 只保留一份 abseil。

落地要点：pdfium / MPS 均 **FORCE `absl_DIR` 到本仓 pin**（避免 vcpkg 缓存抢走）；`pdfium_all/output` 必须用 **V8=OFF** 的 `cmake-msvc` 重新 stage。

## 阶段 3（可选）

若只要加载失败隔离：浅 `pdfium_adapter.dll`，但仍必须与 Client **共用** pin 的 abseil（禁止第二份）。
