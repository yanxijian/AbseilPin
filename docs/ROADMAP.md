# 统一路线（AbseilPin → 同进程 PDF）

对应 Volition 讨论的阶段划分。

## 阶段 1（本仓 + MPS）— 进行中

1. 本仓编出 **`20240116.0`** prefix（与 protobuf v29.3 匹配）。  
2. MPS：`MPS_ABSEIL_PIN_PREFIX` → `protobuf_ABSL_PROVIDER=package`。  
3. Volition **暂不**并回 pdfium；继续 `volition_pdf_render` 旁路。

验收：Demo/Volition Host 旁只有 **一份** 来自 pin 的 `abseil_dll.dll`（protobuf 不再另编）。

## 阶段 1b — 选统一 LTS

两条路 **二选一**（需单独验证）：

| 路线 | 动作 | 风险 |
|------|------|------|
| **B1（推荐倾向）** | 升 MPS protobuf 到自带 / 支持 **≥20250127** 的版本，再评估能否贴到 **20260107.1** | protobuf 大版本升级 |
| **B2** | pdfium_all 改链 / 降级到 **20240116.0** | pdfium/V8/工具链可能拒编 |

选定后：本仓 `active` pin 改为该 ID；pdfium_all 部署目录 **删除** 自带 `abseil_dll.dll`。

## 阶段 2 — Volition 同进程 PDF

前提：pdfium 与 `mps_*` 依赖 **同一 pin 的** `abseil_dll.dll`。

1. `volition_pdf.dll` 直接链接 pdfium（可 delay-load）。  
2. 退役日常路径上的 `volition_pdf_render.exe`（可留 debug 开关）。  
3. `bin/pdf/` 只保留一份 abseil。

## 阶段 3（可选）

若只要加载失败隔离：浅 `pdfium_adapter.dll`，但仍必须与 Client **共用** pin 的 abseil（禁止第二份）。
