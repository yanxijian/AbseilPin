# Pin 20260107.1

- **Upstream**: https://github.com/abseil/abseil-cpp  
- **Tag**: `20260107.1`  
- **Commit**: `255c84dadd029fd8ad25c5efb5933e47beaa00c7`（pdfium_all `deps.lock.md`）  
- **Consumers (target)**: pdfium_all；统一后的 MPS（需更高 protobuf）  
- **Not for**: 当前 MPS protobuf v29.3（树内为 20240116）— 直接 package 注入预期配置/链接失败
