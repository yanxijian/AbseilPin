# Pin 矩阵

## 现场实测（2026-08-08）

| 消费方 | 依赖 | 其树内 / lock 的 Abseil |
|--------|------|-------------------------|
| MultiProcessShell | FetchContent `protobuf` **v29.3** | submodule tag **`20240116.0`**（`4a2c6336…`） |
| pdfium_all | `deps.lock.md` → `thirdparty/abseil-cpp` | **`20260107.1`**（`255c84d…`） |

两者 **不是** 同一 LTS；不能靠「拷贝其中一个 DLL」让两边同时正确。

## 本仓 pins

| ID | Upstream tag | 用途 |
|----|--------------|------|
| `20240116.0` | `20240116.0` | 与当前 MPS protobuf 对齐；阶段 1 默认 |
| `20260107.1` | `20260107.1` | 与当前 pdfium_all 对齐；统一目标 |

## 统一原则

1. **进程内只允许一份** `abseil_dll.dll`（内容哈希一致）。  
2. 升 pin = 改 `PIN` / `ABSL_PIN_ID` + 重编 prefix + **所有消费方跟测**。  
3. 未验证的「混用」（例如 pdfium 链 20240116、或 protobuf 29.3 链 20260107）默认 **禁止** 进主路径。
